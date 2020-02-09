function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
call plug#begin( expand( $DATAPATH . '/plugged'))
" Themes and Colorscheme {{{
" Plug 'itchyny/lightline.vim'
Plug 'junegunn/seoul256.vim'
" Plug 'shinchu/lightline-seoul256.vim'
" }}}
Plug 'junegunn/vim-peekaboo' "https://github.com/junegunn/vim-peekaboo
Plug 'machakann/vim-highlightedyank' " highligh yank text
Plug 'tpope/vim-commentary'  , { 'on': ['<Plug>Commentary', '<Plug>CommentaryLine'] }


" File_And_Project_Management {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'yuki-ycino/fzf-preview.vim'
Plug 'airblade/vim-gitgutter'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
"GF: site/after/plugin/fzf.vim/
Plug 'justinmk/vim-dirvish' 
"URL: https://github.com/justinmk/vim-dirvish/blob/master/doc/dirvish.txt
"GF: site/after/ftplugin/dirvish.vim
Plug 'mhinz/vim-startify'
"GF: site/after/plugin/startify.vim
"@ sessions
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-eunuch'     " https://github.com/tpope/vim-eunuch
Plug 'tpope/vim-dotenv' " https://github.com/tpope/vim-dotenv
" Plug 'tpope/surround' " https://github.com/tpope/vim-dotenv
" Plug 'tpope/vim-dispatch':
" Plug 'radenling/vim-dispatch-neovim'
Plug 'arithran/vim-delete-hidden-buffers'
" Plug 'mhinz/vim-grepper'
" let g:grepper = {}
" let g:grepper.tools = ['grep', 'git', 'rg']
" Plug 'skwp/greplace.vim' "https://github.com/skwp/greplace.vim/blob/master/doc/greplace.txt
" Plug 'tweekmonster/nvim-api-viewer'
"}}}
" Language Specific Plugins {{{ 
Plug 'vitalk/vim-shebang' "https://github.com/vitalk/vim-shebang
" https://github.com/vitalk/vim-fancy
" https://github.com/vitalk/vim-simple-todo
Plug 'othree/yajs.vim', { 'for': 'javascript' }           " JAVASCRPT SYNTAX object/method data comes from Mozilla's WebIDL
Plug 'HerringtonDarkholme/yats.vim',{'for': 'typescript'} " TYPESCRIPT
Plug 'gavocanov/vim-js-indent' ,{'for': 'javascript'}     " JAVASCRIPT INDENT
Plug 'elzr/vim-json', { 'for': 'json' } "                  JSON support
Plug 'ap/vim-css-color', { 'for': 'css' }       "   CSS set the background of hex color values to the color
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
" Plug 'tmux-plugins/vim-tmux'
" Plug 'othree/javascript-libraries-syntax.vim'
" Plug 'othree/es.next.syntax.vim'
" JavaScript:  https://davidosomething.com/blog/vim-for-javascript/
"}}}
call plug#end()



