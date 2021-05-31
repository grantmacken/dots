local sumneko_root = os.getenv("HOME") .. "/projects/lua-language-server"

local library = {}

local add = function(lib)
  for _, p in pairs(vim.fn.expand(lib, false, true)) do
    p = vim.loop.fs_realpath(p)
    library[p] = true
  end
end

-- add libraris to get detected by sumneko_lua
add("$VIMRUNTIME")
add("~/.config/nvim")

require("lspconfig").sumneko_lua.setup {
  cmd = {
    sumneko_root .. "/bin/Linux/lua-language-server",
    "-E",
    sumneko_root .. "/main.lua",
  },
  on_attach = require('my.lsp').on_attach,
  on_init = require('my.lsp').on_init,
  on_new_config = function(config, root)
    local libs = vim.tbl_deep_extend("force", {}, library)
    libs[root] = nil
    config.settings.Lua.workspace.library = libs
    return config
  end,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = (function()
          local path = vim.split(package.path, ";")
          table.insert(path, "lua/?.lua")
          table.insert(path, "lua/?/init.lua")
          return path
        end)(),
      },
      diagnostics = {
        enable = true,
        globals = {
          'vim', 'use', 'use_rocks'
        },
      },
      workspace = {
        preloadFileSize = 400,
        library = library,
      },
    },
  }
}
