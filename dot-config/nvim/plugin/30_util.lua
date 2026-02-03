-- local keymap = require('keymap')
--
--
-- copy path to clipboard
vim.api.nvim_create_user_command(
  'UtilCurrentPath',
  function()
    local util = require('util')
    util.get_relative_file_path()
  end,
  { desc = 'Copy relative file path to clipboard' }
)
