local M = {}

local custom_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

-- TODO convert to whichkey
local mappings = function(client, bufnr)
  local km = vim.api.nvim_buf_set_keymap
  local opts = {noremap = true, silent = true}
  km(bufnr,"n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  km(bufnr,"n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  km(bufnr,"n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  km(bufnr,"n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  km(bufnr,"n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  km(bufnr,"n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  km(bufnr,"n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  km(bufnr,"n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  km(bufnr,"n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  km(bufnr,"n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  km(bufnr,"n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  km(bufnr,"n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  km(bufnr,"n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  km(bufnr,"n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  km(bufnr,"n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    km(bufnr,"n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    km(bufnr,"n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end
end

local on_attach = function(client, bufnr )
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  require("my.lsp").mappings( client, bufnr )
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
M.mappings = mappings
M.custom_capabilities = custom_capabilities

return M
