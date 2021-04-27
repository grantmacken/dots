local M = {}
M.version = 'v0.0.1'
-- TODO https://github.com/airblade/vim-gitgutter
local init = function()
	local cmd = vim.api.nvim_command
	cmd [[packadd! vim-gitgutter]]
end
M.init = init
return M

