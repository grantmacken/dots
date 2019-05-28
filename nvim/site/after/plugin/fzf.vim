" https://github.com/junegunn/fzf/wiki/
" https://github.com/junegunn/fzf.vim
"nnoremap <silent> <Leader><Leader> :Files<CR>
"Most commands support CTRL-T / CTRL-X / CTRL-V key bindings to open in a new tab, a new split, or in a new vertical split


" Default fzf layout
" - down / up / left / right
" - window (nvim only)
"let $FZF_DEFAULT_OPTS .= ' --inline-info'
let g:fzf_layout = { 'down': '~40%' }
" In Neovim, you can set up fzf window using a Vim command
" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }
" let g:fzf_layout = { 'window': '140split enew' }
" Extend FZF env vars
let $FZF_DEFAULT_OPTS .= ' --no-height'
" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = { 'ctrl-l': function('s:build_quickfix_list'), 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }

let g:fzf_history_dir =  expand($CACHEPATH . '/fzf-history')
let g:fzf_filemru_bufwrite = 1
let g:fzf_filemru_git_ls = 1
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" Augmenting Ag command using fzf#vim#with_preview function
command! -bang -nargs=* Rg call fzf#vim#grep(   'rg --vimgrep '.shellescape(<q-args>), 1,   <bang>0 ? fzf#vim#with_preview('up:60%')           : fzf#vim#with_preview(),   <bang>0)

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)


" Insert mode completion
" imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" function! s:fzf_statusline()
"   " Override statusline as you like
"   highlight fzf1 ctermfg=161 ctermbg=251
"   highlight fzf2 ctermfg=23 ctermbg=251
"   highlight fzf3 ctermfg=237 ctermbg=251
"   setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
" endfunction

" autocmd! User FzfStatusLine call <SID>fzf_statusline()


" nnoremap <silent> <Leader>c  :Commands<CR>
" nnoremap <silent> <Leader>r  :Rg<CR>
" nnoremap <silent> <Leader>f  :FilesMru --tiebreak=end<CR>
" nnoremap <silent> <Leader>t  :Tags<CR>
" nnoremap <silent> <Leader>p  :ProjectMru --tiebreak=end<CR>

" nnoremap <silent> <Leader>AG :Ag! <C-R><C-W><CR>
" nnoremap <silent> <Leader>B  :Buffers!<CR>
" nnoremap <silent> <Leader>F  :GFiles!<CR>
" nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
" nnoremap <silent> <Leader>b  :Buffers<CR>
" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
" command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
"function! s:buflist()
  " redir => ls
  " silent ls
  " redir END
  " return split(ls, '\n')
" endfunction

" function! s:bufopen(e)
  " execute 'buffer' matchstr(a:e, '^[ 0-9]*')
" endfunction


" nnoremap <silent> <Leader>b :call fzf#run({
" \   'source':  reverse(<sid>buflist()),
" \   'sink':    function('<sid>bufopen'),
" \   'options': '+m',
" \   'down':    len(<sid>buflist()) + 2
" \   })<CR>
"
