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

" require{'nvim_lsp'}.sumneko_lua.setup{
"     on_attach=require('diagnostic').on_attach;
"     on_attach=require('diagnostic').on_attach;

"     log_level = vim.lsp.protocol.MessageType.Error;
"     settings = {
"         Lua = {
"             completion = {
"                 keywordSnippet = "Disable";
"             };
"             runtime = {
"                 version = "LuaJIT";
"             };
"         };
"     };
" }

" autocmd BufReadPost * lua require('langsrvr.erlang').check_start_erlang_lsp()
--]]

local attach = function()
  require('diagnostic').diagnostic.on_attach()
  require('diagnostic').completion.on_attach()
end

M.completion_done = function()
  if ( vim.fn.pumvisible() ) then 
    vim.api.nvim_command("pclose") 
  end
end

local setup_completions = function()
-- === Popup Menu Styling ===
-- api.nvim_set_option('pumheight',20)
-- api.nvim_set_option('previewheight',2)
-- increase pum width ( default: 15 )
api.nvim_set_option('pumwidth',30) 
api.nvim_set_option('pumblend',15)
-- complete (default: ".,w,b,u,t")
-- we don't have a tag file so we don't want to search for tags
api.nvim_set_option('complete','.,w,b,u')
--  current buffer, window buffers, unloaded buffers, tags
-- completeopt (default: "menu,preview")
api.nvim_set_option('completeopt','menuone,noinsert,noselect')
api.nvim_command('augroup my_completions')
api.nvim_command('autocmd!')
-- also see CompleteDonePre	 CompleteChanged
-- close the preview window when when complete done
api.nvim_command('autocmd CompleteDone * lua if vim.fn.pumvisible() then vim.cmd("pclose") end')
api.nvim_command('augroup END')
-- === Complete Options ===
-- " set completeopt+=noinsert       " auto select feature like neocomplete
-- " set completeopt+=menuone
-- " set completeopt+=noselect

-- === map keys ===
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
-- api.nvim_set_keymap(mode,'<S-Tab>','<C-p>',kopts)

-- === Completion Plugin Options ==
-- let g:completion_chain_complete_list = [
--     \{'ins_complete': v:false, 'complete_items': ['lsp', 'snippet']},
--     \{'ins_complete': v:true,  'mode': '<c-p>'},
--     \{'ins_complete': v:true,  'mode': '<c-n>'}
-- \]

-- let g:completion_enable_auto_popup = 1
-- " let g:completion_enable_auto_hover = 0
-- " let g:completion_enable_auto_signature = 0
-- " let g:completion_enable_in_comment = 1
-- " let g:completion_trigger_character = []
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

M.setup = function()
  local nvim_lsp    = require('nvim_lsp')
  --@see https://neovim.io/doc/user/lsp.html
  -- Lsp Highlight TODO
  setup_diagnostics()
  setup_completions()
  -- === My LSP Commands  ===
  api.nvim_command('command! LspBufClients lua print(vim.inspect(vim.lsp.buf_get_clients()))')
  api.nvim_command('command! LspShowCallacks lua require("my.fwin").show(vim.tbl_keys(vim.lsp.callbacks))')

  local tLangServers = {
    'bashls',
    'vimls',
    'sumneko_lua'
  }
  for _, sLangServer in ipairs(tLangServers) do
    nvim_lsp[sLangServer].setup{ attach }
  end

  local tFileTypes = {
    'lua',
    'vim',
    'sh'
  }

  -- === auto commands ===
  api.nvim_command('augroup lsp')
  api.nvim_command('autocmd!')
  for _, sFileType in ipairs(tFileTypes) do
    local cmd = 'autocmd FileType ' .. sFileType  .. ' setl omnifunc=v:lua.vim.lsp.omnifunc'
    api.nvim_command(cmd)
  end
  api.nvim_command('augroup END')

  -- === map keys ===
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
  return true
end

return M
