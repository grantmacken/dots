M = {}
local vim = vim
local api = vim.api

-- local inspect = vim.inspect
--[[
https://neovim.io/doc/user/lsp.htm
https://github.com/haorenW1025/diagnostic-nvim
https://github.com/haorenW1025/completion-nvim

TODO!
- [ ] per buffer config based on projections
Post * lua require('langsrvr.erlang').check_start_erlang_lsp()
--]]

local attach = function()
  require('diagnostic').on_attach()
  require('completion').on_attach()
end

M.completion_done = function()
  if ( vim.fn.pumvisible() ) then
    vim.api.nvim_command("pclose")
  end
end

local setup_vista = function()
-- api.nvim_set_var('vista#renderer#enable_icon',1)
api.nvim_set_var('vista_default_executive','nvim_lsp')
api.nvim_set_var('vista_executive_for', { ['lua'] = 'nvim_lsp'} )
-- let g:vista_default_executive = 'nvim_lsp'
-- " let g:vista_default_executive = 'ctags'
-- let g:vista_executive_for = {
--   \ 'lua': 'vim_lsp'
--   \ }
-- let g:vista_fzf_preview = ['right:70%']
-- let g:vista_sidebar_width = 40o
-- let g:vista#renderer#enable_icon = 1
-- let g:vista_echo_cursor_strategy = 'floating_win'
-- let g:vista_ignore_kinds = ['variable', 'unknown']
-- let g:vista#renderer#icons = {
-- \   "function": "\uf794",
-- \   "variable": "\uf71b",
-- \  }
end

local setup_completions = function()

-- === Popup Menu Styling ===
-- api.nvim_set_option('pumheight',20)
-- api.nvim_set_option('previewheight',2)
-- increase pum width ( default: 15 )
api.nvim_set_option('pumwidth',30) 
api.nvim_set_option('pumblend',15)
-- === Complete Options ===
-- complete (default: ".,w,b,u,t")
-- we don't have a tag file so we don't want to search for tags
api.nvim_set_option('complete','.,w,b,u')
--  current buffer, window buffers, unloaded buffers, tags
-- completeopt (default: "menu,preview")
api.nvim_set_option('completeopt','menuone,noinsert,noselect')
 -- === Automatic Commands  ===
api.nvim_command('augroup my_completions')
api.nvim_command('autocmd!')
-- also see CompleteDonePre	 CompleteChanged
-- close the preview window when when complete done
api.nvim_command('autocmd CompleteDone * lua if vim.fn.pumvisible() then vim.cmd("pclose") end')
api.nvim_command('augroup END')
-- === Completion Plugin Options ==
-- Customization of chain_completion_list
  local dict = api.nvim_eval("{ " ..
    " 'lua' : { " ..
    "   'default': [ " ..
    "       {'complete_items': ['lsp']}, " ..
    "       {'mode': '<c-p>'}, " ..
    "       {'mode': '<c-n>'}], " ..
    "   'comment': [], " ..
    "   'string': [], " ..
    "   'func': [{'complete_items': ['lsp']}], " ..
    "   'var': [{'complete_items': ['lsp', 'snippet']}], " ..
    "   }, " ..
    " 'default' : { " ..
    "   'default': [ " ..
    "       {'complete_items': ['lsp', 'snippet']}, " ..
    "       {'mode': '<c-p>'}, " ..
    "       {'mode': '<c-n>'}], " ..
    "   'comment': [] " ..
    "   } " ..

    "} ")

  api.nvim_set_var( 'completion_chain_complete_list', dict )
  api.nvim_set_var('completion_max_items','20')
  -- let g:completion_enable_auto_popup = 1
  -- " let g:completion_enable_auto_hover = 0
  -- " let g:completion_enable_auto_signature = 0
  -- " let g:completion_enable_in_comment = 1
  -- " let g:completion_trigger_character = []
  -- === My Completion Commands  ===
  api.nvim_command('command! CompleteSyntaxNameUnderCursor echo synIDattr(synID(line("."), col("."), 1), "name")')
  -- === Mapped Keys ===
  local kopts =  {
    nowait = true,
    noremap = true,
    silent = true
  }
  local mode = 'i'
  -- control-p to enter completion mode
  api.nvim_set_keymap(mode,'<C-p>','<CMD>lua require("completion").triggerCompletion(true)<CR>',kopts)
  api.nvim_set_keymap(mode,'<C-j>','<CMD>lua require("source").prevCompletion()<CR>',kopts)
  api.nvim_set_keymap(mode,'<C-k>','<CMD>lua require("source").nextCompletion()<CR>',kopts)
  -- TABBING
  kopts =  {
    expr = true,
    noremap = true,
    silent = true
  }

api.nvim_set_keymap(mode,'<tab>','pumvisible() ? "<C-n>" : "<tab>"',kopts)
api.nvim_set_keymap(mode,'<S-tab>','pumvisible() ? "<C-p>" : "<S-tab>"',kopts)
  return true
end

local setup_diagnostics = function()
  -- === Globals  ===
  -- Lsp Diagnostic Signs
  api.nvim_set_var('LspDiagnosticsErrorSign','E')
  api.nvim_set_var('LspDiagnosticsWarningSign','W')
  api.nvim_set_var('LspDiagnosticsInformationSign','I')
  api.nvim_set_var('LspDiagnosticsHintSign','H')
  -- plugin  diagnostic-nvim
  -- https://github.com/haorenW1025/diagnostic-nvim
  api.nvim_set_var('diagnostic_enable_virtual_text',1)
  api.nvim_set_var('diagnostic_virtual_text_prefix',' ')
  -- api.nvim_set_var('diagnostic_trimmed_virtual_text','30')
  api.nvim_set_var('space_before_virtual_text',5)
  -- api.nvim_set_var('diagnostic_show_sign',true)
  -- api.nvim_set_var('diagnostic_auto_popup_while_jump',false)
 -- === Commands  ===
  api.nvim_command('command! DiagOpen lua vim.cmd("OpenDiagnostic")')
  api.nvim_command('command! DiagPrev lua vim.cmd("PrevDiagnostic")')
  api.nvim_command('command! DiagNext lua vim.cmd("NextDiagnostic")')
end
--print(vim.inspect(vim.tbl_keys(vim.lsp.buf_get_clients()[1])))
--print(vim.inspect(vim.tbl_keys(vim.lsp.buf_get_clients()[1].callbacks)))
-- print(vim.inspect(vim.lsp.buf_get_clients()[1].id))
--print(vim.inspect(vim.lsp.buf_get_clients()[1].server_capabilities))
-- print(vim.inspect(vim.lsp.buf_get_clients()[1].resolved_capabilities))
--print(vim.inspect(vim.lsp.buf_get_clients()[1].config.settings))
--print(vim.inspect(vim.tbl_keys(vim.lsp.buf_get_clients()[1].config.capabilities)))
-- print(vim.inspect(vim.tbl_keys(vim.lsp.buf_get_clients()[1].rpc)))
-- print(vim.inspect(vim.lsp.buf_get_clients()[1].config.capabilities.workspace))
-- print(vim.inspect(vim.tbl_keys(vim.lsp.buf_get_clients()[1].config.capabilities.textDocument)))
--print(vim.inspect(vim.tbl_keys(vim.lsp.buf_get_clients()[1].config.capabilities)))
--print(vim.inspect(vim.tbl_keys(vim.lsp.buf_get_clients()[1].config)))
--print(vim.inspect(vim.lsp.buf_get_clients()[1].config.filetypes))

M.lsp_buffer_clients = function()
  local aClients = vim.lsp.buf_get_clients()
  local tbl = {}
  for _, mLangServer in ipairs( aClients ) do
    tbl[mLangServer.name] = {}
    local aResolvedCapabilities = vim.tbl_keys(mLangServer.resolved_capabilities)
    local aCanDo = {}
    for _, mCap in ipairs( aResolvedCapabilities ) do
      if type(mLangServer.resolved_capabilities[mCap]) == 'boolean' then
        if (mLangServer.resolved_capabilities[mCap])  == true then
          vim.list_extend( aCanDo, {mCap} )
        end
      end
      -- print(mCap)
      tbl[mLangServer.name]['can_do'] = aCanDo
    end
      tbl[mLangServer.name]['ID'] = mLangServer.id
      -- tbl[mLangServer.name]['ID'] = vim.tbl_keys(mLangServer )
    -- get resolved capabilites
    --
  end
  return tbl
end
-- require("my.fwin").show(vim.split(vim.inspect(M.lsp_buffer_clients()),'\n'))
-- print(vim.inspect(M.lsp_buffer_clients()))

M.lsp_active_clients = function()
  local aClients = vim.lsp.buf_get_clients()
  local tbl = {}
  for _, mLangServer in ipairs( aClients ) do
    tbl[mLangServer.name] = {}
    local aResolvedCapabilities = vim.tbl_keys(mLangServer.resolved_capabilities)
    local aCanDo = {}
    for _, mCap in ipairs( aResolvedCapabilities ) do
      if type(mLangServer.resolved_capabilities[mCap]) == 'boolean' then
        if (mLangServer.resolved_capabilities[mCap])  == true then
          vim.list_extend( aCanDo, {mCap} )
        end
      end
      -- print(mCap)
      tbl[mLangServer.name]['can_do'] = aCanDo
    end
      tbl[mLangServer.name]['ID'] = mLangServer.id
      -- tbl[mLangServer.name]['ID'] = vim.tbl_keys(mLangServer )
    -- get resolved capabilites
    --
  end
  return tbl
end

-- print(vim.inspect(M.lsp_active_clients()))

M.lsp_server_ready = function()
 return vim.lsp.buf.server_ready()
 -- api.nvim_command('edit')
end
-- print(vim.inspect(M.lsp_server_ready()))

M.lsp_stop_all_clients = function()
 vim.lsp.stop_all_clients()
 api.nvim_command('edit')
end


M.setup = function()
  local nvim_lsp    = require('nvim_lsp')
  --@see https://neovim.io/doc/user/lsp.html
  -- Lsp Highlight TODO
  --setup_diagnostics()
  --setup_completions()
  -- setup_vista()
  -- === My LSP Commands  ===
  api.nvim_command('command! LspBufClients lua print(vim.inspect(vim.lsp.buf_get_clients()))')
  api.nvim_command('command! LspShowCallbacks lua require("my.fwin").show(vim.tbl_keys(vim.lsp.callbacks))')

  local tLangServers = {
    'bashls',
    'vimls',
    'jsonls',
    'jsonls',
    'tsserver',
    'dockerls',
    'cssls',
    'html',
  }
  for _, sLangServer in ipairs(tLangServers) do
    nvim_lsp[sLangServer].setup{ on_attach = attach }
  end

  -- nvim_lsp[ 'sumneko_lua'].setup{
  --   on_attach = attach;
  --   log_level = vim.lsp.protocol.MessageType.Error;
  --   settings = {
  --     Lua = {
  --       completion = {
  --         keywordSnippet = "Disable";
  --       };
  --       runtime = {
  --         version = "LuaJIT";
  --       };
  --     };
  --   };
  -- }

   nvim_lsp.sumneko_lua.setup{on_attach=require'completion'.on_attach}
   api.nvim_command('autocmd Filetype lua setlocal omnifunc=v:lua.vim.lsp.omnifunc')


  -- nvim_lsp['erlang_ls'].setup{
  --   on_attach = attach;
  --   log_level = vim.lsp.protocol.MessageType.Error;
  --   trace = { server = "off" };
  -- }
  -- === auto commands ===
  -- api.nvim_command('augroup lsp')
  -- api.nvim_command('autocmd!')
  -- local tFileTypes = {
  --   'vim',
  --   'sh',
  --   'css',
  --   'erlang'
  -- }

  -- for _, sFileType in ipairs(tFileTypes) do
  --   local cmd = 'autocmd FileType ' .. sFileType  .. ' setlocal omnifunc=v:lua.vim.lsp.omnifunc'
  --   api.nvim_command(cmd)
  -- end
  -- api.nvim_command('augroup END')

  -- === Mapped Keys ===
  --
  -- TODO per buffer via projections
  local kopts =  {
    nowait = true,
    noremap = true,
    silent = true
  }
 local mode = 'n'
 api.nvim_set_keymap(mode,'gd','<CMD>lua vim.lsp.buf.declaration()<CR>',kopts)
 api.nvim_set_keymap(mode,'gD','<CMD>lua vim.lsp.buf.implementation()<CR>',kopts)
 api.nvim_set_keymap(mode,'c-]','<CMD>lua vim.lsp.buf.definition()<CR>',kopts)
 api.nvim_set_keymap(mode,'K','<CMD>lua vim.lsp.buf.hover()<CR>',kopts)
 --TODO
 --@see https://gitlab.com/CraftedCart/dotfiles/-/blob/master/.config/nvim/lua/l/lsp/init.lua
-- nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
-- nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
-- nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
-- nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
-- nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
-- nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
--  return true
end

return M
