let s:save_cpo = &cpoptions
set cpoptions&vim

setlocal nonumber
nnoremap <buffer> q <cmd>q<cr>

augroup help
    autocmd BufEnter <buffer> if winwidth(0) > (&columns / 2) | wincmd L | endif
augroup END

" Hide the modeline at the end of help files
"if has("conceal") syntax match helpModeline "^ vim:.*" conc--eal highlight
"  default link helpModeline helpIgnore
"endif


let &cpoptions = s:save_cpo
unlet s:save_cpo
