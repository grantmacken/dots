"" Note: Startify has excellent session handling
" if exists('g:autoloaded_startify')
" add support for persistent sessions.
" h startify-options
" let g:startify_disable_at_vimenter = 1
"let g:startify_enable_unsafe = 1
let g:startify_session_dir =  expand($CACHEPATH . '/session')
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_dir = 1
"" TODO!
let g:startify_session_remove_lines = []
let g:startify_session_savevars = []
let g:startify_session_savecmds = []
"let g:startify_files_number = 1
let g:startify_relative_path = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_number = 10
let g:startify_session_sort = 1
let g:startify_list_order = [
      \ ['  SESSIONS:'],
      \ 'sessions',
      \ ]
let g:startify_skiplist = [
          \ '\.tmp',
          \ '\.build',
          \ '^/tmp',
          \ ]
"hi StartifyBracket ctermfg=240
"hi StartifyFile    ctermfg=147
"hi StartifyFooter  ctermfg=240
"hi StartifyHeader  ctermfg=114
"hi StartifyNumber  ctermfg=215
"hi StartifyPath    ctermfg=245
"hi StartifySlash   ctermfg=240
"hi StartifySpecial ctermfg=240
"" let g:startify_session_sort = 0
"" let g:startify_session_number = 999

