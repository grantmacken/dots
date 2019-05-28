let s:save_cpo = &cpoptions
set cpoptions&vim

nnoremap <silent><buffer> K :help <C-R><C-W><CR>

set foldmethod=marker
let foldlevel=0

let &cpoptions = s:save_cpo
unlet s:save_cpo
