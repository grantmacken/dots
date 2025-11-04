--[[ term module
# Objective:
 Manage terminal jobs per tabpage in Neovim.
 Each tabpage has its own dedicated terminal buffer and assocation terminal job with an interactive shell
 that can execute commands sent from other buffers in the same tabpage.

# User Experience:
 - In a working edit buffer % the user can send **commands** to the terminal job in the tabpage's terminal buffer.
 - Focus remains in the working edit buffer % after sending commands.
-  Command results are displayed in the show window's terminal buffer.

# Implementation Details:
  - The is one termID buffer per tabpage
  - The handler for the termID buffer is stored in tab variable `vim.t.termID`
  - A terminal job is started in the termID buffer with the user's default shell (vim.o.shell) which in my case is bash
  - The terminal job runs in a pseudo-terminal (term=true) which allows interactive programs to run.
  - When the terminal job is started for the term buffer, the channel ID is stored in tab variable `vim.t.chanID`
  - If the terminal job is already running, it is reused.
  - The terminal job can be sent commands via the channel using chansend(chanID, cmd)
  - The terminal job can be checked if it is still running using jobwait({chanID}, 0)
  - The command are command that the bash shell can execute.
  - The first command to run in the terminal job is usually an empty string to just open the shell.
  - The first word of the command is the program to execute, the rest are its arguments.
  - A check is made to ensure the command is executable before starting the terminal job.
  - The terminal job runs in the current working directory of Neovim (vim.loop.cwd())
  - The terminal job has a clean environment (clear_env=true) with some variables set (env=get_env())

TODO:
 - if terminal job exits clean up tab variables for termID and chanID
 - use terminal autocmd to detect terminal job exit

 improve error handling and notifications
 add more validation functions
 add more helper functions
 add tests
 add examples
 add documentation


--
terminal management per tabpage:
  - buffer(): get or create a scratch buffer for terminal
  - chan(): get or create a channel for terminal job
  - send(cmd): send command to terminal job

validation functions:
  - is_executable(tbl): validate command table
  - is_running(jobID): check if job is still running
  - is_string(cmd): validate command string
helpers:
  - string_to_table(str): split string into table by spaces

--]]
--
local M = {}
M.version = "0.1.0"

--
--- setup environment variables for terminal job
---  @see https://neovim.io/doc/user/job_control.html#jobstart()
---- @return table
local get_env = function()
  local env = vim.tbl_extend("force", {}, vim.uv.os_environ(), {
    NVIM = vim.v.servername,
    NVIM_LISTEN_ADDRESS = false,
    NVIM_LOG_FILE = false,
    VIM = false,
    VIMRUNTIME = false,
    -- TERM = "xterm-256color", -- set by default when term=true
  })
  return env
end

---@param str string
--- @return table
local function string_to_table(str)
  -- regex split string into table by one or more spaces
  -- handles quoted strings as single arguments
  return vim.split(str, '%s+', { trimempty = true })
end

--- check if command is executable
--- @param tbl table
--- @return boolean
local is_executable = function(tbl)
  if type(tbl) ~= 'table' or #tbl == 0 then
    vim.notify('Invalid command table provided: ' .. vim.inspect(tbl), vim.log.levels.ERROR)
    return false
  end
  local cmd_name = tbl[1]
  if not cmd_name or not vim.fn.executable(cmd_name) then
    vim.notify('Command not found: ' .. tostring(cmd_name), vim.log.levels.ERROR)
    return false
  end
  return true
end

---@param cmd string
--- @return boolean
local is_string = function(cmd)
  if type(cmd) ~= 'string' or cmd == '' then
    vim.notify('Invalid command provided: ' .. vim.inspect(cmd), vim.log.levels.ERROR)
    return false
  end
  return true
end

--- @param jobID number|nil
--- @return boolean
local is_running = function(jobID)
  if not jobID then
    return false
  end
  -- @see h: jobwait()
  -- Waits for jobs to finish. {timeout} is in milliseconds.
  -- When {timeout} is zero, it does not wait.
  -- Returns a list of exit codes, one for each job in {jobs}.
  -- If a job is not finished yet, the corresponding entry will be -1.
  -- A job is considered finished when it has exited and all output has been
  -- read.
  if vim.fn.jobwait({ jobID }, 0)[1] == -1 then
    return true
  end
  return false
end




---@return integer bufnr existing or created scratch buffer or zero on failure
M.buffer = function()
  local tabID      = vim.api.nvim_get_current_tabpage()
  local ok, termID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'termID')
  if ok then
    vim.notify('Reusing existing term buffer' .. vim.inspect(termID), vim.log.levels.INFO)
    return termID
  else
    vim.notify('Creating new term buffer', vim.log.levels.INFO)
    local oScratch = true  -- scratch buffer (not saved to disk)
    local oListed  = false -- not listed in buffer list
    vim.t.termID   = vim.api.nvim_create_buf(oListed, oScratch)
    return vim.t.termID
  end
end

M.chan = function()
  local tabID = vim.api.nvim_get_current_tabpage()
  local ok_term, termID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'termID')
  if not ok_term then
    vim.notify('No term buffer found for this tabpage', vim.log.levels.ERROR)
    return 0
  end
  local ok_chan, chanID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'chanID')
  if ok_chan then
    vim.notify('Reusing existing channel' .. vim.inspect(chanID), vim.log.levels.INFO)
    return chanID
  else
    vim.notify('Creating new term job', vim.log.levels.INFO)
    vim.notify(vim.inspect(vim.o.shell), vim.log.levels.INFO)
    vim.api.nvim_buf_call(termID, function()
      --[[ @see h: jobstart()()
jobstart({cmd} [, {opts}])                         *jobstart()*
  Start job {cmd} in the background.  This is similar to
  system()|.  {cmd} is a string or a list.  If it is a string
  it is split into words with shell-like syntax.  If it is a
  list, it is used directly.  The first item is the program
  to execute, the rest are its arguments.
term: (boolean) Spawns {cmd} in a new pseudo-terminal session
  connected to the current (unmodified) buffer. Implies "pty".
  Default "height" and "width" are set to the current window
  dimensions. jobstart()|. Defaults $TERM to "xterm-256color".
]] --

      local shell = vim.o.shell
      local opts = {
        cwd = vim.loop.cwd(),
        term = true,      -- Spawns {cmd} in a new pseudo-terminal session
        clear_env = true, -- start with a clean environment
        env = get_env(),  -- set up environment variables
        --stdout_buffered = true, -- buffer stdout until job exits
        -- stderr_buffered = true, -- buffer stderr until job exits
        -- pty = false,            -- use a pseudo-terminal
      }
      vim.t.chanID = vim.fn.jobstart(shell, opts)
      return vim.t.chanID
    end)
  end
end

-- Send data to channel {id}.

M.send = function(cmd)
  local tabID = vim.api.nvim_get_current_tabpage()
  local ok, chanID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'chanID')
  if ok then
    -- Prefix with Ctrl-U to clear the line, preventing echo duplication
    vim.fn.chansend(chanID, cmd)
  end
end

return M
