scriptencoding utf-8
" disable
" nvim -u NORC
" PATHS {{{
" XDG Paths {{{
  let $VIMPATH=expand('$HOME/.config/nvim')
  let $CACHEPATH=expand('$HOME/.cache/nvim')
  let $DATAPATH=expand('$HOME/.local/share/nvim/site')
"}}}
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
" Sessions and Undo {{{
" " What not to save in sessions:
" set sessionoptions-=options  neovim default
set sessionoptions-=globals
set sessionoptions-=help
" http://vim.wikia.com/wiki/Quick_tips_for_using_tab_pages
" set sessionoptions=blank,buffers,curdirs,tabpages,winsize
" if hidden is not set, TextEdit might fail.
set hidden
" Some servers have issues with backup files, see #649
set noswapfile
set nobackup
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
" folds
set foldmethod=marker
set foldnestmax=1
" Changing characters to fill special ui elements
set breakindent
set showbreak=↪
set list                " Show hidden characters
" set fillchars=vert:│,fold:─
" nvim defaults set listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·
"}}}
" Mouse and Clipboard {{{
set mouse=a
set clipboard=unnamed

" }}}
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
" Better display for messages
set cmdheight=2         " Height of the command line
set cmdwinheight=5      " Command-line lines

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" set noshowcmd           " Don't show command in status line
" don't give |ins-completion-menu| message
set shortmess+=c
" suppress the annoying 'match x of y', 'The only match' and 
" 'Pattern not found' messages
"
set noshowcmd
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
" Completions {{{
" ================
"  Popup Menu Styling
"  ------------------
" set shortmess+=c
" set shortmess=aoOTI     " Shorten messages and don't show intro
" set shortmess+=c        " https://github.com/roxma/nvim-completion-manager
" ------------------
set pumheight=20        " Pop-up menu's line height
set previewheight=2     " Completion preview height

" Complete Options
" ----------------
" :h complet
"  (default: ".,w,b,u,t")
"  current buffer, window buffers, unloaded buffers, tags
" below are async defualt
set completeopt+=noinsert       " auto select feature like neocomplete
set completeopt+=menuone
set completeopt+=noselect

set completeopt-=longest
set completeopt-=menu
set completeopt-=preview
" xxx
" set completeopt+=longest
" set completeopt+=preview
" }}}

cnoremap w!! execute 'silent! write !SUDO_ASKPASS=`which ssh-askpass` sudo tee % >/dev/null' <bar> edit!
