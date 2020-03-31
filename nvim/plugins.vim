function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
call plug#begin( expand( $DATAPATH . '/plugged'))
" Themes and Colorscheme {{{
Plug 'arcticicestudio/nord-vim'
Plug 'ayu-theme/ayu-vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'junegunn/seoul256.vim'
" }}}
" Visual {{{
" Plug 'alvan/vim-closetag'    " auto close html tags
Plug 'Yggdroot/indentLine'    " show indentation lines
" Plug 'google/vim-searchindex'   " add number of found matching search items
" Plug 'gregsexton/MatchTag'
" Plug 'luochen1990/rainbow'
Plug 'junegunn/vim-peekaboo' "https://github.com/junegunn/vim-peekaboo
Plug 'machakann/vim-highlightedyank' " highligh yank text
Plug 'tpope/vim-commentary'  , { 'on': ['<Plug>Commentary', '<Plug>CommentaryLine'] }
" Plug 'liuchengxu/vim-which-key'
" On-demand lazy load
" Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
" }}}
" Auto Completion, Language Servers, Snippets {{{
"/vim-projectionist'

Plug 'neovim/nvim-lsp'
Plug 'haorenW1025/diagnostic-nvim'
Plug 'haorenW1025/completion-nvim'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'hyhugh/coc-erlang_ls', {'do': 'yarn install --frozen-lockfile'}
"Plug 'w0rp/ale'
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets' " actual snippets
" }}}
" File_And_Project_Management {{{
" install smae place as nvim-lsp bins
" Plug 'tpope/vim-projectionist'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'c-brenn/fuzzy-projectionist.vim'
" Plug 'junegunn/fzf', { 'dir': '~/.cache/nvim/fzf', 'do': './install --all' }
Plug 'yuki-ycino/fzf-preview.vim'
" GIT
" Plug 'rhysd/git-messenger.vim'
Plug 'airblade/vim-gitgutter'
" Plug 'AndrewRadev/switch.vim TODO
" Plug 'junegunn/fzf.vim'
"GF: site/after/plugin/fzf.vim/
Plug 'justinmk/vim-dirvish'
Plug 'bounceme/remote-viewer'
Plug 'kristijanhusak/vim-dirvish-git'
" Plug 'fsharpasharp/vim-dirvinist'
"URL: https://github.com/justinmk/vim-dirvish/blob/master/doc/dirvish.txt
"GF: site/after/ftplugin/dirvish.vim
" Plug 'mhinz/vim-startify'
"GF: site/after/plugin/startify.vim
"@ sessions
Plug 'tpope/vim-eunuch'     " https://github.com/tpope/vim-eunuch
Plug 'tpope/vim-dotenv' " https://github.com/tpope/vim-dotenv
"Plug 'tpope/vim-dispatch'
" Plug 'radenling/vim-dispatch-neovim'
Plug 'arithran/vim-delete-hidden-buffers'
"Plug 'MattesGroeger/vim-bookmarks'
"Plug 'bogado/file-line'
" Plug 'Shougo/neomru.vim'
" Plug 'rbtnn/vim-jumptoline'
" Plug 'ryanoasis/vim-devicons
" Plug '907th/vim-auto-save'
" Plug 'tpope/vim-fugitive'                               " git support
" Plug 'psliwka/vim-smoothie'                             " some very smooth ass scrolling
" Plug 'farmergreg/vim-lastplace'                         " open files at the last edited place
" Plug 'romainl/vim-cool'                                 " disable hl until another search is performed
" Plug 'wellle/tmux-complete.vim'                         " complete words from a tmux panes
" Plug 'liuchengxu/vista.vim'                             " a bar of tags
" Plug 'tpope/vim-eunuch'                                 " run common Unix commands inside Vim
" Plug 'machakann/vim-sandwich'                           " make sandwiches
" Plug 'easymotion/vim-easymotion'                        " make movement a lot faster and easier

" Plug 'mhinz/vim-grepper':
" let g:grepper = {}
" let g:grepper.tools = ['grep', 'git', 'rg']
" Plug 'skwp/greplace.vim' "https://github.com/skwp/greplace.vim/blob/master/doc/greplace.txt
" Plug 'tweekmonster/nvim-api-viewer'
"}}}
" === text objects === {{{
Plug 'tpope/vim-surround' " https://github.com/tpope/surround
Plug 'kana/vim-textobj-user'
Plug 'glts/vim-textobj-comment'
Plug 'glts/vim-textobj-indblock'

"}}}
" === markdown preview == {{{
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
" }}}
" Language Specific Plugins {{{
Plug 'vitalk/vim-shebang' "https://github.com/vitalk/vim-shebang
" https://github.com/vitalk/vim-fancy
" https://github.com/vitalk/vim-simple-todo
Plug 'othree/yajs.vim', { 'for': 'javascript' }           " JAVASCRPT SYNTAX object/method data comes from Mozilla's WebIDL
Plug 'HerringtonDarkholme/yats.vim',{'for': 'typescript'} " TYPESCRIPT
Plug 'gavocanov/vim-js-indent' ,{'for': 'javascript'}     " JAVASCRIPT INDENT
Plug 'elzr/vim-json', { 'for': 'json' } "                  JSON support
" Plug 'ap/vim-css-color', { 'for': 'css' }       "   CSS set the background of hex color values to the color
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' } "   CSS3 syntax support
Plug 'othree/html5.vim'                         "   HTML 5 with  WAI-ARIA attribute support
Plug 'othree/xml.vim'                           "   XML tags while you type
Plug 'tbastos/vim-lua', { 'for': 'lua' } "          LUA syntax and indentation support
Plug 'chr4/nginx.vim'                           "   NGINX with embeded lua block highlight
" Plug 'othree/nginx-contrib-vim', {'for': 'nginx'} " NGINX
Plug 'ledger/vim-ledger', {'for': 'ledger'}                           " lEDGER
Plug 'junegunn/vader.vim'                         " VIM    testing vim plugings -- use for syntax
" Plug 'heavenshell/vim-jsdoc' "  jsdocs  https://github.com/heavenshell/vim-jsdoc
" Plug 'ternjs/tern_for_vim', { 'do': 'npm install' } " setup tern
" Plug 'carlitux/deoplete-ternjs' " COMPLETION: deoplete tern as recomended by Shougo
" Plug 'othree/jspc.vim' ... COMPLETION:  function param completion
" Plug 'othree/javascript-libraries-syntax.vim'
" Plug 'othree/es.next.syntax.vim'
" JavaScript:  https://davidosomething.com/blog/vim-for-javascript/
"}}}
call plug#end()
