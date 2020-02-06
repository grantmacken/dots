function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
call plug#begin( expand( $DATAPATH . '/plugged'))
" Themes and Colorscheme {{{
" Plug 'itchyny/lightline.vim'
Plug 'junegunn/seoul256.vim'
" Plug 'shinchu/lightline-seoul256.vim'
" }}}

Plug 'machakann/vim-highlightedyank' " highligh yank text
Plug 'tpope/vim-commentary'  , { 'on': ['<Plug>Commentary', '<Plug>CommentaryLine'] }


" File_And_Project_Management {{{

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
call plug#end()



