function! s:on_stdout(jobID, data, event) abort
   lua << EOF
  require('my.jobs').jobOut(
  vim.api.nvim_eval('a:jobID'),
  vim.api.nvim_eval('a:data'),
  vim.api.nvim_eval('a:event')
  )
EOF
endfunction

function! s:on_stderr(jobID, data, event) abort
   lua << EOF
  require('my.jobs').jobErr(
  vim.api.nvim_eval('a:jobID'),
  vim.api.nvim_eval('a:data'),
  vim.api.nvim_eval('a:event')
  )
EOF
endfunction

function! s:on_exit(jobID, status, event) dict
  lua << EOF
  require('my.jobs').jobExit(
  vim.api.nvim_eval('a:jobID'),
  vim.api.nvim_eval('a:status'),
  vim.api.nvim_eval('a:event'),
  vim.api.nvim_eval('self.jobs')
  )
EOF
endfunction


function! my#jobs#job( oMyJobs ) abort
  " the first item
  let l:oJob = a:oMyJobs[0]
  let l:cmd = l:oJob['makeprg']
  let l:jobCommand = [&shell, &shellcmdflag, l:cmd]
  let l:job = jobstart(l:jobCommand, {
        \ 'on_stdout': function('s:on_stdout'),
        \ 'on_exit': function('s:on_exit'),
        \ 'jobs' : a:oMyJobs,
        \})

  if l:job <= 0
    return l:job
  endif
endfunction





