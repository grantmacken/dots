M = {}
--- https://github.com/nvim-lua/completion-nvim/wiki/per-server-setup-by-lua
--  TODO every option can be passed and will remove global options.

local chain_complete_list = {
  lua = {
    {complete_items = {'snippet'}},
    {mode = '<c-p>'},
    {mode = '<c-n>'}
  },
  string = {
    {complete_items = {'path'}, triggered_only = {'/'}},
  },
  comment = {},
}

local matcher = {'exact', 'substring'}

  -- completion_enable_auto_popup = 0, --disable autopopup
  -- completion_trigger_keyword_length = 1, default
  -- completion_timer_cycle = 80, default
  -- completion_trigger_character = [],
  -- completion_sorting = 'none',
  -- completion_enable_snippet = 'vim-vsnip',
  -- completion_matching_strategy_list = { 'exact', 'substring' },
  -- completion_enable_auto_signature = 1,
  -- completion_auto_change_source = 1,
  -- completion_enable_auto_hover = 1,
  --[[
  -- bufnr = 1,                                                                                                                                   
  code = "undefined-global",                                                                                                                     
    col = 27,                                                                                                                                      
    lnum = 85,                                                                                                                                     
    message = "Undefined global `unpack`.(Defined in Lua 5.1/LuaJIT, current is Lua 5.3.)",                                                        
    range = {                                                                                                                                      
      end = {                                                                                                                                      
        character = 32,                                                                                                                            
        line = 84                                                                                                                                  
      },                                                                                                                                           
      start = {                                                                                                                                    
        character = 26,                                                                                                                            
        line = 84                                                                                                                                  
      }
   config passed direct
   @param pRoot as string - path to git root
   @return clientID as number
  --]]

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
      on_init = function( tClient, tResult  )
        --print( vim.inspect( tResult ) )
        return
      end;
      callbacks = {
	      ['textDocument/publishDiagnostics'] = function(err, method, result, sClientID )
	        --print(vim.inspect(result.diagnostics ))
	        -- print(vim.inspect( method ))
	        -- print(vim.inspect( sClientID ))
          local uriToBufnr = require('vim.uri').uri_to_bufnr
	        --filename = vim.uri_to_fname(symbol.location.uri)
          if result and result.diagnostics then
            for _, v in ipairs(result.diagnostics) do
            --   v.uri = v.uri or result.uri
            v.bufnr = uriToBufnr(result.uri)
            v.lnum = v.range.start.line + 1
            v.col = v.range.start.character + 1
            v.text = v.message
            --  print(vim.inspect( result.uri ))
            end
            -- print(vim.inspect( result.uri ))
            vim.lsp.util.set_qflist(result.diagnostics)
          end
       end
       };
      on_attach = function( tClient , nBuf )
        vim.api.nvim_buf_set_option( nBuf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
     -- TODO bases on 
        local tCapabilities = tClient.resolved_capabilities
        -- print( vim.inspect( tCapabilities ) )
        --if tClient.resolved_capabilities.document_formatting then
          --api.nvim_command("autocmd BufWritePre <buffer> lua init.formatting_sync(nil, 1000)")
        --end
        -- require('diagnostic').on_attach()
        -- print( tostring( nBuf ) )
         -- print( type( nClientID ) )
        -- TODO -- set buffer keymaps with which - key
        --
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
