local lua_settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      enable = true,
      globals = {'vim','use','use_rocks'},
      disable = {'lowercase-global'}
    },
    workspace = {
      preloadFileSize = 400,
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
    telemetry = {
      enable = false
    }
  }
}

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    -- enable snippet support
    capabilities = capabilities,
    on_attach = require('my.lsp').on_attach,
    on_init = require('my.lsp').on_init
  }
end
local function setup_servers()
  require('lspinstall').setup()
  -- get all installed servers
  local servers = require('lspinstall').installed_servers()
  -- ... and add manually installed servers
  for _, server in pairs(servers) do
    local config = make_config()
    if server == "lua" then
      config.settings = lua_settings
    end
    require('lspconfig')[server].setup(config)
  end
end

setup_servers()
-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require('lspinstall').post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
