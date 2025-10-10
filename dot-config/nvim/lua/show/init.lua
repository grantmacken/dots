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


local set_buf_common = function(bufnr, filetype)
  vim.bo[bufnr].bufhidden = 'hide'
  vim.bo[bufnr].filetype = filetype

  -- vim.bo[bufnr].swapfile = false
  -- vim.bo[bufnr].modifiable = true
  -- vim.bo[bufnr].readonly = false
  -- vim.bo[bufnr].buftype = ''
  -- vim.bo[bufnr].filetype = ''
  -- vim.bo[bufnr].syntax = ''
end


local function open_term_buffer()
  if vim.t.open_term_buf and vim.api.nvim_buf_is_valid(vim.t.open_term_buf) then
    return vim.t.open_term_buf
  end
  local listed = true
  local scratch = false
  vim.t.open_term_buf = vim.api.nvim_create_buf(listed, scratch)
  local bufnr = vim.t.open_term_buf
  set_buf_common(bufnr, 'terminal')
  vim.api.nvim_buf_set_name(bufnr, 'noniteractive-terminal') -- set a name for the buffer
end

local function interactive_term_buffer()
  if vim.t.interactive_term_buf and vim.api.nvim_buf_is_valid(vim.t.interactive_term_buf) then
    return vim.t.interactive_term_buf
  end
  local listed = true
  local scratch = false
  vim.t.interactive_term_buf = vim.api.nvim_create_buf(listed, scratch)
  vim.bo[vim.t.interactive_term_buf].filetype = 'terminal'
end

local function scratch_buffer()
  if vim.t.scratch_buf and vim.api.nvim_buf_is_valid(vim.t.scratch_buf) then
    return vim.t.scratch_buf
  end
  local listed = true
  local scratch = false
  vim.t.scratch_buf = vim.api.nvim_create_buf(listed, scratch)
end

local function open_show_window(bufnr)
  if -- already open and the buffer is in show window
      vim.t.show_win and
      vim.api.nvim_win_is_valid(vim.t.show_win) and
      vim.api.nvim_win_get_buf(vim.t.show_win) == bufnr
  then
    return vim.t.show_win
  end
  if -- win already open and the buffer is not in show window
      vim.t.show_win and
      vim.api.nvim_win_is_valid(vim.t.show_win) and
      vim.api.nvim_win_get_buf(vim.t.show_win) ~= bufnr
  then
    require('mini.bufremove').unshow_in_window(vim.t.show_win)
    vim.api.nvim_win_set_buf(vim.t.show_win, bufnr)
    return vim.t.show_win
  end
  -- otherwise create new window for the buffer
  if vim.t.show_win and vim.api.nvim_win_is_valid(vim.t.show_win) then
    vim.api.nvim_win_close(vim.t.show_win, true)
  end

  local height = math.floor(vim.o.lines * 0.3)
  local enter = false
  local win = vim.api.nvim_open_win(bufnr, enter, {
    width = vim.o.columns,
    height = height,
    split = 'below',
    win = -1
  })
  --[[ set a winbar specific to the buffer type
  - [ ] buffer number bufnr('%')
  - [ ] window id    bufwinid('%') --win_getid()
  - [ ] buffer name bufname('%')
  - [ ] bufbuffer buftype
]]
  vim.wo[win].winbar = "## %{bufname('%')} ## window [%{bufwinid('%')}] buffer [%{bufnr('%')}] buftype [%{&buftype}]"
  vim.t.show_win = win
  return vim.t.show_win
end

M.scratch = function(tbl, title)
  vim.schedule(function()
    scratch_buffer()
    vim.notify('buffer ' .. vim.t.scratch_buf .. ' ready')
    open_show_window(vim.t.scratch_buf)
    vim.notify('window ' .. vim.t.show_win .. ' ready')
    local start_line = 0
    local end_line = -1
    local strict = false
    vim.api.nvim_buf_set_lines(vim.t.scratch_buf, start_line, end_line, strict, tbl)
  end)
end




---@param str string
---@param title string | optional
M.open_term = function(str, title)
  vim.schedule(function()
    open_term_buffer()
    local bufnr = vim.t.open_term_buf
    vim.notify('buffer ' .. bufnr .. ' ready')
    open_show_window(bufnr)
    local win = vim.t.show_win
    vim.notify('window ' .. win .. ' ready')
    local opts = { force_crlf = true }
    -- set the channel for the terminal
    local chan = vim.api.nvim_open_term(bufnr, opts)
    vim.fn.chansend(chan, 'clear\r\n') -- new line to make sure we are at a new prompt
    vim.fn.chansend(chan, str)
    -- Schedule the cursor movement to run after the terminal is fully open
    vim.schedule(function()
      -- Set the cursor to the window (win)
      -- The cursor position is {row, col}
      -- Get the total number of lines in the buffer
      local line_count = vim.api.nvim_buf_line_count(bufnr)
      -- Set the cursor to the last line (line_count) and a high column (to ensure end of line)
      -- Neovim line numbers are 1-based.
      -- Setting a column like 9999 ensures it lands at the end of the line (similar to '$').
      vim.api.nvim_win_set_cursor(win, { line_count, 9999 })
    end)
  end)
end

--- @param data string|string[]
--- @param title string | optional
M.interactive_term = function(data, title)
  vim.schedule(function()
    interactive_term_buffer()
    local bufnr = vim.t.interactive_term_buf
    vim.notify('buffer ' .. bufnr .. ' ready')
    open_show_window(bufnr)
    vim.api.nvim_buf_call(bufnr, function() vim.cmd.term() end)
    vim.notify('window ' .. vim.t.show_win .. ' ready')
    local chan = vim.bo[bufnr].channel
    vim.fn.chansend(chan, data)
  end)
end

return M
