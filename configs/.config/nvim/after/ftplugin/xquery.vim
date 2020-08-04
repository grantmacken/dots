" Vim filetype plugin file
" Language:	    XQuery
" Maintainer:	grantmacken <grantmaacken@gmail.com>
" Last Change:  2020-07-24
"
let b:did_ftplugin = 1

"  programs
"  formatting  KEY gq
"  set formatexpr '' invoke a function or
"  set formatprg ''
"
"
setlocal iskeyword +=-

setlocal comments=s1:(:,mb::,ex::)
setlocal commentstring=(:%s:)
setlocal textwidth=120

" Set 'formatoptions' to break comment lines but not other lines,  
" and insert the comment leader when hitting <CR> or using "o".     
"    see...  :h fo-table
setlocal formatoptions-=t 
setlocal formatoptions+=croql
" surround.vim    Usage: visually select text, then type Sc 
let b:surround_{char2nr("c")} = "(: \r :)"

setlocal shiftwidth=2      " what does this do?
setlocal formatoptions-=o  " what does this do?

" column
setlocal relativenumber   " Show line numbers
setlocal number  
" indentation
setlocal autoindent
setlocal cindent
" tabs
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
" Always use spaces instead of tab characters
setlocal expandtab
" Make it so that long lines wrap smartly
setlocal breakindent
let &showbreak=repeat(' ', 3)
setlocal linebreak


