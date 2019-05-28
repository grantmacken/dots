
" Autocommands
function! StylePreviewWindow()
  if &previewwindow
    setlocal nowrap
    setlocal norelativenumber
    setlocal nonumber
  endif
endfunction

augroup myQuickfix
  autocmd!
  "@see site/lua/my/qf.lua
  autocmd QuitPre * lua require('my.qf').close()
  " autocmd QuickFixCmdPre caddexpr lua require('my.qf').onCmdPre()
  " before a quicklist command is run
  " autocmd QuickFixCmdPost caddexpr lua require('my.qf').onCmdPost()
  " after a quicklist command is run
  "GF: nvim/site/autoload/my/qf.vim
  " our shell commands 'make' etc run from project root
  " ---------------------------------------------------
  " When the quickfix window has been filled,
  " two autocommand events are triggered
  " First the 'filetype' option is set to 'qf' triggers filetype event
  "GF: nvim/site/after/ftplugin/qf.vim
  "Then the BufReadPost event is triggered,
  " using 'quickfix' for the buffer name
  " autocmd BufReadPost quickfix  lua require('my.qf').onFilled()
  autocmd BufWinEnter quickfix  lua require('my.qf').onEntered()
  "GF: nvim/site/autoload/my/qf.vim
augroup END

augroup myTerm
  autocmd!
   autocmd TermOpen * lua require('my.term').onOpen()
  " autocmd TermChanged * lua require('my.term').onChanged()
  " autocmd TermClose * lua require('my.term').onClose()
  " autocmd TermResponse * lua require('my.term').onResponse()
augroup END

augroup myInit
  autocmd!
  autocmd VimEnter * lua require('my.signs').define()
  " autocmd CursorHold  term://* lua require('my.util').echom(' - Buffer Cursor Hold  ')
  autocmd BufWritePost $MYVIMRC nested source $MYVIMR
  " autocmd BufEnter * :syntax sync fromstart
  " NOTE: filetype
  " detection -- '/usr/share/nvim/runtime/filetype.vim'
  " make recognizes  mk extension
  " xquery recognizes xql xqm xq
  " autocmd TabNewEntered * call OnTabEnter(expand("<amatch>"))
  " au
  autocmd BufNewFile,BufRead xar.pkgs setlocal filetype=json
  autocmd BufNewFile,BufRead *.conf set filetype=nginx "add nginx filetype for any conf extension
  autocmd BufNewFile,BufRead *.snippets set filetype=snippets "add new snippets filetpe
  autocmd BufNewFile,BufRead *.t set filetype=prove "  instead of perl
  autocmd BufNewFile,BufRead *.md set filetype=markdown
  autocmd BufWinEnter * call StylePreviewWindow()
  "@see nvim/site/autoload/my/asyncomplete.vim
  autocmd User asyncomplete_setup call my#asyncomplete#setup()
  " autocmd User ultisnips_setup call my#snippet#setup()
  " ----------------------------------------------------
  " Projections
  " -----------
  " ProjectionistDetect    - tries to detect projection for current file in buffer
  "                        - if detected sets
  "                            - b:projectionist_file
  "                            - b:projectionist  (object)
  " @see projectionist auto commands
  " triggered when searching for projections
  " autocmd User ProjectionistDetect  lua require('my.project').detect()
  "  triggered when projections found:
  "@see nvim/site/lua/my/project.lua
   autocmd User ProjectionistActivate lua require('my.project').activate()
  " autocmd User BuildPhaseComplete lua require("my.jobs").qfJobs("prove")
  " TODO! completion enable for buffer will happen with projection
    " enable ncm2 for all buffers
     " autocmd BufEnter * call ncm2#enable_for_buffer()
    " autocmd User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
    " autocmd User Ncm2PopupClose set completeopt=menuone
  " ---------------------------------------------------
 "  lua require('nvimux').bootstrap()
 "" https://github.com/neovim/neovim/wiki/FAQ
 autocmd VimLeave * set guicursor=a:block-blinkon0
augroup END



