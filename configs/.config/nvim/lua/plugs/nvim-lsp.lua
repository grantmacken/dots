M = {}

local init = function()
	require('my.globals').set({nvim_lsp = 1})  -- don't load all server configs at startup
	local cmd = vim.api.nvim_command
	cmd [[packadd! nvim-lsp]]
	vim._update_package_paths()
	require('nvim_lsp')._root._setup()
	require('nvim_lsp').sumneko_lua.setup{}
	end

M.init = init

return init()
