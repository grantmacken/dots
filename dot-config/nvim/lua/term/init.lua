--[[ term module

# Objective:
 - Manage terminal buffers and jobs per tabpage in Neovim.
 1. Each tabpage has one *shell* terminal buffer. This terminal buffer runs a shell like bash with a prompt ready to accept commands.
 2. Each tabpage has one *tasks* terminal buffer. This terminal buffer receives input from the running system commands.
  `vim.system()` is used to run commands asynchronously and send output to the tasks terminal buffer.
  This buffer is useful for long-running tasks, background jobs,  testing, or running a REPL.
 3. The terminal buffers are opened in a dedicated show window managed by the show module.


# User Experience:
 - In a working edit buffer % the user can send **commands** to the terminal job in the tabpage's terminal buffer.
 - Focus remains in the working edit buffer % after sending commands.
-  Command results are displayed in the show window's terminal buffer.

# Implementation Details:
  - The is one buf_shell buffer per tabpage
  - The handler for the buf_shell buffer is stored in tab variable `vim.t.shellID`
  - A terminal job is started in the buf_shell buffer with the user's default shell (vim.o.shell) which in my case is bash
  - The terminal job runs in a pseudo-terminal (term=true) which allows interactive programs to run.
  - When the terminal job is started for the term buffer, the channel ID is stored in tab variable `vim.t.chan_shell`
  - If the terminal job is already running, it is reused.
  - The terminal job can be sent commands via the channel using chansend(chan_shell, cmd)
  - The terminal job can be checked if it is still running using jobwait({chan_shell}, 0)
  - The command are command that the bash shell can execute.
  - The first command to run in the terminal job is usually an empty string to just open the shell.
  - The first word of the command is the program to execute, the rest are its arguments.
  - A check is made to ensure the command is executable before starting the terminal job.
  - The terminal job runs in the current working directory of Neovim (vim.loop.cwd())
  - The terminal job has a clean environment (clear_env=true) with some variables set (env=get_env())

TODO:
 - if terminal job exits clean up tab variables for buf_shell and chan_shell
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

--[[ command string utilities
 - is_string(cmd): validate command string
 - string_to_table(str): split string into table by spaces
 - is_executable(tbl): validate command table
 - is_running(jobID): check if job is still running
 - append_nl(str): append newline to string if not present

--]] --
--

-- validate command is a non-empty string
---@param cmd string
--- @return boolean
local is_string = function(cmd)
  if type(cmd) ~= 'string' or cmd == '' then
    vim.notify('Invalid command provided: ' .. vim.inspect(cmd), vim.log.levels.ERROR)
    return false
  end
  return true
end

--- convert string to table by splitting on spaces
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

--- append newline to string if not present
--- @param str string
--- @return string
local append_nl = function(str)
  if str:sub(-1) ~= '\n' then
    str = str .. '\n'
  end
  return str
end

-- param list ['buf_shell' | 'buf_tasks']
---@return boolean true if channel exists, false otherwise
---@param name string  a valid vim.t.{} variable name
local is_chan = function(name)
  local tabID = vim.api.nvim_get_current_tabpage()
  local ok, chanID = pcall(vim.api.nvim_tabpage_get_var, tabID, name)
  if ok then
    return true
  else
    return false
  end
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

--[[
jobstart({cmd} [, {opts}])                         *jobstart()*
  Start job {cmd} in the background.  This is similar to
  system()|.  {cmd} is a string or a list.  If it is a string
  it is split into words with shell-like syntax.  If it is a
  list, it is used directly.  The first item is the program
  to execute, the rest are its arguments.
]] --
--[[ {opts} is a dictionary with these entries:
- term: (boolean) Spawns {cmd} in a new pseudo-terminal session
  connected to the current (unmodified) buffer. Implies "pty".
- defaults: "height" and "width" are set to the current window dimensions. jobstart()
            also defaults $TERM to "xterm-256color".
 - clear_env: (boolean) Start with a clean environment.  Only the variables
             in "env" are set.
 - cwd: (string) Set the working directory of the job to {cwd}.
 - env: (dictionary) Set environment variables for the job.  Each key
         is the name of an environment variable, the value is the value
         of the variable.  When "clear_env" is not set, these variables
         are added to the current environment.  When "clear_env" is set,
         only these variables are set.
--]] --


--- @see h: jobstart()
--- Get or create a terminal channel running the user's shell in the buf_shell buffer
--- There is one shell channel per tabpage
--- The channel ID is stored in tab variable `vim.t.chan_shell`
--- @return integer chan_shell channel ID or zero on failure
M.chan_shell = function()
  local tabID = vim.api.nvim_get_current_tabpage()
  local ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, tabID, 'buf_shell')
  if not ok then
    vim.notify('Shell buffer not found for this tabpage', vim.log.levels.ERROR)
    return 0
  end
  if is_chan('chan_shell') then
    return vim.api.nvim_tabpage_get_var(tabID, 'chan_shell')
  end
  -- create new shell channel
  vim.api.nvim_buf_call(bufnr, function()
    local env = vim.tbl_extend("force", {}, vim.uv.os_environ(), {
      NVIM = vim.v.servername,
      NVIM_LISTEN_ADDRESS = false,
      NVIM_LOG_FILE = false,
      VIM = false,
      VIMRUNTIME = false,
      -- TERM = "xterm-256color", -- set by default when term=true
    })
    local shell = vim.o.shell
    local opts = {
      cwd = vim.loop.cwd(),
      term = true,      -- Spawns {cmd} in a new pseudo-terminal session
      clear_env = true, -- start with a clean environment
      env = env,        -- set up environment variables
      --stdout_buffered = true, -- buffer stdout until job exits
      -- stderr_buffered = true, -- buffer stderr until job exits
      -- pty = false,            -- use a pseudo-terminal
    }
    vim.t.chan_shell = vim.fn.jobstart(shell, opts)
    local chan_shell = vim.t.chan_shell
    -- clear terminal on start
    vim.fn.chansend(chan_shell, append_nl('clear'))
    return chan_shell
  end)
end
--- Send data to channel {id}.
--- The data is sent as if typed by a user in the terminal.
--- @param cmd string command to send
--- @return nil
M.send_shell_cmd = function(cmd)
  if not is_string(cmd) then return end
  if not is_executable(string_to_table(cmd)) then return end
  local tabID = vim.api.nvim_get_current_tabpage()
  local ok, chan_shell = pcall(vim.api.nvim_tabpage_get_var, tabID, 'chan_shell')
  if ok then
    vim.fn.chansend(chan_shell, append_nl(cmd))
  end
end

M.send_cmd = function(cmd)
  local show = require('show')
  show.window(show.buffer('buf_shell'))
  M.chan_shell()
  M.send_shell_cmd(cmd)
end





--- @see h: nvim_open_term
--[[
This is useful to display ANSI terminal sequences returned as part of an RPC message, or similar.
It creates a hidden terminal buffer, opens it in a window, and sends the command output to the terminal.
NOTE: This is different from :terminal command which starts a terminal job.
Use `vim.system` to create the data to send to the terminal opened with nvim_open_term.
]] --

M.chan_tasks = function()
  local tabID = vim.api.nvim_get_current_tabpage()
  local ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, tabID, 'buf_tasks')
  if not ok then
    vim.notify('Tasks buffer not found for this tabpage', vim.log.levels.ERROR)
    return 0
  end
  if is_chan('chan_tasks') then
    return vim.api.nvim_tabpage_get_var(tabID, 'chan_tasks')
  end
  local opts = {
    force_crlf = true,
  }
  vim.t.chan_tasks = vim.api.nvim_open_term(bufnr, opts)
  return vim.t.chan_tasks
  -- if not (chan and chan > 0) then
  --   vim.notify('Failed to open terminal in buffer ' .. bufnr, vim.log.levels.ERROR)
  --   return 0
  -- end
end

--[[
tput: terminal capabilities
 - set(name): get ANSI code for terminal capability 'name'
 bold: enter bold mode
 sgr0: turn off all attributes (normal text)
--]]

--- Get ANSI codes for bold and normal text
--- @return string bold ANSI code for bold text
M.tput_set = function(tput_name)
  if not is_string(tput_name) then
    return ''
  end
  if tput_name == 'warn' then
    return vim.system({ 'tput', 'setaf', '1' }, { text = true }):wait().stdout
  end
  if tput_name == 'ok' then
    return vim.system({ 'tput', 'setaf', '2' }, { text = true }):wait().stdout
  end
  if tput_name == 'reset' then
    return vim.system({ 'tput', 'sgr0' }, { text = true }):wait().stdout
  end
  -- Text Styling
  local list = {
    'bold',  -- bold
    'dim',   -- dim
    'clear', -- clear screen
    'rev',   --revers
    'rmul',  -- remove underline
    'sgr0',  -- reset all attributes
    'smul',  -- set underline
  }
  if vim.list_contains(list, tput_name) then
    return vim.system({ 'tput', tput_name }, { text = true }):wait().stdout
  end
  return ''
end



--- Write directly to terminal output
--- @see h: nvim_chan_send
--- @param data string the data to send
--- @return nil
M.send_task_data = function(data)
  local tabID = vim.api.nvim_get_current_tabpage()
  local ok, chan_tasks = pcall(vim.api.nvim_tabpage_get_var, tabID, 'chan_tasks')
  if ok then
    -- append_nl(data)
    vim.api.nvim_chan_send(chan_tasks, append_nl(data))
  end
end




return M
