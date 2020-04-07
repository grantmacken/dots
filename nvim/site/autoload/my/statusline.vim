let s:save_cpo = &cpoptions
set cpoptions&vim
" https://hackernoon.com/the-last-statusline-for-vim-a613048959b2
" https://github.com/pgdouyon/dotfiles
"  Statusline
" ============🅴
function! my#statusline#mode()
  return luaeval("require('my.statusline').mode()")
endfunction

function! my#statusline#lsp_diag()
  return luaeval("require('my.statusline').lsp_diag()")
endfunction

function! my#statusline#active()
  return luaeval("require('my.statusline').active()")
endfunction

function! my#statusline#inactive()
  return luaeval("require('my.statusline').inactive()")
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

