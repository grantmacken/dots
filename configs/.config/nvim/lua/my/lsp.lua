local M = {}

local handlers = function()
  local lsp = vim.lsp
  local borders = {
    {"🭽", "FloatBorder"},
    {"▔", "FloatBorder"},
    {"🭾", "FloatBorder"},
    {"▕", "FloatBorder"},
    {"🭿", "FloatBorder"},
    {"▁", "FloatBorder"},
    {"🭼", "FloatBorder"},
    {"▏", "FloatBorder"}
  }
  lsp.handlers["textDocument/hover"] = lsp.with(
    lsp.handlers.hover, {
      border = borders
    }
  )
  lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(
    lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = {
        prefix = "■ ",
        spacing = 4,
      },
      signs = true,
      update_in_insert = false,
    }
  )
end

local mappings = function()
 --todo
end

local on_attach = function()
  require("my.lsp").mappings()
  require('lspkind').init({})
end

local on_init = function(client)
  print("Language Server Protocol started!")
  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end
end

M.on_init = on_init
M.on_attach = on_attach
M.handlers = handlers
M.mappings = mappings

return M
