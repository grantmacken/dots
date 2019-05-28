" Vim compiler file
" Compiler:	HTML Tidy
" Maintainer:	Doug Kearns <dougkearns@gmail.com>
" Last Change:	2013 Jul 7

let current_compiler = "tidy"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" @tidy -q -xml -utf8 -e  --show-warnings no $@  --gnu-emacs\ yes\ 
"
CompilerSet makeprg=tidy\ -q\ -xml\ -utf8\ -e\ --show-warning\ yes\ --gnu-emacs\ yes\ %

" sample warning: foo.html:8:1: Warning: inserting missing 'foobar' element
" sample error:   foo.html:9:2: Error: <foobar> is not recognized!
" 
CompilerSet errorformat=%f:%l:%c:\ Error:%m,%f:%l:%c:\ Warning:%m,%-G%.%#

let &cpoptions = s:cpo_save
unlet s:cpo_save
