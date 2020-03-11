scriptencoding utf-8
" disable
" nvim -u NORC
" PATHS {{{
" XDG Paths {{{
  let $VIMPATH=expand('$HOME/.config/nvim')
  let $COCPATH=expand('$HOME/.config/coc')
  let $CACHEPATH=expand('$HOME/.cache/nvim')
  let $DATAPATH=expand('$HOME/.local/share/nvim/site')
"}}}
let g:loaded_python_provider = 0
let g:python_host_prog  = '/usr/bin/python3'
let $PROJECTS_PATH=expand( $HOME . '/projects/grantmacken' )
source $VIMPATH/plugins.vim
"}}}
" Colors {{{
" =======
set termguicolors
set background=dark
"   Range:   233 (darkest) ~ 239 (lightest
"   Default: 237
let g:seoul256_background = 238
let g:seoul256_srgb = 1
colorscheme seoul256
" https://github.com/neovim/neovim/wiki/FAQ
highlight Cursor guifg=green guibg=green
highlight Cursor2 guifg=red guibg=red
highlight Pmenu     guifg=#d7d7af guibg=#585858
highlight PmenuSel  guifg=#4e4e4e  guibg=#d7d7af
highlight VertSplit guifg=#585858 guibg=#585858
" }}}
" Mouse and Clipboard {{{
set mouse=a
" set clipboard=unnamed
set clipboard+=unnamedplus

" }}}
" Sessions and Undo {{{
" " What not to save in sessions:
" set sessionoptions-=options  neovim default
set sessionoptions+=globals
set sessionoptions-=help
set sessionoptions-=folds " Don't persist folds in sessions (FastFold docs)
" http://vim.wikia.com/wiki/Quick_tips_for_using_tab_pages
" set sessionoptions=blank,buffers,curdirs,tabpages,winsize
" if hidden is not set, TextEdit might fail.
set hidden
" Some servers have issues with backup files, see #649
set noswapfile
set nobackup
set nowritebackup
set undofile
" set undodir=expand($CACHEPATH . '/undo') nvim set by default
set undolevels=5000
set undoreload=10000
augroup vimrc
  autocmd BufWritePre /tmp/* setlocal noundofile
augroup END
" http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-45841328i
" set autowriteall  "Save buffer automatically when changing files
set autoread      "Always reload buffer when external changes detected
" https://bluz71.github.io/2017/05/15/vim-tips-tricks.html

" }}}
" Buffer Typography: Widths, Tabs, Indents and Folds {{{
" ---------------------------------------
set textwidth=120   " Text width maximum 120 chars before wrapping
" @see lengthmatters

" /usr/share/nvim/runtime/ftplugin/make.vim
" set nosmarttab
"" tabstop:         Width of tab character
" softtabstop:      Fine tunes the amount of white space to be added
" shiftwidth        Determines the amount of whitespace to add in normal mode
" expandtab:        When on uses space instead of tabs
"                    expand tabs to spaces except for Make see runtime
set tabstop     =2
set softtabstop =2
set shiftwidth  =2
set expandtab
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'
set incsearch ignorecase smartcase hlsearch " highlight text while searching
set inccommand=nosplit                      " Preview substitutions

" folds
set foldmethod=marker
set foldnestmax=1
" Changing characters to fill special ui elements
set breakindent
set showbreak=↪
set list listchars=trail:»,tab:»-                       " use tab to navigate in list mod
" set fillchars+=vert:\▏                                  " requires a patched nerd font (try FiraCode)
" set list                " Show hidden characters
" set fillchars=vert:│,fold:─
" nvim defaults set listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·
"}}}
" Look of Tabs, Windows and Buffers {{{
" window  settings
set notitle             " No need for a title
set noequalalways       " Don't resize windows on split or close
set winwidth=30         " Minimum width for current window
set winheight=1         " Minimum height for current window
set splitbelow
set splitright

set helpheight=12       " Minimum help window height

" panes: gutter, tabline, commandline , help
" left gutter
set number              " Show line numbers
set numberwidth=3
set relativenumber      " Use relative instead of absolute line numbers

" Bottom Command
" ----------------
set noshowmode          " Don't show mode in cmd window
set cmdheight=2         " Bigger display for messages
set cmdwinheight=5      " Command-line lines
set updatetime=300 " Smaller updatetime for CursorHold & CursorHoldI
set shortmess+=c "suppress the annoying 'match x of y', 'The only match' and Pattern not found' messages
" set noruler             " Disable default status ruler
set ruler
" set rulerformat=%15(%c%V\ %p%%%)
" set ruler
" let &rulerformat=my#statusline#rulerFormat()

" Top  Tabline
" ----------------
set showtabline=1
" set tabline=%!my#statusline#tabline()
" set tabpagemax=30     " Already set to 50 in neovim  Maximum number of tab pages
"
" main buffer window pane
set colorcolumn=120     " Highlight the 120 th character limit
set synmaxcol=200
set scrolloff=2         " Keep at least 2 lines above/below
set sidescrolloff=2     " Keep at least 2 lines left/right
set signcolumn=yes      " keep signcolumn open

" }}}
" ===  Completions === {{{"
" https://neovim.io/doc/user/lsp.html
" https://github.com/neoclide/coc.nvim
"
""  Popup Menu Styling
"  ------------------
set pumheight=20        " Pop-up menu's line height
set previewheight=2     " Completion preview height
" Complete Options
" ----------------
" :h complete
"  (default: ".,w,b,u,t")
"  current buffer, window buffers, unloaded buffers, tags
" below are async defualt
" set completeopt+=noinsert       " auto select feature like neocomplete
" set completeopt+=menuone
" set completeopt+=noselect

" set completeopt-=longest
" set completeopt-=menu
" set completeopt-=preview
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction
  " Use LSP omni-completion in Python files.


" MAP: use <tab> for trigger completion and navigate to next complete item
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" " MAP: Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()
" Use enter to accept snippet expansion
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
" Use `complete_info` if your (Neo)Vim version supports it.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Navigate snippet placeholders using tab
" let g:coc_snippet_next = '<Tab>'
" let g:coc_snippet_prev = '<S-Tab>'

" let g:coc_config_home = $VIMPATH
" let g:coc_data_home = $COCPATH
" " let gg:coc_user_config= $COCPATH

" let g:coc_global_extensions = [
"             \'coc-yank',
"             \'coc-json',
"             \'coc-css',
"             \'coc-html',
"             \'coc-tsserver',
"             \'coc-yaml',
"             \'coc-snippets',
"             \'coc-ultisnips',
"             \'coc-python',
"             \'coc-xml',
"             \'coc-syntax',
"             \'coc-marketplace',
"             \ 'coc-lists',
"             \]

" }}}
" === LSP == {{{
" https://neovim.io/doc/user/lsp.htm
" lua require('nvim_lsp').sumneko_lua.setup{}
" also see  MAPPINGS
lua require('nvim_lsp').bashls.setup{}
lua require('nvim_lsp').cssls.setup{}
lua require('nvim_lsp').dockerls.setup{}
lua require('nvim_lsp').html.setup{}
lua require('nvim_lsp').jsonls.setup{}
lua require('nvim_lsp').tsserver.setup{}
lua require('nvim_lsp').vimls.setup{}
lua require('nvim_lsp').erlang_ls.setup{}

" lua <<EOF
" require'nvim_lsp'.sumneko_lua.setup{
"     on_attach=require('diagnostic').on_attach;
"     log_level = vim.lsp.protocol.MessageType.Error;
"     settings = {
"         Lua = {
"             completion = {
"                 keywordSnippet = "Disable";
"             };
"             runtime = {
"                 version = "LuaJIT";
"             };
"         };
"     };
" }
" EOF


lua require('nvim_lsp').vimls.setup{on_attach=require('diagnostic').on_attach}
" lua require('nvim_lsp').erlang_ls.setup{on_attach=require('diagnostic').on_attach}
" autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()
" autocmd CursorMoved * lua vim.lsp.util.show_line_diagnostics()
" lua require('nvim_lsp').efm.setup{}
" define 
"Lsp completion do using omnifunc
"h omnifunc
"h complete-functions
"/home/gmack/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/bin/Linux/lua-language-server
"cmd = { "/home/gmack/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/bin/Linux/lua-language-server", "-E", "/home/gmack/.cache/nvim/nvim_lsp/sumneko_lua/lua-language-server/main.lua" },
autocmd Filetype css setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype dockerfile setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype html setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype json setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype lua  setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype sh   setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype vim  setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype yaml setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd Filetype erlang setlocal omnifunc=v:lua.vim.lsp.omnifunc
" autocmd BufReadPost * lua require('langsrvr.erlang').check_start_erlang_lsp()

" }}}
" === COMANDS === {{{
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
"GF: nvim/site/lua/my/qf.lua
command! -nargs=0 Prove lua require('my.jobs').qfJobs('prove')
command! -nargs=0 Qnext lua require('my.qf').rotateNext()
command! -nargs=0 Qprev lua require('my.qf').rotatePrev()
command! -nargs=0 Qtoggle lua require('my.qf').toggle()

command! -nargs=0 LspBufClients lua print(vim.inspect(vim.lsp.buf_get_clients()))
command! -nargs=0 LspIsOmni verbose set omnifunc?
command! -nargs=0 LspAvaiableServers lua print(vim.inspect( require('nvim_lsp').available_servers() ))
command! -nargs=0 LspInstallableServers lua print(vim.inspect( require('nvim_lsp').installable_servers()))
" command! -nargs=0 LspReloadBuf lua vim.lsp.stop_all_clients()
" }}}
" === AUTOCOMANDS === {{{

" function! Stylepreviewwindow()
"   if &previewwindow
"     setlocal nowrap
"     setlocal norelativenumber
"     setlocal nonumber
"   endif
" endfunction
"
"

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

" https://github.com/haorenW1025/dotfiles/blob/2198664a648a7cdd74a430aafb63b346e36f5332/nvim/config/status-line.vim
function! InactiveLine()
    return luaeval("require('my.status-line').inActiveLine()")
endfunction

function! ActiveLine()
    return luaeval("require('my.status-line').activeLine()")
endfunction

" Change statusline automatically
augroup StatusLine
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveLine()
  autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveLine()
augroup END


function! TabLine()
    return luaeval("require('my.status-line').TabLine()")
endfunction

set tabline=%!TabLine()

augroup myInit
  autocmd!
  autocmd VimEnter * lua require('my.signs').define()
  " autocmd WinEnter,BufEnter * setlocal lua require('my.status_line').ActiveLine()
  " autocmd WinLeave,BufLeave * setlocal lua require('my.status_line').InActiveLine()
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


  " todo do this with projectionist

 "" autocmd BufWinEnter * call StylePreviewWindow()
  "@see nvim/site/autoload/my/asyncomplete.vim
  " autocmd User asyncomplete_setup call my#asyncomplete#setup()
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
"
" }}}
" === MAPPINGS === {{{
" Disable
" -> ex mode <-
nnoremap Q <Nop>
" Enable
" Use spacebar instead of '\' as leader. Require before loading plugins.
let g:mapleader      = ' '
let g:maplocalleader = ' '
" let g:maplocalleader=','
" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)
" " Release keymappings for plug-in.
nnoremap <Space>  <Nop>
xnoremap <Space>  <Nop>
" escape -> Clear search highlighting
nnoremap <silent><esc> :noh<return><esc>
" let g:fzf_layout = { 'down': '~40%' }

nnoremap <silent> <F2>  <cmd>FZF<CR>
" nnoremap <silent> <F6>  <cmd>botright split | terminal <CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" Manage extensions.
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Use Alt {1,2 ... } to go to tab by number {{{
" noremap <leader>1 1gt
noremap <A-1> 1gt
noremap <A-2> 2gt
noremap <A-3> 3gt
noremap <A-4> 4gt
noremap <A-5> 5gt
noremap <A-6> 6gt
noremap <A-7> 7gt
noremap <A-8> 8gt
noremap <A-9> 9gt:qa
noremap <A-0> :tablast<cr>
" }}}
" Use Alt {h,j.k,l} to navigate windows {{{
nnoremap <silent> <A-h> <C-w>h
nnoremap <silent> <A-k> <C-w>k
nnoremap <silent> <A-j> <C-w>j
nnoremap <silent> <A-l> <C-w>l
" tnoremap <silent> <A-h> <C-\><C-n><C-w>h
" tnoremap <silent> <A-j> <C-\><C-n><C-w>j
" tnoremap <silent> <A-k> <C-\><C-n><C-w>k
" tnoremap <silent> <A-l> <C-\><C-n><C-w>l
"}}}
" Popup menu {{{
" Tab completion
"CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead
inoremap <c-c> <ESC>
" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
"
"
" inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
" Use <TAB> to select the popup menu:
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" }}}
" Quickfix open close [q ]q {{{
"@see nvim/site/lua/my/jobs.lua
nnoremap <silent> [q :Qnext<CR>
nnoremap <silent> ]q :Qprev<CR>
nnoremap <silent> <leader>q :Qtoggle<CR>
nnoremap <F9> :Prove<CR>
" }}}
" ==> Plugin Mappings <== {{{
" vim-commentary maps, since it is loaded lazily
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine





" }}}
" Terminal Mappings {{{
" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>

" }}}
vnoremap <LeftRelease> "*ygv
" }}}
" main plugins config
" === FZF === {{{
" This is the default extra key bindings
" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-o': 'split',
  \ 'ctrl-a': 'vsplit' }
"
" Default fzf layout
" - down / up / left / right
" let g:fzf_layout = { 'down': '~40%' }

" " use nvim windows
" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }
" let g:fzf_layout = { 'window': '10new' }
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_history_dir = '~/.local/share/fzf-history'

" }}}
" === DIRVISH === {{{"
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
  " autocmd FileType dirvish call ProjectionistDetect(resolve(expand('%:p')))
  " Same as FZF
  " Map `t` to open in new tab.
  autocmd FileType dirvish
        \ nnoremap <silent><buffer> t <cmd>call dirvish#open('tabedit', 0)<CR>
        \ |xnoremap <silent><buffer> t <cmd>call dirvish#open('tabedit', 0)<CR>
  " Map `gr` to reload the Dirvish buffer.
  autocmd FileType dirvish nnoremap <silent><buffer> gr <cmd><C-U>Dirvish %<CR>
  " Map `gh` to hide dot-prefixed files.
  " To "toggle" this, just press `R` to reload.
  autocmd FileType dirvish nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>
augroup END

" }}}
" === PROJECTIONIST === {{{"
" if exists("g:autoloaded_projectionist")

" try to extend transformation
" function! s:env(var) abort
"   return exists('*DotenvGet') ? DotenvGet(a:var) : eval('$'.a:var)
" endfunction

" function! g:projectionist_transformations.domain(input, o) abort
"   return s:env('DOMAIN')
" endfunction

" endif
" https://github.com/tpope/vim-projectionist/blob/master/doc/projectionist.txt
" https://www.youtube.com/watch?v=3jDafvUESbs
" https://github.com/wincent/wincent/blob/57a3bf2001/roles/dotfiles/files/.vim/after/plugin/projectionist.vim
" https://github.com/fsharpasharp/vim-dirvinist
" https://github.com/andyl/vim-projectionist-elixir/blob/master/ftdetect/elixir.vim
" https://github.com/naps62/dotfiles/blob/master/config/nvim/rc/skel.vim
" https://github.com/noahfrederick/dots/tree/master/vim/after/plugin
" https://github.com/noahfrederick/dots/blob/master/vim/autoload/my/snippet.vim
" https://github.com/noahfrederick/dots/blob/master/vim/autoload/my/project.vim
" https://www.reddit.com/r/vim/comments/3rsvbr/vimprojectionist/
" https://robots.thoughtbot.com/extending-rails-vim-with-custom-commands
" }}}
" === STARTIFY === {{{"
" Note: Startify has excellent session handling
" if exists('g:autoloaded_startify')
" add support for persistent sessions.
" h startify-options
let g:startify_session_dir =  expand($CACHEPATH . '/session')
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_dir = 0
" TODO!
" let g:startify_session_before_save = [
"     \ 'echo "Cleaning up before saving.."',
"     \ 'silent! NERDTreeTabsClose'
" \ ]
" TODO!
" let g:startify_session_remove_lines = []
" let g:startify_session_savevars = []
" let g:startify_session_savecmds = []
let g:startify_files_number = 1
let g:startify_relative_path = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_number = 5
let g:startify_session_sort = 1


let g:startify_list_order = [
      \ ['  SESSIONS:'],
      \ 'sessions',
      \ ['   MRU files: '],
      \ 'files',
      \ ['   MRU in current directory:'],
      \ 'dir',
      \ ['   BOOKMARKS:'],
      \ 'bookmarks',
      \ ['   COMMANDS:'],
      \ 'commands',
      \ ]
let g:startify_skiplist = [
          \ '\.tmp',
          \ '\.build',
          \ '^/tmp',
          \ ]
hi StartifyBracket ctermfg=240
hi StartifyFile    ctermfg=147
hi StartifyFooter  ctermfg=240
hi StartifyHeader  ctermfg=114
hi StartifyNumber  ctermfg=215
hi StartifyPath    ctermfg=245
hi StartifySlash   ctermfg=240
hi StartifySpecial ctermfg=240
" let g:startify_session_sort = 0
" let g:startify_session_number = 999
" save everything here
" ls  $HOME/.cache/nvim/session/
" rm  $HOME/.cache/nvim/session/*

" http://vim.wikia.com/wiki/Quick_tips_for_using_tab_pages
" set sessionoptions=blank,buffers,curdirs,tabpages,winsize

" endif

" }}}
" === LIGHTLINE === {{{
" autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
" Lightline + Tabline
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified'] ]
      \ },
      \ }
let g:lightline#bufferline#show_number = 1
let g:lightline#bufferline#unnamed = '[No Name]'
let g:lightline.tabline = {'left': [['buffers']], 'right': [['close']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type = {'buffers': 'tabsel'}
" Only show buffer filename
let g:lightline#bufferline#filename_modifier = ':t'
" Show devicons in bufferline
let g:lightline#bufferline#enable_devicons = 1
" function! CocCurrentFunction()
"     return get(b:, 'coc_current_function', '')
" endfunction

" lightline = {
"       \ 'colorscheme': 'seoul256',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'cocstatus', 'readonly','readonly', 'filename', 'modified' ] ]
"       \ },
"       \ 'component_function': {
"       \   'cocstatus': 'coc#status',
"       \   'currentfunction': 'CocCurrentFunction'
"       \ },
"       \ }
"
"}}}
" === ALE === {{{"
" let g:ale_fixers = {
"             \'*': ['remove_trailing_lines', 'trim_whitespace'],
"             \'javascript': ['prettier'],
"             \'css' : ['prettier'],
"             \'html' : ['prettier'],
"             \'markdown' : ['prettier'],
"             \'yaml': ['prettier'],
"             \'json': ['prettier'],
"             \}
" let g:ale_fix_on_save = 1
" let g:ale_linters_explicit = 1
" let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5'
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_sign_warning = '⚠'
" let g:ale_sign_error = '✘'
" let g:ale_sign_info = ''
"
" }}}
" === FIREVIM === {{{
let g:firenvim_config = { 
    \ 'globalSettings': {
        \ 'alt': 'all',
        \ "server": "persistent"
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'always',
        \ },
    \ }
\ }
" }}}

