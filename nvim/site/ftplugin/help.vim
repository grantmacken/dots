let s:save_cpo = &cpoptions
set cpoptions&vim

" Hide the modeline at the end of help files
if has("conceal")
  syntax match helpModeline "^ vim:.*" conceal
  highlight default link helpModeline helpIgnore
endif

set nonumber

"if &columns > 180
"  wincmd L
"endif

nnoremap <buffer> q :quit<CR>

augroup help
    autocmd BufEnter <buffer> if winwidth(0) > (&columns / 2) | wincmd L | endif
augroup END

let &cpoptions = s:save_cpo
unlet s:save_cpo
