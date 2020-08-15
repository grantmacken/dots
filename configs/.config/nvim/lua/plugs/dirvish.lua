local M = {}
M.version = 'v0.0.1'
--  nnoremap <buffer> <silent>D :lua require('my.utility').deleteFile()<CR>",
--" nnoremap <buffer> n :e %",
--" nnoremap <buffer> r :lua require('my.utility').renameFile()<CR>"
--    {'FileType', 'dirvish', 'noremap <buffer> n', ':e %'};
local init = function()
	local cmd = vim.api.nvim_command
	cmd [[packadd! vim-dirvish]]
	-- cmd [[packadd! vim-dirvish-git]] -- TODO
	require('my.globals').set(
	{
	    dirvish_git_indicators = {
		Modified  = '＊',
		Staged    = '＋',
		Untracked = '·',
		Renamed   = '➜',
		Unmerged  = '═',
		Ignored   = '☒',
		Unknown   = '?'
	}})

 require('my.commands')({
  Explore = { 
	  attr = {'-nargs=?', '-complete=dir' },
	  rep = "Dirvish <args>"
  };
  Vexplore = {
	  attr = {'-nargs=?', '-complete=dir' },
	  rep = {'leftabove', 'vsplit', '|', 'silent', 'Dirvish', '<args>'}
  };
  Sexplore = {
	  attr = {'-nargs=?', '-complete=dir' },
	  rep = {'belowright', 'split', '|', 'silent', 'Dirvish', '<args>'}
  };

})
end

M.init =init

return init()
--let g:dirvish_git_indicators = {
--  \ 'Modified'  : '＊',
--  \ 'Staged'    : '＋',
--  \ 'Untracked' : '·',
--  \ 'Renamed'   : '➜',
--  \ 'Unmerged'  : '═',
--  \ 'Ignored'   : '☒',
--  \ 'Unknown'   : '?'
--  \ }

