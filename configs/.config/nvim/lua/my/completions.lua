M = {}

-- before plugin enabled
local setup = function()
  -- don't load *all* modules
  vim.g.loaded_compe_snippets_nvim = 1
  vim.g.loaded_compe_spell         = 1
  vim.g.loaded_compe_tags          = 1
  vim.g.loaded_compe_treesitter    = 1
  vim.g.loaded_compe_emoji         = 1
  vim.g.loaded_compe_omni          = 1
  vim.g.loaded_compe_vsnip         = 1
  vim.g.loaded_compe_ultisnips     = 1
  vim.g.loaded_compe_vim_lsc       = 1
  vim.g.loaded_compe_calc          = 1
end

-- after plugin enabled
local config = function()
  require("compe").setup({
    enabled              = true,
    debug                = false,
    min_length           = 2,
    preselect            = "disable",
    source_timeout       = 200,
    incomplete_delay     = 400,
    allow_prefix_unmatch = false,

    source = {
      path     = true,
      buffer   = true,
      luasnip  = true,
      nvim_lua = true,
      nvim_lsp = {
        enable = true,
        priority = 10001, -- takes precedence over file completion
      },
    },
  })
end

M.config = config
M.setup = setup

return M



