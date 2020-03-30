_M = {}
local api = vim.api
local inspect = vim.inspect
local err, got, exp = require('my.utility').printr()

_M.open_file = function()
  -- local pSeparator = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
  local pFile = vim.trim(api.nvim_get_current_line())
  -- local pRoot = vim.loop.cwd()
  local cmd =  'edit ' .. pFile
  print(cmd)
  api.nvim_win_close(0, true)
  api.nvim_command(cmd)
end

_M.vertical_split = function()
  local pFile = vim.trim(api.nvim_get_current_line())
  -- local pRoot = vim.loop.cwd()
  local cmd =  'vs ' .. pFile
  print(cmd)
  api.nvim_win_close(0, true)
  api.nvim_command(cmd)

end


function _M.open_dir() 
  local pFile = vim.trim(api.nvim_get_current_line())
  local cmd =  'Dirvish ' .. pFile
  print(cmd)
  api.nvim_win_close(0, true)
  api.nvim_command(cmd)
end

--[[

 <cr> Open file at cursor
 o    Open file in a new window.
 a    Opens file in a new, vertical window

 TODO!
 K   Show file info.
 p   Previews file at cursor

--]]



local function floating_options( aLines )
  local nLineCount = table.getn( aLines )
  if  nLineCount  < 1 then  err( ' should be positive integer'  ) return false end
  -- status line + cmdheight
  local bottomPadding = api.nvim_get_option('cmdheight') + 2
  local top = api.nvim_get_option('lines') - ( nLineCount + bottomPadding )
  local left = 5
  local right = 120
  return {
    relative = 'editor',
    row = top,
    col = left ,
    height = nLineCount,
    width = right,
    style = 'minimal',
  }
end

local fwin_open = function( aLines )
  if type( aLines ) ~= 'table' then  err( ' no arg "aLines'  ) return {} end
  --  local nLineCount = table.getn( aLines )
  local opts = floating_options( aLines )
  local T = {}
  T.buf = api.nvim_create_buf( false, true )
  api.nvim_buf_set_option( T.buf, 'filetype', 'scratch' )
  api.nvim_buf_set_option( T.buf, 'buftype', 'nofile' )
  api.nvim_buf_set_option( T.buf, 'bufhidden', 'wipe' )
  api.nvim_buf_set_option( T.buf, 'modifiable', true )
  -- -- create a prefix spacer
  local res = {}
  for index, value in ipairs ( aLines ) do
    res[index] = '  ' .. value
  end
  api.nvim_buf_set_lines( T.buf, 0, -1, false,res )
  api.nvim_buf_set_option( T.buf, 'modifiable', false )
  T.win = api.nvim_open_win( T.buf,true,opts )
  return (T)
  -- return opts
end
-- print(inspect(fwin_open( require('my.project').list_all_project_files( vim.loop.cwd() ))))


local set_mappings = function( T )
-- normal mode remap keys
  local kopts =  {
    nowait = true,
    noremap = true,
    silent = true
  }
  local mode = 'n'
  api.nvim_buf_set_keymap(T.buf,mode,'q','<CMD>close<CR>',kopts)
  api.nvim_buf_set_keymap(T.buf,mode,'o','<CMD>lua _M.open_file()<CR>',kopts)
  api.nvim_buf_set_keymap(T.buf,mode,'a','<CMD>lua _M.vertical_split()<CR>',kopts)
  api.nvim_buf_set_keymap(T.buf,mode,'d','<CMD>lua _M.open_dir()<CR>',kopts)
  api.nvim_buf_set_keymap(T.buf,mode,'<Left>','',kopts)
  api.nvim_buf_set_keymap(T.buf,mode,'<Right>','',kopts)
  local aChars = {
    'b', 'c', 'e', 'f', 'g', 'h','i',
    'l', 'm', 'n', 'p', 'r', 's', 't', 'u',
    'v', 'w', 'x', 'y', 'z'
  }

  for i, sValue in ipairs( aChars) do
    api.nvim_buf_set_keymap(T.buf, mode,sValue, '',kopts)
    api.nvim_buf_set_keymap(T.buf, mode, sValue:upper(), '' ,kopts)
    api.nvim_buf_set_keymap(T.buf, mode, '<c-' .. sValue .. '>', '',kopts)
  end

  return T
end

local show_view = function( T )
  api.nvim_buf_set_option(T.buf, 'modifiable', true)
  api.nvim_win_set_option(T.win, 'cursorline', true)
  api.nvim_win_set_option(T.win, 'cuc', true)
  vim.api.nvim_buf_set_option(T.buf, 'modifiable', false)
  local row_col = {1,0}
  api.nvim_win_set_cursor(T.win,row_col)
  return T
end

_M.show = function( aLines )
  if type( aLines ) ~= 'table' then  err( got(aLines) .. exp(type({}))  ) return false end
  tbl = fwin_open( aLines )
  tbl = set_mappings( tbl)
  tbl = show_view(tbl)
end

_M.project = function()
  return _M.show(require('my.project').list_all_project_files())
end

-- _M.project()
-- _M.project()

return _M

