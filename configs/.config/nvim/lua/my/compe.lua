local M = {}

-- before plugin enabled
local setup = function()
  vim.opt.completeopt = { "menuone", "noselect" }
  -- Don't show the dumb matching stuff.
  vim.cmd [[set shortmess+=c]]
  -- don't load *all* modules
  vim.g.loaded_compe_snippets_nvim = 1
  vim.g.loaded_compe_tags          = 1
  vim.g.loaded_compe_emoji         = 1
 -- vim.g.loaded_compe_omni          = 1
  vim.g.loaded_compe_vsnip         = 1
  vim.g.loaded_compe_ultisnips     = 1
  vim.g.loaded_compe_vim_lsc       = 1
  vim.g.loaded_compe_calc          = 1
end


local remaps = function()

  local remap = vim.api.nvim_set_keymap
  remap(
    "i",
    "<Tab>",
    table.concat({
      "pumvisible() ? \"<C-n>\" : v:lua.Util.check_backspace()",
      "? \"<Tab>\" : compe#confirm()",
    }),
    { silent = true, noremap = true, expr = true }
  )

remap(
  "i",
  "<S-Tab>",
  "pumvisible() ? \"<C-p>\" : \"<S-Tab>\"",
  { noremap = true, expr = true }
)

remap(
  "i",
  "<C-Space>",
  "compe#complete()",
  { noremap = true, expr = true, silent = true }
)
end


-- after plugin enabled
local config = function()
  require("compe").setup({
    enabled              = true;
    autocomplete         = false;
    debug                = false;
    min_length           = 3;
    preselect            = 'enable';
    throttle_time = 80;
    source_timeout       = 200;
    incomplete_delay     = 400;
    allow_prefix_unmatch = false;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;
    source = {
      path     = true;
      buffer   = false;
      calc = false;
      spell = true;
      tags = false;
      vsnip = false;
      luasnip  = true;
      nvim_lua = true;
      nvim_lsp = {
        enable = true;
        priority = 10001; -- takes precedence over file completion
      };
      -- treesitter = true; --?
    };
  })

  remaps()
end

M.setup = setup
M.config = config

return M



