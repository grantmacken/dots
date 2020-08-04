M = {}
 local startLanguageServer = function( pRoot )
    --local tNewConfig = vim.tbl_extend("error", tConfig, {root_dir = pRoot;})
    return vim.lsp.start_client( {
      name = 'sumneko_lua';
      cmd = { 'lua-language-server' };
      root_dir = pRoot;
      filetypes = { 'lua' };
      settings = {
        Lua = {
          diagnostics = {
            enable = true,
            globals = {'vim' },
            disable = {"lowercase-global"}
          },
          completion = {keywordSnippet = 'Disable'},
          runtime = {version = 'LuaJIT'}
        }
      };
      --on_init = function( tClient, tResult  )
      --  --print( vim.inspect( tResult ) )
      --  return
      --end;
      on_attach = function( tClient , nBuf )
        vim.api.nvim_buf_set_option( nBuf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        require('diagnostic').on_attach() -- alters callbacks
        require('completion').on_attach() -- alters callbacks
        -- TODO -- set buffer keymaps with which - key
        -- populate quickfix list with diagnostics
      end;
    })
  end

-- local setCommands = function()
--   local cmd = vim.api.nvim_command
--   cmd('command! LspBufClients lua print(vim.inspect(vim.lsp.buf_get_clients()))')
-- end
local setBufferOptions = function()
  
  require('my.options').setCommonBufferOptions()
end

M.startLanguageServer = startLanguageServer
M.setBufferOptions = setBufferOptions

return M
