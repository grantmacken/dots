-- Some settings.
-- local to window settings for quickfix
vim.wo.number = false
vim.wo.relativenumber = false
vim.wo.signcolumn = 'no'
--vim.opt_local.list = false
vim.bo.buflisted = false
require('keymap').buf('q', '<cmd>cclose<cr>', 'close window', 0)
