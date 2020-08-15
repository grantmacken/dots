local M = {}
M.version = 'v0.0.1'
-- TODO https://github.com/airblade/vim-gitgutter
local init = function()
  local cmd = vim.api.nvim_command
  cmd [[packadd! plenary.nvim]]
  cmd [[packadd! telescope.nvim]]
  vim._update_package_paths()
end

M.init =init

return init()
