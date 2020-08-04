M = {}

local init = function()
  local cmd = vim.api.nvim_command
  cmd [[command! PackerInstall packadd! packer.nvim | lua require('packer').install()]]
  cmd [[command! PackerUpdate  packadd! packer.nvim | lua require('packer').update()]]
  cmd [[command! PackerSync    packadd! packer.nvim | lua require('packer').sync()]]
  cmd [[command! PackerClean   packadd! packer.nvim | lua require('packer').clean()]]
  cmd [[command! PackerCompile packadd! packer.nvim | lua require('packer').compile()]]
end

M.init = init

return init()
