
"@see https://github.com/justinmk/vim-dirvish
"@help dirvish-options
" NOTES:
"  Shdo mv {} {}copy.txt
"  Shodo! mv % %copy.txt
let g:dirvish_mode = 1
let g:dirvish_relative_paths = 0
let g:dirvish_mode = ':sort r /\/$/'

augroup dirvish_config
  autocmd!
  autocmd FileType dirvish call ProjectionistDetect(resolve(expand('%:p')))
  " Same as FZF
  " Map `t` to open in new tab.
  autocmd FileType dirvish
        \  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
        \ |xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
  " Map `gr` to reload the Dirvish buffer.
  autocmd FileType dirvish nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>
  " Map `gh` to hide dot-prefixed files.
  " To "toggle" this, just press `R` to reload.
  autocmd FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>
augroup END
