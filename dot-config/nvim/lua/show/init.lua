--[[ Show Module

 @see dot-config/nvim/plugin/09_actions.lua
 @see dot-config/nvim/plugin/10_git.lua
 ]] --
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
--[[ utils
 - accept only a string
 - convert to table by splitting on spaces
 - check if command is executable
--]]
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



local function noninteractive_term_buffer()
  if vim.t.noninteractive_term_buf and vim.api.nvim_buf_is_valid(vim.t.noninteractive_term_buf) then
    return vim.t.noninteractive_term_buf
  end
  local listed = false
  local scratch = false
  vim.t.noninteractive_term_buf = vim.api.nvim_create_buf(listed, scratch)
  local bufnr = vim.t.noninteractive_term_buf
  vim.bo[bufnr].bufhidden = 'hide'
  vim.bo[bufnr].filetype = 'terminal'
  vim.api.nvim_buf_set_name(bufnr, 'noninteractive-terminal') -- set a name for the buffer
end

local function interactive_term_buffer()
  if vim.t.interactive_term_buf and vim.api.nvim_buf_is_valid(vim.t.interactive_term_buf) then
    return vim.t.interactive_term_buf
  end
  local listed               = false
  local scratch              = false
  vim.t.interactive_term_buf = vim.api.nvim_create_buf(listed, scratch)
  local bufnr                = vim.t.interactive_term_buf
  vim.bo[bufnr].bufhidden    = 'hide'
  vim.bo[bufnr].filetype     = 'terminal'
  vim.api.nvim_buf_set_name(bufnr, 'interactive-terminal') -- set a name for the buffer
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

local function open_show_window(bufnr)
  if -- already open and the buffer is in show window
      vim.t.show_win and
      vim.api.nvim_win_is_valid(vim.t.show_win) and
      vim.api.nvim_win_get_buf(vim.t.show_win) == bufnr
  then
    vim.notify('window ' .. vim.t.show_win .. ' already open for buffer ' .. bufnr)
    return vim.t.show_win
  end
  if -- win already open and the buffer is not in show window
      vim.t.show_win and
      vim.api.nvim_win_is_valid(vim.t.show_win) and
      vim.api.nvim_win_get_buf(vim.t.show_win) ~= bufnr
  then
    require('mini.bufremove').unshow_in_window(vim.t.show_win)
    vim.api.nvim_win_set_buf(vim.t.show_win, bufnr)
    vim.notify('reused window ' .. vim.t.show_win .. ' for buffer ' .. bufnr)
    return vim.t.show_win
  end
  -- otherwise create new window for the buffer
  if vim.t.show_win and vim.api.nvim_win_is_valid(vim.t.show_win) then
    vim.api.nvim_win_close(vim.t.show_win, true)
  end

  vim.notify(' - opening new window for buffer ' .. bufnr)
  local height = math.floor(vim.o.lines * 0.3)
  local enter = false
  local win = vim.api.nvim_open_win(bufnr, enter, {
    width = vim.o.columns,
    height = height,
    split = 'below',
    win = -1
  })
  vim.wo[win].winbar = "## %{bufname('%')} ## window [%{bufwinid('%')}] buffer [%{bufnr('%')}] buftype [%{&buftype}]"
  vim.t.show_win = win
  vim.notify(' - opened window ' .. vim.t.show_win .. ' for buffer ' .. bufnr)
  return vim.t.show_win
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
  vim.system(tbl, { text = true }, function(obj)
    --local res = vim.split(obj.stdout, '\n')
    local res = obj.stdout
    if obj.code ~= 0 then
      res = res .. '\nError: ' .. (obj.stderr or 'unknown error') .. '\nExit code: ' .. obj.code
    end
    -- open the noninteractive terminal buffer and window
    -- and send the command output to the terminal
    -- we do this in a scheduled function to ensure it runs
    -- after the current function completes
    vim.schedule(function()
      noninteractive_term_buffer()
      local bufnr = vim.t.noninteractive_term_buf
      vim.notify('buffer ' .. bufnr .. ' ready')
      -- TODO! try to clear existing lines in buffer
      clear_buffer(bufnr)
      open_show_window(bufnr)
      local win = vim.t.show_win
      vim.notify('window ' .. win .. ' ready')
      local opts = { force_crlf = true }
      -- set the channel for the terminal
      local chan = vim.api.nvim_open_term(bufnr, opts)
      vim.fn.chansend(chan, cmd)
      -- Schedule the cursor movement to run after the terminal is fully open
      move_cursor_to_end(bufnr, win)
    end)
  end)
end

--- @param cmd string
M.interactive_term = function(cmd)
  if not is_string(cmd) then
    return
  end
  local tbl = string_to_table(cmd)
  if not is_executable(tbl) then
    return
  end
  -- ensure command ends with newline to execute it
  -- also clear the terminal before running the command
  if not cmd:match('\n$') then
    cmd = 'clear && ' .. cmd .. '\n'
  end
  interactive_term_buffer()
  local bufnr = vim.t.interactive_term_buf
  vim.notify('buffer ' .. bufnr .. ' ready')
  open_show_window(bufnr)
  local win = vim.t.show_win
  vim.notify('window ' .. win .. ' ready')
  -- Start terminal in the buffer if not already started
  if not vim.bo[bufnr].channel or vim.bo[bufnr].channel == 0 then
    vim.notify('no channel, starting terminal in buffer ' .. bufnr)
    vim.api.nvim_buf_call(bufnr, function()
      vim.fn.jobstart(vim.o.shell, {
        term = true,
        pty = true,
      })
    end)
  end
  local chan = vim.bo[bufnr].channel
  if chan and chan > 0 then
    vim.fn.chansend(chan, cmd)
  else
    vim.notify('Failed to get terminal channel for buffer ' .. bufnr, vim.log.levels.ERROR)
    return
  end
  vim.schedule(function()
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    vim.api.nvim_win_set_cursor(win, { line_count, 9999 })
  end)
end

--- @param cmd string
M.scratch = function(cmd)
  if not is_string(cmd) then
    return
  end
  local tbl = string_to_table(cmd)
  if not is_executable(tbl) then
    return
  end
  scratch_buffer()
  local bufnr = vim.t.scratch_buf
  vim.notify('buffer ' .. bufnr .. ' ready')
  open_show_window(bufnr)
  local win = vim.t.show_win
  vim.notify('window ' .. win .. ' ready')

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
