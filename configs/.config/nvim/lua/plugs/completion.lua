local M = {}
--[[
--Set completeopt to have a better completion experience
Avoid showing message extra message when using completion
set shortmess+=c
set shortmess?
Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
set completeopt?
]]-- 

  --completion_trigger_keyword_length = 3,
  -- completion_chain_complete_list = {
  --   default = {
  --     { complete_items = { 'snippet' } },
  --     { mode = '<c-p>'},
  --     { mode = '<c-n>'}
  --   };
    -- lua =  {
    --   { complete_items = { 'ts', 'buffers' } },
    -- };
    -- typescript =  {
    --   { complete_items = { 'lsp' } },
    --   { complete_items = { 'ts', 'buffers' } }
    -- };
    -- javascript =  {
    --   { complete_items = { 'lsp' } },
    -- };
  --}
--}
local chain_complete_list = {
  default = {
    default = {
      {complete_items = {'lsp', 'snippet'}},
      {complete_items = {'path'}, triggered_only = {'/'}},
    },
    string = {
      {complete_items = {'path'}, triggered_only = {'/'}},
    },
    comment = {},
  }
}

local setGlobals = function()
  require('my.globals').set({
   completion_enable_snippet = 'vim-vsnip',
   completion_enable_auto_hover = 0,
   completion_enable_auto_signature = 0,
   completion_matching_strategy_list = {'exact', 'substring'},
   completion_trigger_keyword_length = 3
 })
end

local setCommands = function() 
  local cmd = vim.api.nvim_command
  cmd [[packadd! completion-nvim ]]
  cmd [[packadd! vim-vsnip]]
  cmd [[packadd! vim-vsnip-integ]]
  cmd [[command! CompleteSyntaxNameUnderCursor echo synIDattr(synID(line('.'), col('.'), 1), 'name')]]
--@ https://github.com/steelsojka/dotfiles2/blob/master/.vim/lua/steelvim/init/global_mappings.lua
-- Use tab for trigger completion with characters ahead and navigate
-- Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin
  cmd [[
function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
]]
  cmd [[inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : CheckBackSpace() ? "\<TAB>" : completion#trigger_completion()]]
  cmd [[inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"]]
end
-- {  '{{mode}}',  '{{lhs}}', '{{rhs}}' }}
--
--local setMappings = function()
--  require('my.mappings').set(
--  {
   -- does not work 
   --{'i', '<Tab>', [[pumvisible() ? "<C-n>" : "<tab>"]] },
   --{'i', '<S-Tab>', [[pumvisible() ? "<C-p>" : "<S-Tab>"]] },
 -- }
 -- )
-- end


local init = function()
  setCommands()
  setGlobals()
  -- setMappings()
end

M.init = init

return M.init()
