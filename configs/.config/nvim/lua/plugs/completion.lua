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
--
local default_complete_list = {
  default = {
    default = {
      {complete_items = {'lsp'}},
      {complete_items = {'buffers'}},
      {mode = '<c-p>'},
      {mode = '<c-n>'}
    },
    string = {{complete_items = {'path'}}
    },
    comment = {}
  }
}
--
local tLabels = {
  Buffers = ' [buffers]',
  Class =     ' [class]',
  Enum =      ' [enum]',
  Field =     'F[field]',
  Folder =    ' [folder]',
  Function =  ' [function]',
  Interface = ' [interface]',
  Keyword  =  ' [key]',
  Method =    ' [method]',
  Module =    ' [module]',
  Operator =  ' [operator]',
  Reference = ' [refrence]',
  Snippet =   ' [snippet]',
  Text =      'ﮜ [text]',
  Variable =  ' [variable]'
}

local init = function()
  local cmd = vim.api.nvim_command
  cmd [[packadd! completion-nvim ]]
  cmd [[packadd! vim-vsnip]]
  cmd [[packadd! vim-vsnip-integ]]
  -- cmd [[command! CompleteSyntaxNameUnderCursor echo synIDattr(synID(line('.'), col('.'), 1), 'name')]]
-- Use tab for trigger completion with characters ahead and navigate
-- Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin
  cmd [[
function! CheckBackSpace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
]]
  cmd [[inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : CheckBackSpace() ? "\<Tab>" : completion#trigger_completion()]]
  cmd [[inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"]]
  require('my.globals').set({
   completion_auto_change_source = 1, --Change the completion source automatically if no completion availabe
   completion_customize_lsp_label = tLabels,
   completion_enable_auto_hover = 0,
   completion_enable_auto_signature = 0,
   completion_enable_snippet = 'vim-vsnip',
   completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'},
   completion_max_items = 30,
   completion_trigger_keyword_length = 3,
   completion_trigger_on_delete = 1,
   completion_chain_complete_list = default_complete_list
 })

  require('my.options').setGlobalOptions({
    pumwidth    = 30;
    pumblend    = 15;
    shortmess   = vim.o.shortmess .. 'c';
    completeopt = 'menuone,noinsert,noselect';
    updatetime = 100;
    -- TODO try whichkey 500
    -- default updatetime 4000ms is not good for async update
  })
  -- setMappings()
end
    -- complete (default: ".,w,b,u,t")
    -- we don't have a tag file so we don't want to search for tags
    -- complete    = '.,w,b,u';

M.init = init

return M
