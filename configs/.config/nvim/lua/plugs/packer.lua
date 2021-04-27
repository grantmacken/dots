M = {}

local init = function()
 require('my.commands')({
  PackerClean = [[packadd packer.nvim | lua require('plugins').clean()]];
  PackerCompile = [[packadd packer.nvim | lua require('plugins').compile('~/.config/nvim/plugin/packer_load.vim')]];
  PackerInstall = [[packadd packer.nvim | lua require('plugins').install()]];
  PackerSync = [[packadd packer.nvim | lua require('plugins').sync()]];
  PackerUpdate = [[packadd packer.nvim | lua require('plugins').update()]];
})
end

M.init = init

return M
