" Vim compiler file
" Compiler:     ShellCheck
" Language:     Shell

let current_compiler = "shfmt"

let s:cpo_save = &cpoptions
set cpoptions&vim

CompilerSet makeprg=shfmt\ >/dev/null

CompilerSet errorformat=
        \%E%l:%c: %m

let &cpoptions = s:cpo_save
unlet s:cpo_save
