M = {}
local api = vim.api
local inspect = vim.inspect
local err, got, exp = require('my.utility').printr()

M.close_fwin = function()
  api.nvim_win_close(0, true)
end

M.open_file = function()
  -- local pSeparator = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
  local pFile = vim.trim(api.nvim_get_current_line())
  -- local pRoot = vim.loop.cwd()
  local cmd =  'edit ' .. pFile
  print(cmd)
  api.nvim_win_close(0, true)
  api.nvim_command(cmd)
end

M.vertical_split = function()
  local pFile = vim.trim(api.nvim_get_current_line())
  -- local pRoot = vim.loop.cwd()
  local cmd =  'vs ' .. pFile
  print(cmd)
  api.nvim_win_close(0, true)
  api.nvim_command(cmd)
end

function M.open_dir() 
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
  -- j, k alone

  local mappings = {
    ['<cr>'] = 'open_file()',
    ['-']    = 'open_dir()',
    ['a']    = 'vertical_split()',
    ['o']    = 'open_file()',
    ['q']    = 'close_fwin()',
  }
  for sKey, sValue in pairs(mappings) do
    api.nvim_buf_set_keymap( T.buf, mode, sKey, '<cmd>lua M.' .. sValue .. '<cr>', kopts )
  end

  extraMappings = {
    ['<Left>'] = '',
    ['<Right>'] = ''
  }

  for sKey, sValue in pairs( extraMappings ) do
    api.nvim_buf_set_keymap(T.buf, mode, sKey, sValue, kopts)
  end

  aTozMappings = {
    ['b'] = '',
    ['c'] = '',
    ['d'] = '',
    ['e'] = '',
    ['f'] = '',
    ['g'] = '',
    ['h'] = '',
    ['i'] = '',
    ['l'] = '',
    ['m'] = '',
    ['n'] = '',
    ['p'] = '',
    ['r'] = '',
    ['s'] = '',
    ['t'] = '',
    ['u'] = '',
    ['v'] = '',
    ['w'] = '',
    ['x'] = '',
    ['x'] = '',
    ['z'] = ''
  }

  for sKey, sValue in pairs( aTozMappings ) do
    api.nvim_buf_set_keymap(T.buf, mode, sKey,sValue,kopts)
    -- also uppcase
    api.nvim_buf_set_keymap(T.buf, mode, sKey:upper(), sValue ,kopts)
    -- api.nvim_buf_set_keymap(T.buf, mode, '<c-' .. sValue .. '>', '',kopts)
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

M.show = function( aLines )
  if type( aLines ) ~= 'table' then  err( got(aLines) .. exp(type({}))  ) return false end
  tbl = fwin_open( aLines )
  tbl = set_mappings( tbl)
  tbl = show_view(tbl)
end

M.project = function()
  return M.show(require('my.project').list_all_project_files())
end

M.buffer_projections = function()
  return M.show(require('my.project').show_buf_projections())
end



return M

