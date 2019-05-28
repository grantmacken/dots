" FILE: nvim/site/after/ftplugin/qf.vim
" GF: nvim/site/autoload/my/quicklist.vim
" GF: nvim/init.vim
" 
" https://github.com/romainl/vim-qf
" TODO add some more from above
  "
" text wrapping is pretty much useless in the quickfix window
setlocal nowrap
" relative line numbers don't make much sense either
" but absolute numbers do
setlocal norelativenumber
setlocal nonumber
" we don't want quickfix buffers to pop up when doing :bn or :bp
" set nobuflisted
" are we in a location list or a quickfix list?
" let b:isLoc = len(getloclist(0)) > 0 ? 1 : 0
" :botright cwindow
" force the quickfix window to be opened at the bottom
" of the screen and take the full width wincmd J
augroup quickfix_config
  autocmd! * <buffer>
  autocmd BufEnter <buffer> wincmd J
augroup END

" nnoremap <silent><buffer><nowait> s <C-W><CR><C-W>p<C-W>J<C-W>p
" nnoremap <silent><buffer><nowait> v <C-W><CR><C-W>L<C-W>p<C-W>J<C-W>p
" nnoremap <silent><buffer><nowait> t <C-W><CR><C-W>T

" hit q to quit
nnoremap <silent><buffer><nowait> q lua require('my.qf').close()

" autocmd BufEnter <buffer> call my#qf#AdjustWindowHeight(3,10)

