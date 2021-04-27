local M = {}
M.version = 'v0.0.1'
local init = function()
  local cmd = vim.api.nvim_command
  cmd [[packadd vim-commentary]]
  local sMode = 'n'
  local tOpts  = {noremap = true, silent = true}
  require('my.mappings').set({
   { 'n', 'gc', [[<Cmd>Commentary<CR>]], tOpts };
   { 'v', 'gc', [[<Cmd>Commentary<CR>]], tOpts };
   { 'n', 'gcc', [[<Cmd>CommentaryLine<CR>]] , tOpts };
  })
end

M.init = init
return M
