--[[ Show Module
 @see dot-config/nvim/lua/show/init.lua
 @see dot-config/nvim/plugin/09_actions.lua

layout of the windows:

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
 The handler for the show window is stored in tab variable `vim.t.winID`.

 The tab specific show window is a project-wide window that can be reused
 for different buffers types like scratch, terminal, quickfix, help, etc.

 Window Features:
 - Open or reuse a dedicated show window per tab
 - Store window handler in tab variable `vim.t.winID`
 - Use show window winbar to hint buffer types shown in the window

 Buffer Features:
 - Clear buffer content
 - Append lines to buffer
 - Move cursor to end of buffer
 ]] ---
M = {}

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


--- Open or reuse a window to show the buffer
--- There is a single show window per project stored in vim.t.project['show_win']
--- The show window is created below the current window with 30% of the screen height
--- Buffers can be shown in the show window by reusing the window
--- Types of buffers to show: scratch, terminal, quickfix, help, etc.
--- @param bufnr number  buffer number
--- @return integer winID window ID showing the buffer or zero on failure
M.window = function(bufnr)
  local tabID     = vim.api.nvim_get_current_tabpage()
  local ok, winID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'winID')
  if not ok then
    vim.notify('no existing window for buffer ' .. bufnr)
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
    vim.wo[win].sidescrolloff = 0
    vim.wo[win].winbar = "## %{bufname('%')} ## window [%{bufwinid('%')}] buffer [%{bufnr('%')}] buftype [%{&buftype}]"
    vim.wo[win].winfixheight = true
    vim.wo[win].wrap = false
    return win
  else
    vim.notify('found existing window ' .. winID .. ' for buffer ' .. bufnr)
    if -- already open and the buffer is in show window
        vim.api.nvim_win_get_buf(winID) == bufnr
    then
      vim.api.nvim_win_set_buf(winID, bufnr) -- ensure the buffer is set in the window
      vim.notify('Buffer already shown in window')
    else
      -- remove existing buffer from window
      require('mini.bufremove').unshow_in_window(winID)
      vim.notify('reused window ' .. vim.inspect(winID) .. ' for buffer ' .. vim.inspect(bufnr))
    end
    vim.api.nvim_win_set_buf(winID, bufnr) -- set the buffer in the window
    return winID
  end
end


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


M.move_cursor_to_end = function(bufnr, win)
  vim.schedule(function()
    if not (bufnr and win) then
      return
    end
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    vim.api.nvim_win_set_cursor(win, { line_count, 9999 })
  end)
end

M.clear_buffer = function(bufnr)
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
-- @param tbl table of strings
M.append_lines = function(bufnr, tbl)
  vim.schedule(function()
    local strict = false
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local start_line = 1
    local end_line = line_count + #tbl - 1 -- -1 because end_line is exclusive
    vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, strict, tbl)
    -- move cursor to the end
  end)
end




return M
