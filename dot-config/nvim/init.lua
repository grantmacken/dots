-- Initialization =============================================================
pcall(function()
  vim.loader.enable()
  -- vim.deprecate = function() end
end)
-- disable built-in providers
local providers = {
  "node",
  "perl",
  "ruby",
  "python",
  "python3",
}
for _, provider in ipairs(providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- disable built-in plugins
local plugins = {
  'gzip',
  'netrwPlugin',
  'rplugin',
  'tarPlugin',
  'tohtml',
  'tutor',
  'zipPlugin',
}
for _, plugin in ipairs(plugins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Set up package manager and plugins
-- These are loaded before the rest of the config, so that plugins can be used in the rest of the config
vim.pack.add({
  'gh:nvim-mini/mini.nvim',
  'gh:rebelot/kanagawa.nvim',
  'gh:stevearc/oil.nvim',
  'gh:rachartier/tiny-inline-diagnostic.nvim',
  'gh:rachartier/tiny-code-action.nvim',
}, { confirm = false })
