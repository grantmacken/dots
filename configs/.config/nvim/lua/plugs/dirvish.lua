--let g:dirvish_git_indicators = {
--  \ 'Modified'  : '＊',
--  \ 'Staged'    : '＋',
--  \ 'Untracked' : '·',
--  \ 'Renamed'   : '➜',
--  \ 'Unmerged'  : '═',
--  \ 'Ignored'   : '☒',
--  \ 'Unknown'   : '?'
--  \ }

--
--
--

--  nnoremap <buffer> <silent>D :lua require('my.utility').deleteFile()<CR>",
--" nnoremap <buffer> n :e %",
--" nnoremap <buffer> r :lua require('my.utility').renameFile()<CR>"
M = {}

local init = function()
  local cmd = vim.api.nvim_command
  cmd [[packadd! vim-dirvish]]
  cmd [[command! -nargs=? -complete=dir Explore Dirvish <args>]]
  cmd [[command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>]]
  cmd [[command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>]]
end

M.init =init

return init()
