 M = {}
--[[
 ]]--

 --[[#############################################]]--

local width = math.ceil(math.min(vim.o.columns, math.max(80, vim.o.columns - 80)))
local height = math.ceil(math.min(vim.o.lines, math.max(20, vim.o.lines - 10)))

local create_buffer = function()
  local listed = false
  local scratch = true -- always 'nomodified'
  local buf = vim.api.nvim_create_buf(listed, scratch)
  -- vim.api.nvim_set_option_value("filetype", "terminal", { buf = buf })
  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = buf,
    callback = function()
      vim.keymap.set("n", "q", vim.cmd.close , {
        silent = true,
        buffer = true,
      })
    end
  })
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

local show = function( tbl, title)
  local set_lines = vim.api.nvim_buf_set_lines
  local buf = create_buffer()
  create_window(buf, title)
  set_lines(buf, 0, -1, true, tbl)
end



M.create_buffer = create_buffer
M.create_window = create_window
M.show = show

return M
