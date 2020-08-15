M = {}

local init = function()
 require('my.commands')({
  PackerClean = [[packadd packer.nvim | lua require('plugs.plugins').clean()]];
  PackerCompile = [[packadd packer.nvim | lua require('plugs.plugins').compile('~/.config/nvim/plugin/packer_load.vim')]];
  PackerInstall = [[packadd packer.nvim | lua require('plugs.plugins').install()]];
  PackerSync = [[packadd packer.nvim | lua require('plugs.plugins').sync()]];
  PackerUpdate = [[packadd packer.nvim | lua require('plugs.plugins').update()]];
})
end

M.init = init

return init()
