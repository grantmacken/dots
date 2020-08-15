require('my.globals').doNotLoad()
require('my.globals').gVars()
--[[
on new system
 omment out below
 do PackInstall
-]]
require('my.colors').setup({scheme = 'nord', packname = 'nord-vim' })
require('my.options').oAll()
--require('my.autocmds').set()
-- plugins
require('plugs.packer')
require('plugs.dirvish')
require('plugs.commentary')
require('plugs.gitgutter')
require('plugs.suda')
require('plugs.expressline')
require('plugs.telescope')
-- require('plugs.clap')
-- require('plugs.fzf')
-- require('plugs.gina')
-- require('plugs.lazygit')

lsp_complete_installable_servers = function()
	return table.concat(require('nvim_lsp').available_servers(), '\n')
end
lsp_complete_servers = function()
	return table.concat(require('nvim_lsp').installable_servers(), '\n')
end
require('plugs.nvim-lsp')

--[[
packadd! vim-gitgutter
"lua require('plugs.packer')
packanvim-lsp   " config not loaded
"lua require('plugs.dirvish')
"lua require('plugs.diagnostic')
"lua require('plugs.completion')
--]]
