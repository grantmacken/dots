--[[ Generic keymaps
--- Keymaps that don't fit into a specific category
--]]

local keymap = require('util').keymap
keymap('<ESC>', [[<cmd>noh<CR>]], 'ESC to remove search highlights', 'n')
keymap('<leader>R', function() vim.cmd('restart') end, 'Restart Neovim')
keymap('<leader>aa', function()
  -- add current file to arglist.
  vim.cmd.argedit(vim.fn.expand('%'))
  -- remove dups from arglist.
  vim.cmd('argdedupe')
  vim.cmd('args')
end, 'Arglist Again')
