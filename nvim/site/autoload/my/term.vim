" autoload/my/term.vim - Global helpers for term
" Maintainer:  Grant MacKenzie

function! my#term#preserve(command)
  setlocal lazyredraw
  let l:search=@/

  let l:last_view = winsaveview()
  execute a:command
  call winrestview(l:last_view)

  let @/=l:search
  redraw
  setlocal nolazyredraw
endfunction


function! s:on_stdout(jobID, data, event) abort
   lua << EOF
  require('my.term').jobOut(
  vim.api.nvim_eval('a:jobID'),
  vim.api.nvim_eval('a:data'),
  vim.api.nvim_eval('a:event')
  )
EOF
endfunction

function! s:on_stderr(jobID, data, event) abort
   lua << EOF
  require('my.term').jobErr(
  vim.api.nvim_eval('a:jobID'),
  vim.api.nvim_eval('a:data'),
  vim.api.nvim_eval('a:event')
  )
EOF
endfunction

function! s:on_exit(jobID, status, event) dict
  lua << EOF
  require('my.term').jobExit(
  vim.api.nvim_eval('a:jobID'),
  vim.api.nvim_eval('a:status'),
  vim.api.nvim_eval('a:event'),
  vim.api.nvim_eval('self.job')
  )
EOF
endfunction


function! my#term#job( oMyTermJob ) abort
  let l:cmd = a:oMyTermJob['cmd']
  let l:job = termopen( l:cmd, {
        \ 'on_stdout': function('s:on_stdout'),
        \ 'on_stderr': function('s:on_stderr'),
        \ 'on_exit': function('s:on_exit'),
        \ 'job' : a:oMyTermJob,
        \})

  if l:job <= 0
    return l:job
  endif
endfunction


