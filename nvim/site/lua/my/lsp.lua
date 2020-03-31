M = {}

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

local api = vim.api
local nvim_lsp    = require('nvim_lsp')

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
-- change seoul256 default colors

-- api.nvim_set_option('pumheight',20)
-- api.nvim_set_option('previewheight',2)
-- increase pum width ( default 15 )
api.nvim_set_option('pumwidth',30) 
api.nvim_set_option('pumblend',15)


api.nvim_command('augroup my_completions')
api.nvim_command('autocmd!')
-- also see CompleteDonePre	 CompleteChanged
-- close the preview window when when complete done
api.nvim_command('autocmd CompleteDone * lua if vim.fn.pumvisible() then vim.cmd("pclose") end')
api.nvim_command('augroup END')
-- === Complete Options ===
api.nvim_set_option('completeopt','menuone,noinsert,noselect')
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



M.init = function()
  setup_completions()

  local tLangServers = {
    'bashls',
    'vimls',
    'sumneko_lua'
  }
  for i, sLangServer in ipairs(tLangServers) do
    nvim_lsp[sLangServer].setup{ attach }
  end

  local tFileTypes = {
    'lua',
    'vim',
    'sh'
  }

  -- === commands ===
   api.nvim_command('command! LspBufClients lua print(vim.inspect(vim.lsp.buf_get_clients()))')

  -- === auto commands ===
  api.nvim_command('augroup lsp')
  api.nvim_command('autocmd!')
  for i, sFileType in ipairs(tFileTypes) do
    local cmd = 'autocmd FileType ' .. sFileType  .. ' setl omnifunc=v:lua.vim.lsp.omnifunc'
    api.nvim_command(cmd)
  end

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

-- " https://neovim.io/doc/user/lsp.html
-- " https://github.com/neoclide/coc.nvim
-- " https://github.com/haorenW1025/completion-nvim
-- ""  Popup Menu Styling
-- "  ------------------


-- " Complete Options
-- " ----------------
-- " :h complete
-- "  (default: ".,w,b,u,t")
-- "  current buffer, window buffers, unloaded buffers, tags
-- " below are async defualt
-- " set completeopt+=noinsert       " auto select feature like neocomplete
-- " set completeopt+=menuone
-- " set completeopt+=noselect

-- " set completeopt-=longest
-- " set completeopt-=menu
-- " set completeopt-=preview
-- " function! s:check_back_space() abort
-- "   let col = col('.') - 1
-- "   return !col || getline('.')[col - 1]  =~ '\s'
-- " endfunction
--   " Use LSP omni-completion in Python files.
-- " Use <Tab> and <S-Tab> to navigate through popup menu
-- inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
-- inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
-- inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
-- " Auto close popup menu when finish completion
-- autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

-- " Set completeopt to have a better completion experience
-- set completeopt=menuone,noinsert,noselect

-- " https://github.com/haorenW1025/completion-nvim/tree
-- " MAP: use <tab> for trigger completion and navigate to next complete item
-- function! s:check_back_space() abort
--     let col = col('.') - 1
--     return !col || getline('.')[col - 1]  =~ '\s'
-- endfunction

-- inoremap <silent><expr> <TAB>
--   \ pumvisible() ? "\<C-n>" :
--   \ <SID>check_back_space() ? "\<TAB>" :
--   \ completion#trigger_completion()
-- "map <c-p> to manually trigger completion
-- inoremap <silent><expr> <c-p> completion#trigger_completion()

-- let g:completion_enable_auto_popup = 1
-- " let g:completion_enable_auto_hover = 0
-- " let g:completion_enable_auto_signature = 0
-- " let g:completion_enable_in_comment = 1
-- " let g:completion_trigger_character = []
-- "
-- " augroup CompleteionTriggerCharacter
-- "     autocmdo 
-- "     autocmd BufEnter * let g:completion_trigger_character = ['.']
-- "     autocmd BufEnter *.c,*.cpp let g:completion_trigger_character = ['.', '::']
-- " augroup end

-- let g:completion_chain_complete_list = [
--     \{'ins_complete': v:false, 'complete_items': ['lsp', 'snippet']},
--     \{'ins_complete': v:true,  'mode': '<c-p>'},
--     \{'ins_complete': v:true,  'mode': '<c-n>'}
-- \]

-- " let g:completion_auto_change_source = 1
-- " let g:completion_confirm_key = "\<C-y>"
-- " let g:completion_enable_auto_hover = 0
-- " 


-- imap <c-j> <cmd>lua require'source'.prevCompletion()<CR> "use <c-j> to switch to previous completion
-- imap <c-k> <cmd>lua require'source'.nextCompletion()<CR> "use <c-k> to switch to next completion



return M
