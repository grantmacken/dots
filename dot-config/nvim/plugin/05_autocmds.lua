--[[
Autocommands:
--]]

local group = vim.api.nvim_create_augroup('custom-config', {})
local au = function(event, pattern, callback, desc)
  local opts = { group = group, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end


-- local group_once = vim.api.nvim_create_augroup('custom-config_once', {})
-- local au_once = function(event, pattern, callback, desc)
--   local opts = {once = true, group = group_once, pattern = pattern, callback = callback, desc = desc }
--   vim.api.nvim_create_autocmd(event, opts)
-- end


--
-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
local f = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end
au('FileType', nil, f, "Proper 'formatoptions'")

-- Auto-root to git repo or Makefile
local ok_misc, miniMisc = pcall(require, 'mini.misc')
if ok_misc then
  miniMisc.setup_restore_cursor()
  miniMisc.setup_auto_root({ '.git', 'Makefile' })
  miniMisc.setup_termbg_sync()
end

-- highlight yanked text
au(
  'TextYankPost',
  '*',
  function() vim.hl.on_yank({ higroup = 'Visual', timeout = 200 }) end,
  'Highlight yanked text'
)

au(
  'FileType',
  { 'help', 'notify', 'oil' },
  function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.b.miniindentscope_disable = true
  end, 'Enable line wrapping for help, notify, and oil'
)

-- Automatically enable spellcheck and wrap for GitHub CLI temp files
au(
  "BufRead",
  "gh-editor-*.md",
  function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
  "Enable spellcheck and wrap for GitHub CLI temp files"
)

--- TODO
--- auto-load some standard plugins that are not loaded by default
--- @see url https://neovim.io/doc/user/plugins.html#standard-plugin-list
--- @see file  /usr/local/share/nvim/runtime/pack/dist/opt/




-- au('WinClosed', '*', function(args)
--     local closedWinID = tonumber(args.match)
--     -- check if the closed window is the show window for the tabpage
--     if vim.t['winID'] == closedWinID then
--       local tabID = vim.api.nvim_get_current_tabpage()
--       vim.api.nvim_tabpage_del_var(tabID,'')
--       vim.notify('Show window closed, cleared tabpage variables', vim.log.levels.INFO)
--     end
--   end,
--   'Clear tabpage variables when show window is closed'
-- )
-- Restart lua_ls LSP server
-- vim.api.nvim_create_user_command('LuaLsRestart', function()
--   local clients = vim.lsp.get_clients({ name = 'lua_ls' })
--   for _, client in ipairs(clients) do
--     vim.lsp.stop_client(client.id)
--   end
--   vim.defer_fn(function()
--     vim.cmd('edit')
--   end, 500)
-- end, { desc = 'Restart lua_ls LSP server' })
