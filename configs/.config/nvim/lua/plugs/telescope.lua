local M = {}
M.version = 'v0.0.1'
local init = function()
  local cmd = vim.api.nvim_command
  cmd [[packadd popup.nvim]]
  cmd [[packadd plenary.nvim]]
  cmd [[packadd telescope.nvim]]
  -- Fuzzy find over git files in your directory
  --require('telescope.builtin').git_files()
  -- Grep files as you type (requires rg currently)
  --require('telescope.builtin').live_grep()
  -- Use builtin LSP to request references under cursor. Fuzzy find over results.
 --require('telescope.builtin').lsp_references()
  -- Convert currently quickfixlist to telescope
  --require('telescope.builtin').quickfix()
  -- Convert currently loclist to telescope
  --require('telescope.builtin').loclist()
require('my.commands')({
 GitFiles  = [[lua require('telescope.builtin').git_files()]];
	})
end

M.init =init

return init()
