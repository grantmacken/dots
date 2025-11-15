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

--- auto-load some standard plugins that are not loaded by default
--- @see url   https://neovim.io/doc/user/plugins.html#standard-plugin-list
--- @see file  /usr/local/share/nvim/runtime/pack/dist/opt/
---
au("VimEnter", "*", function()
    local builtins = { 'cfilter', 'difftool', 'nohlsearch', 'nvim.undotree' }
    for _, plugin in ipairs(builtins) do
      vim.cmd.packadd(plugin)
    end
    require('projects').picker() -- load project selector on startup
  end,
  'load standard plugins and project picker on startup'
)

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
