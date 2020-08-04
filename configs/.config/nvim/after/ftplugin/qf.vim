" options
setlocal nowrap
setlocal norelativenumber
setlocal number
" we don't want quickfix buffers to pop up when doing :bn or :bp
setlocal nobuflisted
" are we in a location list or a quickfix list?
let b:isLoc = len(getloclist(0)) > 0 ? 1 : 0

" filetype buffer enter autocommand
" force the quickfix window to be opened at the bottom
" of the screen and take the full width wincmd J
augroup quickfix_config
  autocmd! * <buffer>
  autocmd BufEnter <buffer> wincmd J
  " maybe adjust win height
augroup END

nnoremap <silent><buffer><nowait> q <cmd>cclose<cr>

