let s:save_cpo = &cpoptions
set cpoptions&vim
" https://hackernoon.com/the-last-statusline-for-vim-a613048959b2
" https://github.com/pgdouyon/dotfiles/blob/9cf1d2ede27c35ccd96a70773537ed996cc97284/config/nvim/autoload/statusline.vim

"  Statusline
" ============
function! my#statusline#statusline()
  let left_status = " %(%{my#statusline#getBuftypeText()}%.60t%m%r%)"
  let right_status = "%{&filetype} | %l::%-2v "
  " let accio_status = exists("*accio#statusline") ? ' %#WarningMsg#%{accio#statusline(" Errors %d ", "")}%*' : ""
  return left_status .  "  %=  " . right_status
  set statusline=
endfunction

function! my#statusline#getBuftypeText()
    " let buftype = (exists("g:loaded_fugitive") ? matchstr(fugitive#statusline(), 'Git(.*)') : "")
    let buftype = ''
    let buftype = (&buftype ==# "help" ? "Help" : buftype)
    let buftype = (&buftype ==# "quickfix" ? my#statusline#getQuickfixText() : buftype)
    let buftype = (&previewwindow ? "Preview" : buftype)
    let buftype = (&filetype ==# "dirvish" ? bufname("%") : buftype)
    return (empty(buftype) ? "" : buftype . " ")
endfunction

function! statusline#getQuickfixText()
    let grepprg = matchstr(&grepprg, '^\w*')
    let quickfix_title = (exists("w:quickfix_title") ? w:quickfix_title : "")
    let quickfix_title = substitute(quickfix_title, '\V:'.&grepprg, '', '')
    redir => buffers
    silent ls
    redir END

    let bufnr = bufnr("%")
    for buf in split(buffers, "\n")
        if (buf =~# '^\s*'.bufnr)
            if (buf =~# '\[Quickfix List\]')
                return "Quickfix [".grepprg.quickfix_title."]"
            else
                return "Location [".grepprg.quickfix_title."]"
            endif
        endif
    endfor
    return ""
endfunction

"  Tabline
" =========

function! my#statusline#tabline()
    let tabline_list = []
    for tabnr in range(tabpagenr("$"))
        let active_tab = (tabpagenr() == tabnr + 1)
        let tab_hl = (active_tab ? "%#TabLineSel#" : "%#TabLine#")
        let tab_nr = " %".(tabnr + 1)."T".(tabnr + 1)
        let tab_entry = tab_hl.tab_nr.' %{statusline#getTabEntry('.(tabnr + 1).')} '
        call add(tabline_list, tab_entry)
    endfor
    let tabline = join(tabline_list, "")
    return tabline
endfunction

function! statusline#getTabEntry(tabnr)
    let tab_buflist = tabpagebuflist(a:tabnr)
    let tab_winnr = tabpagewinnr(a:tabnr)
    let bufnr = tab_buflist[tab_winnr - 1]
    let modified = getbufvar(bufnr, "&modified")
    let filetype = getbufvar(bufnr, "&filetype")
    let bufname = (filetype ==# "qf" ? statusline#getQuickfixText() : bufname(bufnr))
    let bufname_tail = fnamemodify(bufname, ":t")
    let tab_entry = "%" . a:tabnr . "T"
    let tab_entry = (modified ? bufname_tail."+" : bufname_tail)
    return tab_entry
endfunction

"  Ruler
" ======

function! my#statusline#rulerFormat()
    " let git_branch = '%{empty(fugitive#head(6)) ? "" : fugitive#head(6) . " |"}'
    " let accio_errors = '%#WarningMsg#%{accio#statusline("  Errors %d ", "")}%*%{empty(accio#statusline("Errors %d", "")) ? "" : "|"}'
    let cursor_info = ' %l::%-2v%'
    return '%55(%=' . cursor_info . ')'
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
" nvim default set laststatus=2   Always show a status line
" set statusline=
" set statusline+=%f
" set statusline+=%m
" set statusline+=%=
" set statusline+=%l
" function! LinterStatus() abort
"   let l:counts = ale#statusline#Count(bufnr(''))
"   let l:all_errors = l:counts.error + l:counts.style_error
"   let l:all_non_errors = l:counts.total - l:all_errors
"   return l:counts.total == 0 ? '' : printf(
"         \ 'W:%d E:%d',
"         \ l:all_non_errors,
"         \ l:all_errors
"         \)
" endfunction

" ☂ ► ✓  ✗☹ ⚑ ⚐
"  ☺ ☻ ☹
"  ✍ ✎
"  ★ ☆ ☕ ✁
"  ✿ ❀ ✣ ✦ ✪ ✰ ☼
"  ➯ ➥ ➤ ↺ ↳ ⏎ ↵ ↵ ↵ ↵
"  ⚠ ⌛ ⚡ ℹ
" # ❶ ❷ ❸




" let g:currentmode={ 'n' : 'Normal ', 'no' : 'N·Operator Pending ', 'v' : 'Visual ', 'V' : 'V·Line ', '^V' : 'V·Block ', 's' : 'Select ', 'S': 'S·Line ', '^S' : 'S·Block ', 'i' : 'Insert ', 'R' : 'Replace ', 'Rv' : 'V·Replace ', 'c' : 'Command ', 'cv' : 'Vim Ex ', 'ce' : 'Ex ', 'r' : 'Prompt ', 'rm' : 'More ', 'r?' : 'Confirm ', '!' : 'Shell ', 't' : 'Terminal '}

" Function: return current mode
" abort -> function will abort soon as error detected
" function! ModeCurrent() abort
"   let l:modecurrent = mode()
"   " use get() -> fails safely, since ^V doesn't seem to register
"   " 3rd arg is used when return of mode() == 0, which is case with ^V
"   " thus, ^V fails -> returns 0 -> replaced with 'V Block'
"   " let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'V·Block '))
"   let l:current_status_mode = l:modelist
"   return l:current_status_mode
" endfunction
" " set statusline=
" " set statusline+=\ %{ModeCurrent()}
" " set statusline+=%L
" set statusline=
" set statusline+=%<\                       " cut at start
" " set statusline+=%2*[%n%H%M%R%W]%*\        " flags and buf no
" " set statusline+=\ %{namemodify( FindRootDirectory(), ':p:h') }
" " set statusline+=%{MyProjectRoot()}
" " set statusline+=%{MyProjectFramework()}
" set statusline+=\ ✎:%t                    " file
" " switching to right side
" set statusline+=%=%{LinterStatus()}       " right linter status
" set statusline+=%=%1*%y%*%*\              " file type
" set statusline+=%10((%l,%c)%)\            " line and column
" set statusline+=%P                        " percentage of file

