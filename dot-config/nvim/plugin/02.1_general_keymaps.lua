--[[ Generic keymaps
--- Keymaps that don't fit into a specific category
--]]

local keymap = require('util').keymap
keymap('<ESC>', [[<cmd>noh<CR>]], 'ESC to remove search highlights', 'n')
keymap('<leader>R', function() vim.cmd('restart') end, 'Restart Neovim')
