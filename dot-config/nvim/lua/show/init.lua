--[[ Show Module
 @see dot-config/nvim/lua/show/init.lua
 @see dot-config/nvim/plugin/09_actions.lua
 ]] ---
M = {}

--[[ buffer states
vim.api.nvim_buf_is_loaded(bufnr)
 vim.fn.buflisted(bufnr)
 vim.bo[bufnr].bufhidden hide|unload|delete|wipe

 'bufhidden' (string) (default "")
  'bufhidden' 'bh'	string (default "")
  	When this option is set to "hide", the buffer becomes hidden
	when it is abandoned (that is, when it is no longer displayed in
	a window and another buffer is displayed in its place).  A hidden
	buffer becomes unloaded when Vim needs to allocate memory for
	other stuff.  If the buffer was changed, you are asked to save it
	first.  If you do not want to be asked, set the 'hidden' option.
 --]] --
--
--vim.api.nvim_set_hl(0, 'WinBar', { fg = 'white', bg = '#3C3C3C', bold = true })
-- vim.api.nvim_set_hl(0, 'WinBarNC', { fg = 'LightGrey', bg = '#2C2C2C' })
--
--
--[[ utils ]] --
-- check if buffer is valid
-- @param buf number|nil
-- @return boolean
local function is_buf_valid(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end
-- check if buffer is modified
-- @param bufnr number
-- @return boolean
local function is_buf_modified(bufnr)
  if not is_buf_valid(bufnr) then
    return false
  end
  return vim.bo[bufnr].modified
end

-- check if window is valid
-- @param win number|nil
-- @return boolean
-- local win_valid(win)
--   return win and vim.api.nvim_win_is_valid(win)
-- end

-- check if window is open and valid
--- @param win number|nil
--- @return boolean
local function is_open(win)
  return win and vim.api.nvim_win_is_valid(win)
end

--- @param job_id number|nil
--- @return boolean
local function is_running(job_id)
  if not job_id then
    return false
  end
  -- @see h: jobwait()
  -- Waits for jobs to finish. {timeout} is in milliseconds.
  -- When {timeout} is zero, it does not wait.
  -- Returns a list of exit codes, one for each job in {jobs}.
  -- If a job is not finished yet, the corresponding entry will be -1.
  -- A job is considered finished when it has exited and all output has been
  -- read.
  if vim.fn.jobwait({ job_id }, 0)[1] == -1 then
    return true
  end
  return false
end

-- check if window is focused
--- @param win number|nil
--- @return boolean
local function is_focused(win)
  return is_open(win) and vim.api.nvim_get_current_win() == win
end

--
--
--- @param cmd string
--- @return boolean
local function is_string(cmd)
  if type(cmd) ~= 'string' or cmd == '' then
    vim.notify('Invalid command provided: ' .. vim.inspect(cmd), vim.log.levels.ERROR)
    return false
  end
  return true
end

--- check if command is executable
--- @param tbl table
--- @return boolean
local function is_executable(tbl)
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

--- Convert a space-separated string into a table of arguments.
--- @param str string
--- @return table
local function string_to_table(str)
  -- regex split string into table by one or more spaces
  -- handles quoted strings as single arguments
  return vim.split(str, '%s+', { trimempty = true })
end

-- create a job_buf table to keep track of jobs and buffers
M.job_buf = {}

-- create a job_buf_teminal
-- @see :h nvim_create_buf()
-- listed: (boolean) When true, the buffer is listed in the buffer list
-- scratch: (boolean) When true, the buffer is a scratch buffer
--- @return number bufnr
local function jobs_buffer()
  if is_buf_valid(vim.t.jobs_buf) then
    local bufnr              = vim.t.jobs_buf
    --vim.bo[bufnr].bufhidden  = 'hide'
    --vim.bo[bufnr].buftype    = 'nofile'             -- Scratch buffers typically use 'nofile'
    vim.bo[bufnr].modifiable = true                 -- Allow modifications
    vim.bo[bufnr].modified   = false                -- Clear modified flag
    vim.api.nvim_buf_set_name(bufnr, 'another job') -- set a name for the buffer
    return vim.t.jobs_buf
  end
  local listed             = false
  local scratch            = true
  -- when creating a job_buf set a tabpage variable.
  -- This is the handle to ensure the same 'job_buf' buffer is to used in the same tabpage
  vim.t.jobs_buf           = vim.api.nvim_create_buf(listed, scratch)
  local bufnr              = vim.t.jobs_buf
  vim.bo[bufnr].bufhidden  = 'hide'
  vim.bo[bufnr].buftype    = 'nofile'      -- Scratch buffers typically use 'nofile'
  vim.bo[bufnr].modifiable = true          -- Allow modifications
  vim.bo[bufnr].modified   = false         -- Clear modified flag

  vim.api.nvim_buf_set_name(bufnr, 'jobs') -- set a name for the buffer
  return bufnr
end
--
--
--- Create or get a noninteractive terminal buffer
--- In buffer we  nvim_open_term to open a terminal in the buffer
--- We keep the channel handle in a tab variable.
--- With this handle we can send data to the terminal via nvim_chan_send
--- THe idea is that the terminal is opened once per tabpage and reused thereafter
--- If the buffer or channel is closed or invalid a new one is created
--- @return number bufnr
local function noninteractive_term_buffer()
  if is_buf_valid(vim.t.noninteractive_term_buf) then
    return vim.t.noninteractive_term_buf
  end
  -- create a new buffer if it doesn't exist or is invalid
  -- not listed, not scratch
  -- see :h nvim_create_buf()
  -- listed: (boolean) When true, the buffer is listed in the buffer list
  -- scratch: (boolean) When true, the buffer is a scratch buffer
  local listed = false
  local scratch = false
  -- when creating a noninteractive terminal buffer set a tabpage variable.
  -- This is the handle to ensure the same 'noninteractive_term_buf' buffer is to used in the same tabpage
  vim.t.noninteractive_term_buf = vim.api.nvim_create_buf(listed, scratch)
  local bufnr = vim.t.noninteractive_term_buf
  -- for this buffer set buffer options
  vim.bo[bufnr].bufhidden = 'hide'                            -- hide when abandoned
  vim.bo[bufnr].filetype = 'terminal'                         -- set filetype to terminal
  vim.bo[bufnr].modifiable = false                            -- make buffer non-modifiable
  vim.bo[bufnr].scrollback = 10000                            -- Allow scrollback
  vim.bo[bufnr].swapfile = false                              -- no swapfile
  vim.bo[bufnr].undofile = false                              -- no undo file
  vim.api.nvim_buf_set_name(bufnr, 'noninteractive-terminal') -- set a name for the buffer
  -- For this tab Open terminal channel once
  -- see :h nvim_open_term()
  -- opts: table (optional) with keys:
  --   force_crlf: boolean (default false) - if true, translate NL to CR NL
  -- returns: channel id or 0 on error
  -- The channel can be used in |chansend()| to send data to the terminal.
  -- If the channel is closed, it will be set to 0.
  -- If the terminal is closed, the channel will be closed (set to 0).
  local chan = vim.api.nvim_open_term(bufnr, { force_crlf = true })
  if not (chan and chan > 0) then
    vim.notify('Failed to open terminal in buffer ' .. bufnr, vim.log.levels.ERROR)
    return bufnr
  end
  -- To get a handle on the channel set the channel as a tab page variable
  vim.t.noninteractive_term_chan = chan
  vim.notify('Opened terminal channel ' .. chan .. ' in buffer ' .. bufnr)
  return bufnr
end
--- Create or get an interactive terminal buffer
local function interactive_term_buffer()
  if is_buf_valid(vim.t.interactive_term_buf) then
    local bufnr = vim.t.interactive_term_buf
    -- Clear modified flag when reusing buffer
    vim.bo[bufnr].modified = false
    return bufnr
  end
  local listed               = false
  local scratch              = false
  vim.t.interactive_term_buf = vim.api.nvim_create_buf(listed, scratch)
  local bufnr                = vim.t.interactive_term_buf
  vim.bo[bufnr].bufhidden    = 'hide'
  vim.bo[bufnr].filetype     = 'terminal'
  vim.bo[bufnr].modified     = false
  vim.api.nvim_buf_set_name(bufnr, 'interactive-terminal')

  -- Add autocmd to clean up on terminal close
  vim.api.nvim_create_autocmd('TermClose', {
    buffer = bufnr,
    callback = function()
      vim.schedule(function()
        vim.bo[bufnr].channel = 0
        vim.bo[bufnr].modified = false
      end)
    end,
  })

  return bufnr
end

local function scratch_buffer()
  if vim.t.scratch_buf and vim.api.nvim_buf_is_valid(vim.t.scratch_buf) then
    return vim.t.scratch_buf
  end
  local listed            = false
  local scratch           = true
  vim.t.scratch_buf       = vim.api.nvim_create_buf(listed, scratch)
  local bufnr             = vim.t.scratch_buf
  vim.bo[bufnr].bufhidden = 'hide'
  vim.bo[bufnr].buftype   = 'nofile'                  -- Scratch buffers typically use 'nofile'
  vim.api.nvim_buf_set_name(bufnr, 'scratch_my_itch') -- set a name for the buffer
end

--- Open or reuse a window to show the buffer
--- @param bufnr number  buffer number
--- @return number win|nil window number or nil on error
local function open_show_window(bufnr)
  -- if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
  --   vim.notify('Invalid buffer number provided: ' .. tostring(bufnr), vim.log.levels.ERROR)
  --   return nil
  -- end
  local win = vim.t.show_win or nil
  if -- already open and the buffer is in show window
      win and
      vim.api.nvim_win_is_valid(win) and
      vim.api.nvim_win_get_buf(win) == bufnr
  then
    vim.notify('window ' .. win .. ' already open for buffer ' .. bufnr)
    vim.api.nvim_win_set_buf(win, bufnr) -- ensure the buffer is set in the window
    return win
  end

  if -- win already open and the buffer is not in show window
      win and
      vim.api.nvim_win_is_valid(win) and
      vim.api.nvim_win_get_buf(win) ~= bufnr
  then
    require('mini.bufremove').unshow_in_window(win) -- remove existing buffer from window
    vim.api.nvim_win_set_buf(win, bufnr)            -- set the buffer in the window

    vim.notify('reused window ' .. win .. ' for buffer ' .. bufnr)
    return win
  end


  -- otherwise create new window for the buffer
  -- if win and vim.api.nvim_win_is_valid(vim.t.show_win) then
  --   vim.api.nvim_win_close(vim.t.show_win, true)
  -- end
  --
  -- vim.api.keyset.win_config
  --
  --- create a new split window for buffer bufnr at the bottom of the screen
  -- local vwin = vim.api.nvim_get_current_win() -- current window

  vim.notify(' - opening new window for buffer ' .. bufnr)
  local height = math.floor(vim.o.lines * 0.3)
  local enter = false -- do not enter the window after creation
  -- see h: api-win_config
  -- opts: table (optional) with keys
  local config = {
    height = height,
    split = 'below',
    style = 'minimal',
    width = vim.o.columns,
    win = -1,
  }
  win = vim.api.nvim_open_win(bufnr, enter, config)

  if not (win and vim.api.nvim_win_is_valid(win)) then
    vim.notify('Failed to open window for buffer ' .. bufnr, vim.log.levels.ERROR)
    return nil
  end
  -- set this show window as a tab scoped variable
  vim.t.show_win = win
  -- sorted window options
  --[[ minimal style
  Disables
  'number',
  'relativenumber',
  'cursorline',
  'cursorcolumn',
  'foldcolumn',
  'spell' and
  'list'
  options.
  'signcolumn' is changed to `auto` and
  'colorcolumn' is cleared.
  'statuscolumn' is changed to empty.
  The end-of-buffer region is hidden by setting`eob` flag of 'fillchars' to a space char,
  and clearing the |hl-EndOfBuffer| region in 'winhighlight'.
  ]]

  vim.wo[win].sidescrolloff = 0
  vim.wo[win].winbar = "## %{bufname('%')} ## window [%{bufwinid('%')}] buffer [%{bufnr('%')}] buftype [%{&buftype}]"
  vim.wo[win].winfixheight = true
  vim.wo[win].wrap = false
  -- vim.wo[win].statuscolumn = " "
  vim.notify(' - opened window ' .. win .. ' for buffer ' .. bufnr)
  return win
end

--[[ After results show utils
 - move the cursor to the end of the buffer
 - clear lines in buffer before cmd results are added

]] --

local function move_cursor_to_end(bufnr, win)
  vim.schedule(function()
    if not (bufnr and win) then
      return
    end
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    vim.api.nvim_win_set_cursor(win, { line_count, 9999 })
  end)
end

local function clear_buffer(bufnr)
  vim.schedule(function()
    -- check if buffer is modifable
    -- only clear if modified
    if is_buf_modified(bufnr) then
      if vim.bo[bufnr].modifiable == false then
        vim.bo[bufnr].modifiable = true
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        if line_count > 1 then
          local strict = false
          local start_line = 0
          local end_line = line_count - 1 -- -1 because end_line is exclusive
          vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, strict, {})
        end
        vim.bo[bufnr].modifiable = false
      end
    end
  end)
end

-- append new lines
-- @param bufnr number
-- @param res table
local function append_lines(bufnr, res)
  vim.schedule(function()
    local strict = false
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local start_line = 1
    local end_line = line_count + #res - 1 -- -1 because end_line is exclusive
    vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, strict, res)
    -- move cursor to the end
  end)
end

--[[
This is useful to display ANSI
terminal sequences returned as part of an RPC message, or similar.
It creates a hidden terminal buffer, opens it in a window, and sends
the command output to the terminal.
]] --
---@param cmd string
M.noninteractive_term = function(cmd)
  -- massage the command input
  if not is_string(cmd) then
    return
  end
  -- convert string to table
  local tbl = string_to_table(cmd)
  if not is_executable(tbl) then
    return
  end
  -- create or get the noninteractive terminal buffer
  local bufnr = noninteractive_term_buffer()
  --vim.api.nvim_buf_call(bufnr, vim.cmd.term) -- start terminal in buffer
  -- local bufnr = vim.t.noninteractive_term_buf
  vim.notify('buffer ' .. bufnr .. ' ready')
  if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
    vim.notify('Invalid buffer number: ' .. tostring(bufnr), vim.log.levels.ERROR)
    return
  end
  -- open or reuse a window to show the buffer
  local win = open_show_window(bufnr)
  if not win then
    return
  end
  vim.notify('window ' .. win .. ' ready')
  -- clear_buffer(bufnr)
  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
  vim.bo[bufnr].modifiable = false
  vim.api.nvim_buf_call(bufnr, vim.cmd.redraw) -- ensure buffer is redrawn
  local chan = vim.t.noninteractive_term_chan
  if not (chan and chan > 0) then
    vim.notify('no channel, opening terminal in buffer ' .. bufnr)
  end
  -- Run command and send output to terminal
  vim.system(tbl, { text = true }, function(obj)
    vim.schedule(function()
      -- Send stdout (which contains ANSI codes) to terminal channel
      if obj.stdout and obj.stdout ~= '' then
        vim.api.nvim_chan_send(chan, obj.stdout)
      end
      -- Send stderr if present
      if obj.stderr and obj.stderr ~= '' then
        vim.api.nvim_chan_send(chan, '\n[stderr]\n' .. obj.stderr)
      end
      -- Show exit code if non-zero
      if obj.code ~= 0 then
        vim.api.nvim_chan_send(chan, '\n[exit code: ' .. obj.code .. ']\n')
      end
      move_cursor_to_end(bufnr, win)
    end)
  end)
end


--[[
--- Run a job via jobstart and show output in a terminal buffer
--- see :h jobstart()
]] --
---@param cmd string
M.job_term = function(cmd)
  if not is_string(cmd) then
    return
  end
  local tbl = string_to_table(cmd)
  if not is_executable(tbl) then
    return
  end
  local bufnr = jobs_buffer()
  -- ensure buffer is valid and not modified
  -- if is_buf_modified(bufnr) then
  --   vim.notify('Buffer ' .. bufnr .. ' is modified', vim.log.levels.INFO)
  -- end

  vim.notify('buffer ' .. bufnr .. ' ready')
  open_show_window(bufnr)
  local win = vim.t.show_win
  vim.notify('window ' .. win .. ' ready')
  -- vim.api.nvim_buf_call(bufnr, vim.cmd.term)

  vim.api.nvim_win_call(win, function()
    -- run the job asynchronously and capture output
    local env = vim.tbl_extend("force", {}, vim.uv.os_environ(), {
      NVIM = vim.v.servername,
      NVIM_LISTEN_ADDRESS = false,
      NVIM_LOG_FILE = false,
      VIM = false,
      VIMRUNTIME = false,
      TERM = "xterm-256color",
    })
    local job_id = vim.fn.jobstart(tbl, {
      cwd = vim.loop.cwd(),
      term = true,            -- start a terminal job (needed for ANSI sequences)
      clear_env = true,       -- start with a clean environment
      env = env or nil,       -- set environment variables
      pty = true,             -- ?? use a pseudo-terminal (needed for ANSI sequences)
      stdout_buffered = true, -- buffer stdout until job exits
      stderr_buffered = true, -- buffer stderr until job exits
      -- callbacks
      on_stdout = function(_, data, _)
        if data then
          --append_lines(bufnr, data)
          move_cursor_to_end(bufnr, win)
        end
      end,
      on_stderr = function(_, data, _)
        if data then
          --append_lines(bufnr, data)
          move_cursor_to_end(bufnr, win)
        end
      end,
      on_exit = function(_, code, _)
        --append_lines(bufnr, { 'Process exited with code: ' .. code })
        move_cursor_to_end(bufnr, win)
        -- vim.api.nvim_set_current_win(win)
        -- vim.cmd.startinsert()
      end,
    })
    if job_id <= 0 then
      vim.notify('Failed to start job for command: ' .. cmd, vim.log.levels.ERROR)
      return
    end
    vim.notify('Started job ' .. job_id .. ' for command: ' .. cmd)
    -- store the job_id and buffer in the job_buf table
    M.job_buf[job_id] = {
      bufnr = bufnr,
      cmd = cmd,
    }
  end)
end

--[[ Interactive Terminal
Opens a persistent interactive terminal buffer that can be reused across commands.

@module show

Features:
- Buffer handle stored in vim.t.interactive_term_buf (per-tabpage)
- Reuses existing terminal session if available
- Supports multiple modes: focus, blur, back, insert
- Auto-creates new terminal if channel is closed or invalid

Modes:
- focus: Open terminal in show window and enter insert mode at prompt
- blur: Send command but keep focus on current window
- back: Send command then return to previous window (Ctrl-O behavior)
- insert: Open terminal and enter insert mode

@see open_show_window For window management
@see interactive_term_buffer For buffer creation
]] --

--- Send a command to the interactive terminal
--- @param cmd string The command to execute in the terminal
--- @param opts? { mode?: 'focus'|'blur'|'back'|'insert', env?: table<string, string>, shell?: string }
--- @return nil
M.interactive_term = function(cmd, opts)
  opts = opts or {}
  local mode = opts.mode or 'focus'
  local env = opts.env
  local shell = opts.shell or vim.o.shell

  if not is_string(cmd) then
    return
  end
  local tbl = string_to_table(cmd)
  if not is_executable(tbl) then
    return
  end
  --[[
{data} may be a string, string convertible, |Blob|, or a list.
If {data} is a list, the items will be joined by newlines; any
newlines in an item will be sent as NUL. To send a final
newline, include a final empty string.
]] --
  -- append final empty string to ensure newline at end
  -- this ensures the command is executed in the terminal
  if tbl[#tbl] ~= '' then
    table.insert(tbl, '')
  end
  interactive_term_buffer()
  local bufnr = vim.t.interactive_term_buf
  open_show_window(bufnr)
  local win = vim.t.show_win

  -- Start terminal in the buffer if not already started
  if not vim.bo[bufnr].channel or vim.bo[bufnr].channel == 0 then
    -- Clear any stale content from previous terminal session
    if vim.api.nvim_buf_line_count(bufnr) > 1 then
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
    end
    vim.bo[bufnr].modified = false

    vim.api.nvim_buf_call(bufnr, function()
      local job_opts = {
        term = true,
        pty = true,
      }

      if env then
        job_opts.env = env
      end

      vim.fn.jobstart(shell, job_opts)
    end)
  end

  local chan = vim.bo[bufnr].channel
  if chan and chan > 0 then
    local ok, err = pcall(vim.fn.chansend, chan, tbl)
    if not ok then
      vim.notify('Failed to send command to terminal: ' .. tostring(err), vim.log.levels.ERROR)
      -- Try to restart terminal
      vim.bo[bufnr].channel = 0
      return M.interactive_term(cmd, opts) -- Retry once
    end

    -- Handle different modes
    vim.schedule(function()
      move_cursor_to_end(bufnr, win)

      if mode == 'focus' then
        -- Focus terminal in insert mode
        vim.api.nvim_set_current_win(win)
        vim.cmd.startinsert()
      elseif mode == 'back' then
        -- Move cursor to last window (Ctrl-O behavior)
        vim.cmd.wincmd('p')
      elseif mode == 'insert' then
        -- Just enter insert mode without focusing
        vim.api.nvim_set_current_win(win)
        vim.cmd.startinsert()
      elseif mode == 'blur' then
        -- Keep focus on original window, don't enter terminal
        -- Do nothing - just send command
      end
    end)
  else
    vim.notify('Failed to get terminal channel for buffer ' .. bufnr, vim.log.levels.ERROR)
  end
end

--- Open or focus the interactive terminal without sending a command
--- @return nil
M.interactive_term_open = function()
  local bufnr = interactive_term_buffer()

  -- Check if terminal is still running
  if not vim.bo[bufnr].channel or vim.bo[bufnr].channel == 0 then
    vim.api.nvim_buf_call(bufnr, function()
      vim.fn.jobstart(vim.o.shell, {
        term = true,
        pty = true,
      })
    end)
  end

  open_show_window(bufnr)
  local win = vim.t.show_win

  vim.schedule(function()
    move_cursor_to_end(bufnr, win)
    vim.api.nvim_set_current_win(win)
    vim.cmd.startinsert()
  end)
end

--- Toggle the interactive terminal window
--- @return nil
M.interactive_term_toggle = function()
  local win = vim.t.show_win

  -- If window is open and has interactive terminal, close it
  if is_open(win) then
    local bufnr = vim.api.nvim_win_get_buf(win)
    if bufnr == vim.t.interactive_term_buf then
      vim.api.nvim_win_close(win, false)
      vim.t.show_win = nil
      return
    end
  end

  -- Otherwise open it
  M.interactive_term_open()
end

--- @param cmd string
M.scratch = function(cmd)
  if not is_string(cmd) then
    return
  end
  if not is_executable(string_to_table(cmd)) then
    return
  end
  local tbl = {}
  tbl[1] = 'bash'
  tbl[2] = '-c'
  tbl[3] = cmd
  scratch_buffer()
  local bufnr = vim.t.scratch_buf
  vim.notify('buffer ' .. bufnr .. ' ready')
  open_show_window(bufnr)
  local win = vim.t.show_win
  vim.notify('window ' .. win .. ' ready')
  -- run the command asynchronously and capture output
  vim.system(
    tbl, { text = true }, function(obj)
      -- check for errors
      if obj.code ~= 0 then
        vim.notify('Error running command: ' .. (obj.stderr or 'unknown error'), vim.log.levels.ERROR)
        return
      end
      local res = vim.split(obj.stdout, '\n')
      clear_buffer(bufnr)
      append_lines(bufnr, res)
      move_cursor_to_end(bufnr, win)
    end)
end

return M
