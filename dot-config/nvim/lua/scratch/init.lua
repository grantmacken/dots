M = {}
--[[
-- use LuaCATS annotations for functions
 Scratch Module
 A simple scratch buffer module for Neovim
  - [ ] show function to display a scratch buffer with given lines and title
  - [ ] create_buffer function to create a new scratch buffer
  - [ ] create_window function to open a floating window with the scratch buffer
  - [ ] Keymap to close the window with 'q'
  - [ ] Autocommand to set the keymap when entering the buffer
  - [ ] Dynamic sizing based on current window dimensions
  - [ ] Minimal styling with a border
 ## Future Features TODO
  - [ ] a run function to execute code in the scratch buffer (future feature)
  - [ ] a save function to save the scratch buffer to a file (future feature)
  - [ ] a clear function to clear the contents of the scratch buffer (future feature)
  - [ ] a toggle function to show/hide the scratch buffer (future feature)
]]                                                  --                                                 --

--[[#############################################]] --

local width = math.ceil(math.min(vim.o.columns, math.max(80, vim.o.columns - 80)))
local height = math.ceil(math.min(vim.o.lines, math.max(20, vim.o.lines - 10)))


local create_buffer = function()
  local listed = false
  local scratch = true -- always 'nomodified'
  local buf = vim.api.nvim_create_buf(listed, scratch)
  -- Set buffer-local options outside fast event context
  vim.schedule(function()
    vim.api.nvim_set_option_value("filetype", "scratch", { buf = buf })
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buf,
      callback = function()
        vim.keymap.set("n", "q", vim.cmd.close, {
          silent = true,
          buffer = true,
        })
      end,
    })
  end)
  return buf
end


local create_window = function(buf, title)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'win',
    title = title,
    width = width,
    height = height,
    row = 1,
    col = width,
    style = 'minimal',
    focusable = true,
    border = 'single',
  })
end

M.show = function(tbl, title)
  local set_lines = vim.api.nvim_buf_set_lines
  local buf = create_buffer()
  create_window(buf, title)
  set_lines(buf, 0, -1, true, tbl)
end


return M
