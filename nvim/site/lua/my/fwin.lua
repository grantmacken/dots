_M = {}
local api = vim.api

local function floating_options( boxHeight )
  -- status line + cmdheight
  local bottomPadding = api.nvim_get_option("cmdheight") + 2
  local top = api.nvim_get_option("lines") - ( boxHeight + bottomPadding )
  local bottom = boxHeight
  local left = 6
  local right = 80
  return {
    relative = 'editor',
    row = top,
    col = left ,
    height = bottom,
    width = right,
    style = 'minimal',
  }
end

-- local lines = {'README.md ','.env', '.projections.json'}

function _M.float( tLines )
  local T = {}
  local res = {}
  for index, value in ipairs ( tLines) do
    res[index] = '  ' .. value
  end
  local opts = floating_options(table.getn( res ))
  T.buf = api.nvim_create_buf(false, true)
  api.nvim_set_var('myFloat',T)

  api.nvim_buf_set_option(T.buf, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(T.buf, 'filetype', 'mymy')
  api.nvim_buf_set_option(T.buf, 'modifiable', true)
  api.nvim_buf_set_lines(T.buf, 0, -1, false,res)

  T.win = api.nvim_open_win(T.buf,true,opts)
  api.nvim_win_set_option(T.win, 'cursorline', true)
  api.nvim_buf_set_option(T.buf, 'modifiable', false)
  local row_col = {1,1}
  api.nvim_win_set_cursor(T.win,row_col)

  api.nvim_set_var('myFloat',T)
  local kopts =  {
    nowait = true,
    noremap = true,
    silent = true
  }
  local mode = 'n'
  api.nvim_buf_set_keymap(T.buf,mode,'q','<CMD>close<CR>',kopts)
  api.nvim_buf_set_keymap(T.buf,mode,'o','<CMD>lua require("my.fwin").open()<CR>',kopts)
end


function _M.open()
  local T = api.nvim_get_var('myFloat')
  local str = vim.trim(api.nvim_get_current_line())
  api.nvim_win_close(T.win, true)
  api.nvim_command('edit '.. str )
end

-- _M.float()
return _M

