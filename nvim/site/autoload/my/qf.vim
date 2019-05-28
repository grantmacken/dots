"""
"File: nvim/site/autoload/my/qf.vim
"GF: nvim/init.vim
"GF: nvim/site/after/ftplugin/qf.vim
" http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window

" :h quicklist
" -------------------------
"  on quicklist commands triggers
"  e.g. make

function! my#qf#pre()
  " echomsg 'my quicklist pre'
endfunction

function! my#qf#post()
  " echomsg 'my quicklist post'
endfunction

" -------------------------
"  on quicklist buffer triggers

function! my#qf#filled()
  " echomsg 'my quicklist filled'
endfunction

function! my#qf#entered()
  " echomsg 'my quicklist entered'
endfunction
