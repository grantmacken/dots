require('my.globals').doNotLoad()
require('my.globals').gVars()
require('my.commands')()
--[[
on new system 
 omment out below
 do PackInstall
-]]
require('my.colors').setup({scheme = 'nord', packname = 'nord-vim' })
require('my.options').oAll()
require('my.autocmds').set()

-- plugins
require('plugs.dirvish')

local cmd = vim.api.nvim_command

--[[

packadd! vim-gitgutter
"lua require('plugs.packer')
packanvim-lsp   " config not loaded 
"lua require('plugs.dirvish')
"lua require('plugs.diagnostic')
"lua require('plugs.completion')
--]]
