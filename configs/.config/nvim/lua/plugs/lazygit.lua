M = {}
--- https://github.com/kdheepak/lazygit.nvim
local init = function()
	require('my.globals').set({
		--lazygit_floating_window_winblend = 0, -- default 0
		--lazygit_floating_window_scaling_factor = 0.9, -- default 0.9
	        -- lazygit_use_neovim_remote = 0 -- don't use neovim remote for commits

	})
 --local cmd = vim.api.nvim_command
 --cmd [[packadd! lazygit.nvim]]
end

M.init = init
return init()
