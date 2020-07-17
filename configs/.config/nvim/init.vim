scriptencoding utf-8
let g:loaded_python_provider = 0
let g:python_host_prog  = '/usr/bin/python3'
" disable
" nvim -u NORC
let $GIT_EDITOR = 'nvr -cc split --remote-wait'
" let $VIMPATH=expand('$HOME/.config/nvim')
" let $CACHEPATH=expand('$HOME/.cache/nvim')
" let $DATAPATH=expand('$HOME/.local/share/nvim/site')
" 
let $PROJECTS_PATH=expand( $HOME . '/projects/grantmacken')

" Do not load some standard plugins
" let g:loaded_getscriptPlugin = 1
" let g:loaded_vimballPlugin = 1
" let g:loaded_logiPat = 1
" let g:loaded_rrhelper = 1
" let loaded_gzip = 1
" let g:loaded_zipPlugin = 1
" let g:loaded_tarPlugin = 1
" let g:loaded_spellfile_plugin = 1
" let g:loaded_2html_plugin = 1
" let g:loaded_netrwPlugin = 1
let g:loaded_2html_plugin      = 1
let loaded_gzip                = 1
let g:loaded_man               = 1
let loaded_matchit             = 1
let loaded_matchparen          = 1
" let g:loaded_shada_plugin      = 1
let loaded_spellfile_plugin    = 1
let g:loaded_tarPlugin         = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zipPlugin         = 1
let g:loaded_netrwPlugin       = 1


lua << EOF
--local inspect = require('vim.inspect')
local map = {color = {scheme = 'nord', packname = 'nord-vim' }}
require('my.colors').setup( map.color.scheme, map.color.packname )
--require('my.autocommands').setup( )




-- print(inspect(map))
EOF
execute 'luafile ' . stdpath('config') . '/lua/my/autocommands.lua'

lua << EOF
--[[
vim.fn.{func}
Read, set and clear
print(vim.g.my_global_variable)
vim.g.my_global_variable = 5
vim.g.my_global_variable = nil

vim.g  g: 
vim.b  b:
vim.b  w:
vim.v  v:
vim.o  option
vim.bo buffer option
vim.wo window option

inpect
paste - can be used to scrub term color-codes
--]]
EOF
