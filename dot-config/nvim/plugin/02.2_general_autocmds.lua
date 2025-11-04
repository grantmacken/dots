--[[ markdown
## Generic autocmds
Autocommands that don't fit into a specific category
--]]
local group = vim.api.nvim_create_augroup('my_group', {})
local au = function(event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback, desc = desc })
end

au(
  'TextYankPost',
  '*',
  function() vim.hl.on_yank() end,
  'Highlight yanked text'
)

-- close windows like 'help' with 'q'
au(
  'FileType',
  { 'help', 'oil' },
  function()
    local keymap = require('util').keymap
    keymap('q', '<cmd>close<cr>', 'close window')
  end, 'Close help and oil with q'
)
-- Create an autocommand to run the function on editor start
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local projects = require('projects')
    projects.select()
  end,
  once = true, -- Only run this once when Neovim starts
})


-- Restart lua_ls LSP server
vim.api.nvim_create_user_command('LuaLsRestart', function()
  local clients = vim.lsp.get_clients({ name = 'lua_ls' })
  for _, client in ipairs(clients) do
    vim.lsp.stop_client(client.id)
  end
  vim.defer_fn(function()
    vim.cmd('edit')
  end, 500)
end, { desc = 'Restart lua_ls LSP server' })
