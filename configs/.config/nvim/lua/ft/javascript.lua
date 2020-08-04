M = {}


local on_attach = function()
  -- client
  --require'lsp_status'.on_attach(client)
  require'diagnostic'.on_attach()
end

--[[ set language server configuration ]]--
-------------------------------------------
-- Check 'cmd' executable is reachable
-- which typescript-language-server
local tConfig = {
  name = "javascript";
  cmd = { "typescript-language-server", "--stdio" };
  filetypes = { "javascript", "typescript" };
  on_attach= on_attach;
  }

local function startLanguageServer( pRoot )
  local tNewConfig = vim.tbl_extend("error", tConfig, {root_dir = pRoot;})
  local nClientID = vim.lsp.start_client(tNewConfig)
  return nClientID
end

M.startLanguageServer = startLanguageServer

return M
