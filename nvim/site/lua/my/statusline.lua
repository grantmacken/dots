local M = {}
local vim = vim
local api = vim.api
local uv = vim.loop
local inspect = vim.inspect
local jobs = {}

-- === Satus-line function ===
--[[ https://github.com/liuchengxu/eleline.vim/wiki
 %< Where to truncate
 %n buffer number
 %F Full path
 %m Modified flag: [+], [-]
 %r Readonly flag: [RO]
 %y Type:          [vim]
 fugitive#statusline()
 %= Separator
 %-14.(...)
 %l Line
 %c Column
 %V Virtual column
 %P Percentage
 %#HighlightGroup#
--]]

-- Mode Prompt Table
local current_mode = setmetatable({
      ['n'] = 'NORMAL',
      ['no'] = 'N·Operator Pending',
      ['v'] = 'VISUAL',
      ['V'] = 'V·Line',
      ['^V'] = 'V·Block',
      ['s'] = 'Select',
      ['S'] = 'S·Line',
      ['^S'] = 'S·Block',
      ['i'] = 'INSERT',
      ['ic'] = 'INSERT',
      ['ix'] = 'INSERT',
      ['R'] = 'Replace',
      ['Rv'] = 'V·Replace',
      ['c'] = 'COMMAND',
      ['cv'] = 'Vim Ex',
      ['ce'] = 'Ex',
      ['r'] = 'Prompt',
      ['rm'] = 'More',
      ['r?'] = 'Confirm',
      ['!'] = 'Shell',
      ['t'] = 'TERMINAL'
    }, {
      -- fix weird issues
      __index = function(_, _)
        return 'V·Block'
      end
    }
)

-- kind [ Error, Warning, Information, Hint ]
M.mode = function()
 local m = api.nvim_get_mode()['mode']
 return current_mode[m]
end
-- print(M.mode())
---- kind [ Error, Warning, Information, Hint ]
M.lsp_diag = function()
  local lsp = vim.lsp
  if vim.lsp.buf.server_ready() then
    local iErr  = inspect(require('diagnostic.util').buf_diagnostics_count('Error'))
    local iWarn = inspect(require('diagnostic.util').buf_diagnostics_count('Warning'))
    return
    '  ' ..
    'W[' .. iWarn  ..
    '] E['  .. iErr  ..
    ']'
  else
    return ''
  end
end

local display = {
 ['file']     = '%t',
 ['modified'] = '%m',
 ['filetype'] =  '%Y',
 ['column']   =  '%c',
 ['line']     =  '%l',
 ['bufnr']    =  '%n'
}

M.active = function( )
  local left_status =
  '░▏' ..
  '%{my#statusline#mode()}' ..
  '▕▏' ..
  display.file ..
  display.modified ..
  '▕▏' ..
  display.filetype ..
  '▕░' ..
  '%{my#statusline#lsp_diag()}' ..
  '░▏'
  local right_status =
  '░▏'..
  display.line ..
  ':' ..
  display.column ..
  '▕▏buf:' ..
  display.bufnr ..
  '▕░'
return left_status .. '%=' .. right_status
end
-- print(inspect(M.active()))

M.inactive = function()
  return
  '░▏' ..
  display.file ..
  display.modified ..
  '▕▏' ..
  display.filetype ..
  '▕░'
end

M.setup = function()
  api.nvim_command('augroup statusline')
  api.nvim_command('autocmd!')
  api.nvim_command("autocmd WinEnter,BufEnter * setlocal statusline=%!my#statusline#active()")
  api.nvim_command("autocmd WinLeave,BufLeave * setlocal statusline=%!my#statusline#inactive()")
  api.nvim_command('augroup END')
end
-- M.setup()


--    

return M
