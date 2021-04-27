M = {}
--[[ set language server configuration ]]--
-------------------------------------------
-- Check 'cmd' executable is reachable
-- which typescript-language-server
local lsp = function()
  require('nvim_lsp').tsserver.setup{
    name = "tsserver";
    cmd = { "typescript-language-server", "--stdio" };
    filetypes = { "javascript", "typescript" };
    root_dir = require('toolbox.workspace').root();
    on_attach = function ( tClient )
      vim.api.nvim_buf_set_option( 0 , 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      -- local resolved_capabilities = tClient.resolved_capabilities
      require('completion').on_attach({}) -- table items from completion
      require('diagnostic').on_attach() -- alters callbacks
      require('lsp-status').on_attach( tClient )
    end;
  }
end



M.lsp = lsp


return M
