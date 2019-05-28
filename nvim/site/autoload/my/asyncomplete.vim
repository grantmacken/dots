


function! my#asyncomplete#check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction


function! my#asyncomplete#setup()

let g:asyncomplete_auto_popup = 0

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ my#asyncomplete#check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"





" BUFFER
  call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
        \ 'name': 'buffer',
        \ 'whitelist': ['*'], 
        \ 'blacklist': ['go', 'xquery'],
        \ 'priority': 2,
        \ 'completor': function('asyncomplete#sources#buffer#completor'),
        \}))

 " FILE
 call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
        \ 'name': 'file',
        \ 'whitelist': ['*'],
        \ 'priority': 10,
        \ 'completor': function('asyncomplete#sources#file#completor')
        \ }))

" SYNTAX
   call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
        \ 'name': 'necosyntax',
        \ 'whitelist': ['*'],
        \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
        \ }))


" VIM

   call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
    \ 'name': 'necovim',
    \ 'whitelist': ['vim'],
    \ 'completor': function('asyncomplete#sources#necovim#completor'),
    \ }))


  """xQuery refresh pattern 'keyword' or 'QNAME'
  """ call asyncomplete#register_source(asyncomplete#sources#xQuery#get_source_options(
  """       \{ 'name': 'xQuery', 'whitelist': ['xquery'], 'priority': 2, 'refresh_pattern': '\(\s\k\+$\|:$\)', 'completor': function('asyncomplete#sources#xQuery#completor'), }))
  """
  """ VIM
  ""call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options(
   " "    \{
   " "    \'name': 'necovim', 
   " "    \'whitelist': ['vim'],
   " "    \'priority': 2,
   " "    \'completor': function('asyncomplete#sources#necovim#completor'),
   " "    \}))

endfunction

