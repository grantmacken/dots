scriptencoding utf-8
let $TERM='xterm-kitty'
" let &runtimepath = &runtimepath
" let mapleader = '\<Space>'
lua require('my.globals').doNotLoad()
lua require('my.globals').gVars()
lua require('my.colors').setup({scheme = 'nord', packname = 'nord-vim' })
lua require('my.options').oAll()
lua require('my.autocmds').set()
packadd! vim-gitgutter
lua require('plugs.packer')
packadd! nvim-lsp   " config not loaded 
lua require('plugs.dirvish')
lua require('plugs.diagnostic')
lua require('plugs.completion')
packadd! vim-smoothie

" Plug 'wesQ3/vim-windowswap'
"   let g:windowswap_map_keys = 0 "prevent default bindings
"   nnoremap <silent> <leader>ww :call WindowSwap#EasyWindowSwap()<CR>
"  plug settings

" packadd! diagnostic-nvim
"packadd! vim-vsnip
"packadd! vim-vsnip-integ
"packadd! completion-nvim
" packadd! nvim-treesitter
" map  gc  <Plug>Commentary
" nmap gcc <Plug>CommentaryLine
"@track https://github.com/haorenW1025/config/blob/master/.config/nvim/init.lua
" execute 'luafile ' . stdpath('config') . '/lua/plugs/treesitter.lua'



" Configure the completion chains
 
" let g:completion_enable_auto_hover = 0
" let g:completion_chain_complete_list = {
" 			\'default' : {
" 			\	'default' : [
" 			\		{'complete_items' : [ 'snippet']},
" 			\		{'mode' : 'file'}
" 			\	],
" 			\	'comment' : [],
" 			\	'string' : []
" 			\	},
" 			\'vim' : [
" 			\	{'complete_items': ['snippet']},
" 			\	{'mode' : 'cmd'}
" 			\	],
" 			\'lua' : [
" 			\	{'complete_items': ['ts']}
" 			\	],
" 			\}

" Use completion-nvim in every buffer
" autocmd BufEnter * lua require'completion'.on_attach()

" filetype plugin indent on
" syntax on
" filetypes: 
" config for each ft in after/ftplugin/{FILETYPE}.vim
"  - set buffer options
" lsp and tree-sitter:
"
" function!  Print()
"   lua  print(vim.inspect(vim.lsp))
" endfunction

" command! P :call return Print()
" command! LangServInit :call return LanguageServerInit()

"map <c-p> to manually trigger completion
" inoremap <silent><expr> <c-p> completion#trigger_completion()
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"



" completions: on each after/filetype set
" set omnifunc=v:lua.vim.lsp.omnifunc
" completions: globals set in lua/my/globals

" lua require('my.commands').setCmds()o
" Use <Tab> and <S-Tab> to navigate through popup menu
" move cursor to other window
" by CTRL-hjkl
"" Split navigation
" tnoremap <C-h> <C-\><C-N><C-w>h
" tnoremap <C-j> <C-\><C-N><C-w>j
" tnoremap <C-k> <C-\><C-N><C-w>k
" tnoremap <C-l> <C-\><C-N><C-w>l
" inoremap <C-h> <C-\><C-N><C-w>h
" inoremap <C-j> <C-\><C-N><C-w>j
" inoremap <C-k> <C-\><C-N><C-w>k
" inoremap <C-l> <C-\><C-N><C-w>l
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" Quickfix history navigation
" noremap ]h <Cmd>cnewer<CR>
" noremap [h <Cmd>colder<CR>
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l
" nnoremap <C-h> <C-w>
"
" Used to prevent opening new buffers in a small buffers
" command! SwitchToNormalBuffer lua require'buffers'.switch_to_normal_buffer()
" " Delete buffer with saving the current layout (except special buffers)
" command! BDelete lua require'buffers'.close_current_buffer()
" " Delete all buffers except the current one
" command! BDeleteOther lua require'buffers'.close_other_buffers()





" lua require('my.mappings').setMappings()
" lua require('my.statusline').set()
" Space is always the leader
" autocmd TextYankPost * silent! lua vim.highlight.on_yank()
" vim-commentary maps, since it is loaded lazily

" Got from https://prettier.io/docs/en/vim.html
"nnoremap gp :silent %!prettier --stdin-filepath % --trailing-comma all --single-quote<CR>
" nnoremap   <silent>   <F12>   :FloatermToggle<CR>
" tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>
" By default timeoutlen is 1000 ms TODO in setup
" set timeoutlen=500

" let $GIT_EDITOR = 'nvr -cc split --remote-wait'
" let $PROJECTS_PATH=expand( $HOME . '/projects/grantmacken')
" execute 'luafile ' . stdpath('config') . '/lua/plugins.lua'

lua << EOF
--[[
vim.fn.{func}
Read, set and clear
print(vim.g.my_global_variable)
vim.g.my_global_variable = 5
vim.g.my_global_variable = nil

vim.g  g: 
vim.b  b:
vim.b  w:
vim.v  v:
vim.o  option
vim.bo buffer option
vim.wo window option

inpect
paste - can be used to scrub term color-codes
--]]
EOF
