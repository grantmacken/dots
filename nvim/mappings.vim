" My Mappings
" ========
" Use spacebar instead of '\' as leader. Require before loading plugins.
let g:mapleader      = ' '
let g:maplocalleader = ' '
" let g:maplocalleader=','
" " Release keymappings for plug-in.
nnoremap <Space>  <Nop>
xnoremap <Space>  <Nop>
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
" Plugin Mappings {{{
" vim-commentary maps, since it is loaded lazily
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine
" }}}
" Terminal Mappings {{{
" tnoremap <Esc> <C-\><C-n>
" }}}
vnoremap <LeftRelease> "*ygv

