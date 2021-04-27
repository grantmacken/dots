M = {}
local vim = vim
-- define an chain complete list
local chain_complete_list = {
	default = {
		{complete_items = {'lsp', 'snippet'}},
		{complete_items = {'path'}, triggered_only = {'/'}},
		{complete_items = {'buffers'}},
	},
	string = {
		{complete_items = {'path'}, triggered_only = {'/'}},
	},
	comment = {},
}

local lsp = function() 
 require('nvim_lsp').sumneko_lua.setup{
	name = 'sumneko_lua';
	cmd = { 'lua-language-server' };
	root_dir = require('toolbox.workspace').root();
	filetypes = { 'lua' };
	settings = {
		Lua = {
		diagnostics = {
			enable = true,
			globals = {'vim'},
			disable = {"lowercase-global"}
		},
		completion = {keywordSnippet = 'Disable'},
		runtime = {version = 'LuaJIT'}
		}
	};
	on_attach = function ( tClient )
		vim.api.nvim_buf_set_option( 0 , 'omnifunc', 'v:lua.vim.lsp.omnifunc')
		-- local resolved_capabilities = tClient.resolved_capabilities
		require('completion').on_attach({}) -- table items from completion
		require('diagnostic').on_attach() -- alters callbacks
		require('lsp-status').on_attach( tClient )
          end;
	  }
end



-- https://neovim.io/doc/user/lsp.html
 local startLanguageServer = function( pRoot )
    --local tNewConfig = vim.tbl_extend("error", tConfig, {root_dir = pRoot;})
    return vim.lsp.start_client( {
      name = 'sumneko_lua';
      cmd = { 'lua-language-server' };
      root_dir = pRoot;
      filetypes = { 'lua' };
      on_init = function( tClient, tResult  )
       settings = {
	Lua = {
	  diagnostics = {
	  globals = {"vim"},
	  disable = {"lowercase-global"}
      }}};
      return
      end;
      on_attach = function ( tClient , nBuf )
        vim.api.nvim_buf_set_option( nBuf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	-- local resolved_capabilities = tClient.resolved_capabilities
	--[[
	require('completion').on_attach({ -- table items from completion
            sorter = 'alphabet',
            matcher = {'exact', 'fuzzy'}
	})
	--]]
	require('diagnostic').on_attach() -- alters callbacks
	require('completion').on_attach()
	require('lsp-status').on_attach( tClient )
	require('my.mappings').bufferSet( nBuf, { -- TODO -- set buffer keymaps with which - key
		{'n', 'gd', [[<Cmd>lua vim.lsp.buf.declaration()<CR>]]};
		{'n', '1gD', [[<Cmd>lua vim.lsp.buf.type_definition()<CR>]]};
		{'n', 'gr', [[<Cmd>lua vim.lsp.buf.references()<CR>]]};
		{'n', '<space>sl', [[<Cmd>lua vim.lsp.util.show_line_diagnostics()<CR>]]};
	})
   end;
       -- END start options table
    })
  end

-- local setCommands = function()
--   local cmd = vim.api.nvim_command
--   cmd('command! LspBufClients lua print(vim.inspect(vim.lsp.buf_get_clients()))')
-- end
local setBufferOptions = function()
  require('my.options').setCommonBufferOptions()
end

--M.startLanguageServer = startLanguageServer
-- M.setBufferOptions = setBufferOptions
--
local workspace = {
 lsp = true;
 bufferOptions = {
  shiftwidth = 2,
  tabstop = 2,
  expandtab = true,
  textwidth = 120
 }
}

M.workspace = workspace
M.lsp = lsp
return M
