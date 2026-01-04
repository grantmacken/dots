local M = {}
M.version = "0.1.0"
M.description = [[
 Module for managing a per-tab dedicated show window
 for displaying scratch buffers, terminal buffers for shell commands,
 and terminal buffers for project task command output.
 ]]


--[[ Show Module
 Module for managing a per-tab dedicated show window
 tests for this module:
 @see dot-config/nvim/tests/test_show.lua
 commands: that use this module
 @see dot-config/nvim/plugin/15_show.lua

 ## window layout

 THe show window is created below the current window with 30% of the screen height
 and occupies the full width of the screen.

 +-----------------------+
 |                       |
 |       main win        |
 |                       |
 +-----------------------+
 |      show win         |
 +-----------------------+

 Show Module provides functions to open and manage a per tab dedicated window
 The handler for the show window is stored in tab variable `vim.t.winID`

 The tab specific show window is a project-wide window that can be reused
 for different buffers types like scratch, terminal, quickfix, help, etc.

 Window Features:
 - Open or reuse a dedicated show window per tab
 - There is only one show window per tab
 - If show window already exists, reuse it for the new buffer
 - Store window handler in tab variable `vim.t.winID`
 - Use show window winbar to hint buffer types shown in the window
 - More than one buffer type can be shown in the same tab show window
 - Only one buffer is visible at a time. all other buffers are hidden.
 - Use `mini.bufremove` plugin to unshow buffers from the show window

 Buffer Types are of three types :
 - bufScratch:  a scratch buffer for displaying project messages
 - bufShell:    a terminal buffer for running shell commands
 - bufTask:     terminal buffers for running project task commands and sending the output to the terminal task buffer

 The buffers are named via tab variables: the buffer type *prefix* is used
 to identify the buffer type and the buffer name is used to identify the specific buffer.
 Valid buffer names are:
  - bufScratch{Name} a named scratch buffer for displaying project messages
  - bufShell{Name}  a named terminal buffer for running shell commands in the project terminal
  - bufTask{Name}   a named terminal buffer for displaying project task command output in the  terminal

e.g.
  - bufScratchDefault  -- default scratch buffer
  - bufScratchLogs     -- scratch buffer for displaying log messages
  - bufShellBuild      -- terminal buffer for running build commands
  - bufTaskTest         -- terminal buffer for displaying test command output

Each named buffer is stored in a tab variable:
  - vim.t.bufScratch{Name} -> vim buffer handle
  - vim.t.bufShell{Name}   -> vim buffer handle
  - vim.t.bufTask{Name}    -> vim buffer handle

The buffer type prefix is used to determine how to create and manage the buffer.
The tab variable name is used to store the buffer handle i.e the buffer number (bufnr).

Each buffers is persistent and not closed when hidden from the show window.

Each buffer has a dedicated channel for sending data to it.
The type of buffer detirmines what can be sent to it..
  bufShell: shell commands is sent to the open bufShell{Name} channel. - a channel created via jobstart()
  bufTask: data an be sent to the open bufTask{Name} channel - a channel created via nvim_open_term()
  bufScratch: data is written to the scratch buffer by appending lines to the bufScratch

 API Functions:

 Buffer Management:
  create a buffer by name if it does not exist
 -[ ] show.buffer(name)       -- get or create buffer by name
  - name: string  a valid vim.t.{} variable name to store the buffer handle
  - returns: integer bufnr existing or created scratch buffer or zero on failure

 - kill a buffer by name
 - show.kill_buffer(name)  -- delete buffer by name and remove vim.t.{} variable
  - name: string  a valid vim.t.{} variable name storing the buffer handle
  - returns: boolean true on success, false on failure

Window Management:

  - create a show window below the current window with 30% height
 - show.buffer(name)       -- get or create buffer by name
  - name: string  a valid vim.t.{} variable name to store the buffer handle
  - returns: integer bufnr existing or created scratch buffer or zero on failure
 - show.window(bufnr)      -- open or reuse show window for buffer

 Buffer Features:
 - Clear buffer content
 - Append lines to buffer
 - Move cursor to end of buffer
 ]] ---


--- get show window ID for current tabpage
--- @return integer,string winID window ID or zero and error message
local get_winID = function()
  local tabID      = vim.api.nvim_get_current_tabpage()
  local ok, windID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'winID')
  if not ok then
    return 0, 'show window not found for this tabpage'
  end
  return windID, ''
end

--[[ Buffer Utilities
-- ]]
--
--- get buffer number by name
--- @param bufName string buffer name: 'bufScratch'
--- @return integer,string bufnr of buffer or zero and error message
local get_bufnr_by_name = function(bufName)
  local tabID         = vim.api.nvim_get_current_tabpage()
  local buf_ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, tabID, bufName)
  if not buf_ok then
    return 0, 'buffer named' .. bufName .. ' not found for this tabpage'
  end
  return bufnr, ''
end

--- get bufnr for a window in current tabpage
--- @param winID number window ID
--- @return integer,string bufnr buffer number or zero and error message
local get_buf_in_win = function(winID)
  local buf_ok, bufnr = pcall(vim.api.nvim_win_get_buf, winID)
  if not buf_ok then
    return 0, 'fail: no buffer for show window'
  end
  return bufnr, ''
end

-- check if buffer is valid
--- @param bufnr number|nil
--- @return boolean
local is_buf_valid = function(bufnr)
  return bufnr ~= nil
      and type(bufnr) == 'number'
      and bufnr > 0
      and vim.api.nvim_buf_is_loaded(bufnr)
      and vim.api.nvim_buf_is_valid(bufnr)
end

-- check if buffer is modified
-- @param bufnr number
-- @return boolean
local is_buf_modified = function(bufnr)
  if not is_buf_valid(bufnr) then
    return false
  end
  return vim.bo[bufnr].modified
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

-- Send Utilities
--- validate command is a non-empty string
--- @param val any
--- @return boolean
local is_string = function(val)
  return type(val) == 'string' and val ~= ''
end

--- convert string command to table
--- @param str string
--- @return table
local string_to_table = function(str)
  if not is_string(str) then
    return {}
  end
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


local focus_buffer = function(bufnr)
  vim.schedule(function()
    local tabID = vim.api.nvim_get_current_tabpage()
    local ok, winID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'winID')
    if not ok then
      return
    end
    local buf_ok, _ = pcall(vim.api.nvim_win_set_buf, winID, bufnr)
    if not buf_ok then
      return
    end
  end)
end


--- @param bufnr integer buffer number
local clear_buffer = function(bufnr)
  local count_ok, line_count = pcall(vim.api.nvim_buf_line_count, bufnr)
  if not count_ok then
    vim.notify('Failed to get line count: ' .. tostring(line_count), vim.log.levels.ERROR)
    return
  end
  vim.bo[bufnr].modifiable = true
  vim.notify('Buffer is modified, clearing ' .. tostring(line_count) .. ' lines from buffer: ' .. tostring(bufnr),
    vim.log.levels.INFO)
  if line_count > 1 then
    local strict = false
    local start_line = 0
    local end_line = -1 -- -1 means end of buffer
    local set_ok, set_err = pcall(vim.api.nvim_buf_set_lines, bufnr, start_line, end_line, strict, {})
    if not set_ok then
      vim.notify('Failed to clear buffer: ' .. tostring(set_err), vim.log.levels.ERROR)
    end
  end
end

-- append new lines
-- @param tbl table of strings
local append_lines = function(bufnr, tbl)
  vim.schedule(function()
    if vim.bo[bufnr].modifiable == false then
      vim.bo[bufnr].modifiable = true
    end
    local count_ok, start_line = pcall(vim.api.nvim_buf_line_count, bufnr)
    if not count_ok then
      vim.notify('Failed to get line count: ' .. tostring(start_line), vim.log.levels.ERROR)
      return
    end
    local strict = false
    local end_line = start_line + #tbl - 1 -- -1 because end_line is exclusive
    local set_ok, set_err = pcall(vim.api.nvim_buf_set_lines, bufnr, start_line, end_line, strict, tbl)
    if not set_ok then
      vim.notify('Failed to append lines: ' .. tostring(set_err), vim.log.levels.ERROR)
    end
    vim.bo[bufnr].modifiable = false
  end)
end


local move_cursor_to_end = function(bufName)
  local bufnr, _ = get_bufnr_by_name(bufName)
  if bufnr == 0 then
    return
  end
  local tabID = vim.api.nvim_get_current_tabpage()
  local ok, winID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'winID')
  if not ok then
    return
  end
  vim.schedule(function()
    local count_ok, line_count = pcall(vim.api.nvim_buf_line_count, bufnr)
    if not count_ok then
      return -- Buffer became invalid, silently fail
    end
    local cursor_ok, _ = pcall(vim.api.nvim_win_set_cursor, winID, { line_count, 9999 })
    if not cursor_ok then
      return -- Window became invalid, silently fail
    end
  end)
end

--- Extract buffer type prefix from buffer name
--- @param bufName string buffer name like 'bufScratchLogs'
--- @return string,string prefix ('bufScratch'|'bufShell'|'bufTask') or empty string and error message
local get_buffer_type = function(bufName)
  local valid_prefixes = { 'bufScratch', 'bufShell', 'bufTask' }
  for _, prefix in ipairs(valid_prefixes) do
    if vim.startswith(bufName, prefix) then
      return prefix, ''
    end
  end
  return '', 'buffer name must start with bufScratch, bufShell, or bufTask'
end

--- Validate buffer name has valid prefix and optional name suffix
--- @param bufName string
--- @return string,string empty string on success or error message, and buffer type prefix
local is_bufname_valid = function(bufName)
  if not bufName or type(bufName) ~= 'string' or bufName == '' then
    return 'buffer name must be a non-empty string', ''
  end

  local buf_type, err_msg = get_buffer_type(bufName)
  if buf_type == '' then
    return err_msg, ''
  end

  local suffix = bufName:sub(#buf_type + 1)
  -- Allow bare prefix (empty suffix) or validate suffix is alphanumeric
  if suffix ~= '' and not suffix:match('^[%w_]+$') then
    return 'buffer name suffix must be alphanumeric with underscores only', ''
  end

  return '', buf_type
end

--[[Buffer Management:
 - Create a buffer by name if it does not exist
 - if bufName is invalid, return error notification and exit
 - If buffer already exists, return existing buffer number
 - If buffer does not exist, create new scratch buffer and return buffer number
 - A valid buffer type is one of [ 'bufShell', 'bufScratch', or 'bufTask']
 - the type prefix is used to determine how to create and manage the buffer
  - this happent in the channel() function not here
 - The buffer handle (bufnr) is stored in a tab variable vim.t.{bufName
]] --
---@param bufName string buffer name like 'bufScratchDefault', 'bufShellBuild', 'bufTaskTest'
---@return integer, string bufnr (or 0 on failure) and status message
M.buffer = function(bufName)
  local err_msg, buf_type = is_bufname_valid(bufName)
  if err_msg ~= '' then
    return 0, 'BUFFER:' .. tostring(bufName) .. ' - ' .. err_msg
  end
  local bufnr, _ = get_bufnr_by_name(bufName)
  if bufnr ~= 0 then
    return bufnr, string.format('BUFFER:%s - use existing %s buffer: %s', bufName, buf_type, tostring(bufnr))
  end
  local oListed = false
  local oScratch = true
  local new_bufnr = vim.api.nvim_create_buf(oListed, oScratch)
  if new_bufnr == 0 then
    return 0, string.format('BUFFER:%s - failed to create buffer', bufName)
  end
  vim.api.nvim_buf_set_name(new_bufnr, bufName)
  -- Store in tab variable
  vim.t[bufName] = new_bufnr
  return new_bufnr, string.format('BUFFER:%s - created new %s buffer', bufName, buf_type)
end

--[[
 - Kill a current buffer in show window by name
 -  deletes vim.t.{} variable storing the buffer handle
 - leave show window open
 ]] --
--- @return boolean, string  true on success, false on failure with error message
local kill_buffer = function()
  local tabID       = vim.api.nvim_get_current_tabpage()
  local winID, msg2 = get_winID()
  if winID == 0 then
    return false, msg2
  end

  local bufnr, msg = get_buf_win(winID)
  if bufnr == 0 then
    return false, msg
  end

  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
    vim.api.nvim_tabpage_del_var(tabID, bufName)
    return true, ''
  else
    return false, 'buffer is not valid'
  end
end

--- Window Management:
--- Open or reuse a window to show the named buffer
--- There is a single show window per tab
--- The handle for the window is stored in vim.t.winID
--- The show window is created below the current window with 30% of the screen height
--- Buffers can be shown in the show window by reusing the window
--- Valid buffer name prefixes: bufScratch, bufShell, bufTask
--- @param bufName string buffer name like 'bufShellBuild', 'bufScratchLogs', 'bufTaskTest'
--- @return integer,string winID window ID showing the buffer or zero on failure with error message
M.window = function(bufName)
  local bufnr, _ = get_bufnr_by_name(bufName)
  if bufnr == 0 then
    return bufnr, string.format('WINDOW:%s - failed to get bufnr by name', bufName)
  end
  local winID, _ = get_winID()
  if winID == 0 then
    local oHeight = math.floor(vim.o.lines * 0.3)
    local oEnter = false -- do not enter the window after creation
    -- see h: api-win_config
    -- opts: table (optional) with keys
    local config = {
      height = oHeight,
      split = 'below',
      style = 'minimal',
      width = vim.o.columns,
      win = -1,
    }
    vim.t.winID = vim.api.nvim_open_win(bufnr, oEnter, config)
    local win = vim.t.winID
    -- set winbar to show buffer info
    -- get buffer info in winbar
    local winbar_fmt = "## %{bufname('%')} ## winID [%{bufwinid('%')}] bufnr [%{bufnr('%')}] type [%{&buftype}]"
    vim.wo[win].sidescrolloff = 0
    vim.wo[win].winbar = winbar_fmt
    vim.wo[win].winfixheight = true
    vim.wo[win].wrap = false
    return win, string.format('WINDOW:%s - created new window %s', bufName, tostring(win))
  else -- reuse existing window
    if vim.api.nvim_win_get_buf(winID) ~= bufnr then
      vim.api.nvim_win_set_buf(winID, bufnr)
    end
    return winID, string.format('WINDOW:%s - reused existing window', bufName)
  end
end

--[[ Channel Management:
 - Get OR create a terminal channel running for either bufShell or bufTask[{name}]
 - If channel already exists, return existing channel ID
 - bufShell{Name): If channel does not exist, create new terminal channel and return channel ID
 - bufTask{Name}  If channel does not exist, use open create new terminal channel and return channel ID
 - bufScratch: scratch buffer does not have a channel
    However, prior to sending data calling show.channel('bufScratch') will clear buffer before writing new data.
    Use send function to write data to the scratch buffer one or many lines at a time.
    Each send `appends` new data to the scratch buffer.
    With a new data set the scratch buffer can be cleared first by calling show.channel('bufScratch')
    ]] --


-- CHANNEL Management

-- Chan Utils

--- get channel ID by buffer number
--- @param bufnr number
--- @return integer,string channel ID or zero and error message
local get_channel_by_bufnr = function(bufnr)
  if not is_buf_valid(bufnr) then
    return 0, 'invalid buffer number: ' .. tostring(bufnr)
  end
  local chan_ok, chanID = pcall(vim.api.nvim_buf_get_var, bufnr, 'channel')
  if not chan_ok or chanID <= 0 then
    return 0, 'no channel found for buffer number: ' .. tostring(bufnr)
  end
  return chanID, ''
end

--- check if the channel var is missing/closed (0)
--- @param bufnr number
--- @return boolean
local channel_exists = function(bufnr)
  local chan_ok, chanID = pcall(vim.api.nvim_buf_get_var, bufnr, 'channel')
  if not chan_ok or chanID == nil or chanID <= 0 then
    return false
  else
    return true
  end
end

--- create new shell channel for bufShell
--- @param bufnr number
--- @return nil
local channel_create_new_shell = function(bufnr)
  local call_ok, call_err = pcall(vim.api.nvim_buf_call, bufnr, function()
    local env = vim.tbl_extend("force", {}, vim.uv.os_environ(), {
      NVIM = vim.v.servername,
      NVIM_LOG_FILE = false,
      VIM = false,
      VIMRUNTIME = false,
      -- TERM = "xterm-256color", -- set by default when term=true
    })
    local shell = vim.o.shell
    local opts = {
      cwd = vim.uv.cwd(),
      term = true,      -- Spawns {cmd} in a new pseudo-terminal session
      clear_env = true, -- start with a clean environment
      env = env,        -- set up environment variables
      --stdout_buffered = true, -- buffer stdout until job exits
      -- stderr_buffered = true, -- buffer stderr until job exits
      -- pty = false,            -- use a pseudo-terminal
    }
    --[[ jobstart() return values
      - |channel-id| on success
      - 0 on invalid arguments
      - -1 if {cmd}[0] is not executable
    --]]
    local jobID = vim.fn.jobstart(shell, opts)
    if jobID <= 0 then
      local err_msg = jobID == 0 and 'invalid arguments' or 'shell not executable'
      vim.notify('Failed to start shell: ' .. err_msg, vim.log.levels.ERROR)
      return
    end
    local set_ok, set_err = pcall(vim.api.nvim_buf_set_var, bufnr, 'channel', jobID)
    if not set_ok then
      vim.notify('Failed to set channel var: ' .. tostring(set_err), vim.log.levels.ERROR)
    end
  end)
  if not call_ok then
    vim.notify('Failed to call buffer: ' .. tostring(call_err), vim.log.levels.ERROR)
  end
end

local channel_create_task = function(bufnr)
  local call_ok, call_err = pcall(vim.api.nvim_buf_call, bufnr, function()
    local opts = { force_crlf = true, }
    local term_ok, chanID = pcall(vim.api.nvim_open_term, bufnr, opts)
    if not term_ok then
      vim.notify('Failed to open terminal: ' .. tostring(chanID), vim.log.levels.ERROR)
      return
    end
    local set_ok, set_err = pcall(vim.api.nvim_buf_set_var, bufnr, 'channel', chanID)
    if not set_ok then
      vim.notify('Failed to set channel var: ' .. tostring(set_err), vim.log.levels.ERROR)
    end
  end)
  if not call_ok then
    vim.notify('Failed to call buffer: ' .. tostring(call_err), vim.log.levels.ERROR)
  end
end

---
--- @param bufName string buffer name like 'bufShellBuild', 'bufTaskTest'
--- @return integer,string channel for buffer or zero on failure with error message
M.channel = function(bufName)
  local bufnr, err1 = get_bufnr_by_name(bufName)
  if bufnr == 0 then return 0, err1 end
  local buf_type, err2 = get_buffer_type(bufName)
  if buf_type == '' then return 0, err2 end
  -- vim.notify(string.format('CHANNEL:%s - buffer type: %s', bufName, buf_type), vim.log.levels.INFO)
  if buf_type == 'bufScratch' then
    -- scratch buffer does not have a channel clear buffer content instead
    M.clear_buffer(bufnr)
    return bufnr, string.format('CHANNEL:%s - buffer cleared', bufName)
  end

  if buf_type == 'bufShell' then
    if channel_exists(bufnr) then
      local chanID, _ = get_channel_by_bufnr(bufnr)
      return chanID, string.format('CHANNEL:%s - existing channel', bufName)
    else
      channel_create_new_shell(bufnr)
      local chanID, err_msg = get_channel_by_bufnr(bufnr)
      if chanID == 0 then
        return 0, string.format('CHANNEL:%s - failed to create channel: %s', bufName, err_msg)
      end
      return chanID, string.format('CHANNEL:%s - created channel', bufName)
    end
  end
  if buf_type == 'bufTask' then
    if channel_exists(bufnr) then
      local chanID, _ = get_channel_by_bufnr(bufnr)
      return chanID, string.format('CHANNEL:%s - existing channel', bufName)
    else
      channel_create_task(bufnr)
      local chanID, err_msg = get_channel_by_bufnr(bufnr)
      if chanID == 0 then
        return 0, string.format('CHANNEL:%s - failed to create channel: %s', bufName, err_msg)
      end
      return chanID, string.format('CHANNEL:%s - created channel', bufName)
    end
  end
  return 0, string.format('CHANNEL:%s - unknown buffer type', bufName)
end

--- Send data to channel or write to scratch buffer
--- @param bufName string buffer name like 'bufShellBuild', 'bufScratchLogs', 'bufTaskTest'
--- @param data string|table string command to send or data to write
--- @return boolean, string  true on success, false and error message on failure
M.send = function(bufName, data)
  local bufnr, err1 = get_bufnr_by_name(bufName)
  if bufnr == 0 then return false, err1 end
  local buf_type, err2 = get_buffer_type(bufName)
  if buf_type == '' then return false, err2 end
  if buf_type == 'bufScratch' then
    local lines = {}
    if type(data) == 'string' then
      table.insert(lines, data)
    elseif type(data) == 'table' then
      -- Validate all elements are strings
      for i, item in ipairs(data) do
        if type(item) ~= 'string' then
          return false, string.format('SEND:%s - table element %d is not a string', bufName, i)
        end
      end
      lines = data
    else
      return false, string.format('SEND:%s - data must be a string or table of strings', bufName)
    end
    append_lines(bufnr, lines)
    return true, ''
  elseif buf_type == 'bufShell' then
    if type(data) == 'string' then
      if data == '' then
        return false, string.format('SEND:%s - data cannot be empty', bufName)
      end
      local cmd_table = string_to_table(data)
      if not is_executable(cmd_table) then
        return false, string.format('SEND:%s - command is not executable: %s', bufName, data)
      end
      local chan_ok, chanID = pcall(vim.api.nvim_buf_get_var, bufnr, 'channel')
      if not chan_ok or chanID == nil or chanID == 0 then
        return false, string.format('SEND:%s - no open channel found', bufName)
      end
      local send_ok, send_err = pcall(vim.fn.chansend, chanID, data .. '\n')
      if not send_ok then
        return false, string.format('SEND:%s - failed to send to channel: %s', bufName, tostring(send_err))
      end
      move_cursor_to_end(bufName)
      return true, ''
    else
      return false, string.format('SEND:%s - data must be a string for bufShell', bufName)
    end
  else -- bufTask
    if type(data) == 'string' then
      if data == '' then
        return false, string.format('SEND:%s - data cannot be empty', bufName)
      end
      local chan_ok, chanID = pcall(vim.api.nvim_buf_get_var, bufnr, 'channel')
      if not chan_ok or chanID == nil or chanID == 0 then
        return false, string.format('SEND:%s - no open channel found', bufName)
      end
      -- For an internal terminal instance (|nvim_open_term()|)
      -- it writes directly to terminal output.
      -- {data}  (`string`) Data to write. 8-bit clean: may contain NUL bytes.
      local task_ok, _ = pcall(vim.api.nvim_chan_send, chanID, data .. '\n')
      if not task_ok then
        return false, string.format('SEND:%s - failed to send data to channel', bufName)
      end
      return true, ''
    else
      return false, string.format('SEND:%s - data must be a string', bufName)
    end
  end
end


--- Get ANSI codes for bold and normal text
--- @param tput_name string 'warn' | 'good' | 'caution' | 'reset' | other tput names
--- @return string bold ANSI code for bold text
M.tput_set = function(tput_name)
  if not is_string(tput_name) then
    return ''
  end
  if tput_name == 'warn' then
    return vim.system({ 'tput', 'setaf', '1' }, { text = true }):wait().stdout
  end
  if tput_name == 'good' then
    return vim.system({ 'tput', 'setaf', '2' }, { text = true }):wait().stdout
  end
  if tput_name == 'caution' then
    return vim.system({ 'tput', 'setaf', '3' }, { text = true }):wait().stdout
  end
  if tput_name == 'reset' then
    return vim.system({ 'tput', 'sgr0' }, { text = true }):wait().stdout
  end
  -- Text Styling
  local tput_names = {
    'bold',  -- bold
    'dim',   -- dim
    'clear', -- clear screen
    'rev',   --reverse
    'rmul',  -- remove underline
    'sgr0',  -- reset all attributes
    'smul',  -- set underline
  }
  if vim.list_contains(tput_names, tput_name) then
    return vim.system({ 'tput', tput_name }, { text = true }):wait().stdout
  end
  return ''
end


-- Window Utilities

--- Check if show window exists in current tab
-- --- @return boolean
M.has_winID = function()
  local tabID     = vim.api.nvim_get_current_tabpage()
  local ok, winID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'winID')
  if not ok then
    return false
  else
    return true
  end
end

-- check if window is open and valid
--- @param winID number|nil
--- @return boolean
local is_open = function(winID)
  if winID and vim.api.nvim_win_is_valid(winID) then
    return true
  else
    return false
  end
end

-- check if window is focused
--- @param winID number|nil
--- @return boolean
local is_focused = function(winID)
  return is_open(winID) and vim.api.nvim_get_current_win() == winID
end



--[[ consolidation of 3 types of Send
 - show.task
 - show.shell
 - show.scratch
-- ]]
--- Send data to bufTask buffer by name
--- @param name string buffer name like 'Test'
--- @param data table data to write
--- @return nil
M.task = function(name, data)
  local bufName        = 'bufTask' .. name
  -- get a named buffer, create if named buffer does not exist
  local bufnr, buf_msg = M.buffer(bufName)
  if bufnr == 0 then
    vim.notify(buf_msg, vim.log.levels.ERROR)
    return
  end
  local winID, win_msg = M.window(bufName)
  if winID == 0 then
    vim.notify(win_msg, vim.log.levels.ERROR)
    return
  end
  local chanID, chan_msg = M.channel(bufName)
  if chanID == 0 then
    vim.notify(chan_msg, vim.log.levels.ERROR)
    return false
  end
  local opts = { text = true }
  -- local cmd = string_to_table(data) TODO
  vim.system(data, opts, function(res)
    vim.schedule(function()
      --send(bufName, string.format(' - code:  %s', res.code))
      --send(bufName, string.format(' - signal:  %s', res.signal))
      M.send(bufName, res.stdout)
      -- send(bufName, string.format(' - stderr:  %s', res.stderr))
    end)
  end)
end

M.shell = function(name, command)
  local bufName        = 'bufShell' .. name
  local show           = require('show')
  -- create or reuse named buffer
  local bufnr, buf_msg = M.buffer(bufName)
  if bufnr == 0 then
    vim.notify(buf_msg, vim.log.levels.ERROR)
    return
  end
  --
  vim.notify(buf_msg, vim.log.levels.INFO)
  -- create or reuse show window
  local winID, win_msg = show.window(bufName)
  if winID == 0 then
    vim.notify(win_msg, vim.log.levels.ERROR)
    return
  end
  vim.notify(win_msg, vim.log.levels.INFO)
  -- create or reuse channel allocated to buffer
  local chanID, chan_msg = show.channel(bufName)
  if chanID == 0 then
    vim.notify(chan_msg, vim.log.levels.ERROR)
    return
  end
  show.send(bufName, command)
end

M.scratch = function(name, data)
  local bufName        = 'bufScratch' .. name
  -- get or create named buffer
  local bufnr, buf_msg = M.buffer(bufName)
  if bufnr == 0 then
    vim.notify(buf_msg, vim.log.levels.ERROR)
    return
  end
  -- create or reuse show window
  local winID, win_msg = M.window(bufName)
  if winID == 0 then
    vim.notify(win_msg, vim.log.levels.ERROR)
    return
  end
  -- clear scratch buffer before sending new data
  local chanID, chan_msg = M.channel(bufName)
  if chanID == 0 then
    vim.notify(chan_msg, vim.log.levels.ERROR)
    return
  end
  -- send new data to scratch buffer
  local send_ok, send_err = M.send(bufName, data)
  if not send_ok then
    vim.notify(send_err, vim.log.levels.ERROR)
    return
  end
end

--[[
Buffer Utilities
 - clear_buffer(bufnr)            -- clear buffer content
 - get_current_buf_in_show_win()  -- get current buffer in show window
 - local kill_buffer()            --  kill current buffer in show window and remove vim.t.{} variable
-- ]]

M.get_bufnr_by_name = get_bufnr_by_name
M.clear_buffer = clear_buffer
M.get_buf_in_win = get_buf_in_win
M.kill_buffer = kill_buffer


return M
