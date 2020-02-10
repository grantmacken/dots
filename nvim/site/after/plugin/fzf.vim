" https://github.com/yuki-ycino/fzf-preview.vim
" Add fzf quit mapping
let g:fzf_preview_quit_map = 1

" Use floating window (for neovim)
let g:fzf_preview_use_floating_window = 1

" Commands used for fzf preview.
" The file name selected by fzf becomes {}
" let g:fzf_preview_command = 'head -100 {-1}'                       " Not installed ccat and bat
let g:fzf_preview_command = 'bat --color=always --style=grid {-1}' " Installed bat
" let g:fzf_preview_command = 'ccat --color=always {-1}'             " Installed ccat

" Commands used for binary file
let g:fzf_binary_preview_command = 'echo "{} is a binary file"'

" Commands used to get the file list from project
" let g:fzf_preview_filelist_command = 'git ls-files --exclude-standard'               " Not Installed ripgrep
let g:fzf_preview_filelist_command = 'rg --files --hidden --follow --no-messages -g \!"* *"' " Installed ripgrep

" Commands used to get the file list from git reposiroty
let g:fzf_preview_git_files_command = 'git ls-files --exclude-standard'

" Commands used to get the file list from current directory
let g:fzf_preview_directory_files_command = 'rg --files --hidden --follow --no-messages -g \!"* *"'

" Commands used to get the git status file list
let g:fzf_preview_git_status_command = "git status --short --untracked-files=all | awk '{if (substr($0,2,1) !~ / /) print $2}'"

" Commands used for project grep
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading'

" Commands used for preview of the grep result
let g:fzf_preview_grep_preview_cmd = expand('<sfile>:h:h') . '/bin/preview_fzf_grep'

" Keyboard shortcuts while fzf preview is active
let g:fzf_preview_preview_key_bindings = 'ctrl-d:preview-page-down,ctrl-u:preview-page-up,?:toggle-preview'

" Specify the color of fzf
let g:fzf_preview_fzf_color_option = ''

" Keyboard shortcut for opening files with split
let g:fzf_preview_split_key_map = 'ctrl-x'

" Keyboard shortcut for opening files with vsplit
let g:fzf_preview_vsplit_key_map = 'ctrl-v'

" Keyboard shortcut for opening files with tabedit
let g:fzf_preview_tabedit_key_map = 'ctrl-t'

" Keyboard shortcut for building quickfix
let g:fzf_preview_build_quickfix_key_map = 'ctrl-q'

" Command to be executed after file list creation
"let g:fzf_preview_filelist_postprocess_command = ''
" let g:fzf_preview_filelist_postprocess_command = 'xargs -d "\n" ls —color'          " Use dircolors
let g:fzf_preview_filelist_postprocess_command = 'xargs -d "\n" exa --color=always' " Use exa

" Use vim-devicons
" let g:fzf_preview_use_dev_icons = 0

" devicons character width
" let g:fzf_preview_dev_icon_prefix_length = 2


" https://github.com/junegunn/fzf/wiki/
" https://github.com/junegunn/fzf.vim
"nnoremap <silent> <Leader><Leader> :Files<CR>
"Most commands support CTRL-T / CTRL-X / CTRL-V key bindings to open in a new tab, a new split, or in a new vertical split


" Default fzf layout
" - down / up / left / right
" - window (nvim only)
"let $FZF_DEFAULT_OPTS .= ' --inline-info'
"let g:fzf_layout = { 'down': '~40%' }
"" In Neovim, you can set up fzf window using a Vim command
"" let g:fzf_layout = { 'window': 'enew' }
"" let g:fzf_layout = { 'window': '-tabnew' }
"" let g:fzf_layout = { 'window': '140split enew' }
"" Extend FZF env vars
"let $FZF_DEFAULT_OPTS .= ' --no-height'
"" An action can be a reference to a function that processes selected lines
"function! s:build_quickfix_list(lines)
"  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
"  copen
"  cc
"endfunction

"let g:fzf_action = { 'ctrl-l': function('s:build_quickfix_list'), 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }

"let g:fzf_history_dir =  expand($CACHEPATH . '/fzf-history')
"let g:fzf_filemru_bufwrite = 1
"let g:fzf_filemru_git_ls = 1
"" [Buffers] Jump to the existing window if possible
"let g:fzf_buffers_jump = 1
"" [[B]Commits] Customize the options used by 'git log':
"let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

"" [Commands] --expect expression for directly executing the command
"let g:fzf_commands_expect = 'alt-enter,ctrl-x'

"" Augmenting Ag command using fzf#vim#with_preview function
"command! -bang -nargs=* Rg call fzf#vim#grep(   'rg --vimgrep '.shellescape(<q-args>), 1,   <bang>0 ? fzf#vim#with_preview('up:60%')           : fzf#vim#with_preview(),   <bang>0)

"" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
"" Likewise, Files command with preview window
"command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

"" Mapping selecting mappings
"nmap <leader><tab> <plug>(fzf-maps-n)
"xmap <leader><tab> <plug>(fzf-maps-x)
"omap <leader><tab> <plug>(fzf-maps-o)


"" Insert mode completion
"" imap <c-x><c-k> <plug>(fzf-complete-word)
"imap <c-x><c-f> <plug>(fzf-complete-path)
"imap <c-x><c-j> <plug>(fzf-complete-file-ag)
"imap <c-x><c-l> <plug>(fzf-complete-line)

"" Advanced customization using autoload functions
"inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

"" function! s:fzf_statusline()
""   " Override statusline as you like
""   highlight fzf1 ctermfg=161 ctermbg=251
""   highlight fzf2 ctermfg=23 ctermbg=251
""   highlight fzf3 ctermfg=237 ctermbg=251
""   setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
"" endfunction

"" autocmd! User FzfStatusLine call <SID>fzf_statusline()


"" nnoremap <silent> <Leader>c  :Commands<CR>
"" nnoremap <silent> <Leader>r  :Rg<CR>
"" nnoremap <silent> <Leader>f  :FilesMru --tiebreak=end<CR>
"" nnoremap <silent> <Leader>t  :Tags<CR>
"" nnoremap <silent> <Leader>p  :ProjectMru --tiebreak=end<CR>

"" nnoremap <silent> <Leader>AG :Ag! <C-R><C-W><CR>
"" nnoremap <silent> <Leader>B  :Buffers!<CR>
"" nnoremap <silent> <Leader>F  :GFiles!<CR>
"" nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
"" nnoremap <silent> <Leader>b  :Buffers<CR>
"" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
"" --column: Show column number
"" --line-number: Show line number
"" --no-heading: Do not show file headings in results
"" --fixed-strings: Search term as a literal string
"" --ignore-case: Case insensitive search
"" --no-ignore: Do not respect .gitignore, etc...
"" --hidden: Search hidden files and folders
"" --follow: Follow symlinks
"" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
"" --color: Search color options
"" command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
""function! s:buflist()
"  " redir => ls
"  " silent ls
"  " redir END
"  " return split(ls, '\n')
"" endfunction

"" function! s:bufopen(e)
"  " execute 'buffer' matchstr(a:e, '^[ 0-9]*')
"" endfunction


"" nnoremap <silent> <Leader>b :call fzf#run({
"" \   'source':  reverse(<sid>buflist()),
"" \   'sink':    function('<sid>bufopen'),
"" \   'options': '+m',
"" \   'down':    len(<sid>buflist()) + 2
"" \   })<CR>
""
