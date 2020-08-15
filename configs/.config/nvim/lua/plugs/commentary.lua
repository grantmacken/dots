local M = {}
M.version = 'v0.0.1'

local init = function()
  local cmd = vim.api.nvim_command
  cmd [[packadd! vim-commentary]]
  vim._update_package_paths()
  local sMode = 'n'
  local tOpts  = {noremap = true, silent = true}
  require('my.mappings')({
   { sMode, 'gc', [[<Cmd>Commentary<CR>]], tOpts };
   { sMode, 'gcc', [[<Cmd>CommentaryLine<CR>]] , tOpts };
  })
end

M.init = init
return init()
