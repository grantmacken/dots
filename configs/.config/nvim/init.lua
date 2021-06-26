--- vim:sw=2 fdm=marker
--- {{{ [[ local functions ]]
local fn = vim.fn
local exec = vim.api.nvim_exec
local cmd = vim.cmd
local km =   vim.api.nvim_set_keymap
local vars = require('my.globals').set_vars
local options = require('my.globals').set_options
local global_options = require('my.globals').set_global_options
-- }}}
-- {{{ - [[ disable builtin plugins ]]
vars({
  loaded_gzip         = 1;
  loaded_tar          = 1;
  loaded_tarPlugin    = 1;
  loaded_zipPlugin    = 1;
  loaded_2html_plugin = 1;
  loaded_netrw        = 1;
  loaded_netrwPlugin  = 1;
  loaded_matchit      = 1;
  loaded_matchparen   = 1;
  loaded_spec         = 1;
})
-- }}}
-- {{{ - [[ create globally scoped functions ]]
tab_complete =  require('my.globals').tab_complete
s_tab_complete = require('my.globals').s_tab_complete
-- }}}
-- {{{ - [[ options - with global scope and set default colorscheme ]]
global_options({
  guifont     = 'BlexMono Nerd Font';
  encoding = "UTF-8";
  termguicolors = true;
  hidden = true; -- I think this is default
  showtabline = 1;
  updatetime = 300;
  showmatch = true;
  laststatus = 2;
  wildignore = { ".git", "*/node_modules/*"};
  ignorecase = true;
  smartcase = true;
  clipboard = "unnamed";
})




--- }}}
--- {{{ [[ options - file management ]]
options({ -- file management
  autoread = true;
  backup = false;       -- nope
  writebackup = false;  -- nope
  swapfile = false;     -- nope
  undofile    = true;  -- ok use undo
  undolevels  = 5000;    --  with lots of undolevels
  undoreload  = 10000;     -- and reloads
})
--- }}}
--- {{{ [[ options - chrome ]]
options({ 
  number = true;
  signcolumn = 'number'; -- Display signs in the number column
  showmode = false;
  pumblend = 10;
  -- splits
  splitbelow = true;
  splitright = true;
  shortmess  = vim.o.shortmess .. 'cI'; -- No startup screen, no ins-completion-menu messages
})
--- }}}
--- {{{ [[ options - editing ]]
options({
  mouse = 'nv';
  cursorline = true;
  wrap = false;
  expandtab = true;     -- Insert 2 spaces for a tab
  tabstop = 2;          -- Change the number of space characters inserted for indentation
  shiftwidth = 2;       -- Converts tabs to spaces
  --  search behaviour
  incsearch   = true;
  inccommand  = 'split'; -- default is nosplit
  updatetime  = 100;
  list = true;
  linebreak = true;
  breakindent = true;
})
--- }}}
--- {{{ [[ options - external programs ]]
options({ -- can be overidden with buffer-local options
  grepformat  = "%f:%l:%c:%m";
  grepprg     = 'rg --hidden --vimgrep --smart-case --';
  -- formatprg = 'prettier --stdin-filepath=%'
})
--- }}}
--{{{ - [[ initial key bind mappings ]]
--- {{{ space as leader key
km('', '<Space>', '<Nop>', { noremap = true, silent=true})
vars({
  mapleader = " ";
  maplocalleader = " ";
})
--}}}
km('', 'Y', 'y$', {}) -- consistency.
km('', 'Q', '', {})   -- nope - use gQ
-- }}}
--- {{{ [[ load packer ]]
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end
--}}}
-- {{{ - [[ commands ]]
-- Commands
-- cmd([[colorscheme everforest]])
cmd([[colorscheme gruvbox-material]])
cmd([[command! PackerInstall packadd packer.nvim | lua require('plugins').install()]])
cmd([[command! PackerUpdate packadd packer.nvim | lua require('plugins').update()]])
cmd([[command! PackerSync packadd packer.nvim | lua require('plugins').sync()]])
cmd([[command! PackerClean packadd packer.nvim | lua require('plugins').clean()]])
cmd([[command! PackerCompile packadd packer.nvim | lua require('plugins').compile()]])
-- use vim.lsp.buf.formatting()
cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
-- LspLog: take a quick peek at the latest LSP log messages. Useful for debugging
-- LspStop: stop all active clients
-- Redirect: show the results of an ex command in a buffer rather than the built-in pager
exec([[
command! LspLog execute '<mods> pedit +$' v:lua.vim.lsp.get_log_path()
command! LspStop lua vim.lsp.stop_client(vim.lsp.get_active_clients())
command! -nargs=* -complete=command Redirect <mods> new | setl nonu nolist noswf bh=wipe bt=nofile | call append(0, split(execute(<q-args>), "\n"))
]], false)

--}}}
-- {{{ - [[ key bind mappings
-- Window navigation
km('n', '<M-j>', '<C-w>j', { silent = true })
km('n', '<M-k>', '<C-w>k', { silent = true })
km('n', '<M-h>', '<C-w>h', { silent = true })
km('n', '<M-l>', '<C-w>l', { silent = true })

-- Indent selected lines
km('v', '<', '<gv', { noremap = true, silent = true })
km('v', '>', '>gv', { noremap = true, silent = true })
--km('n', '-', [[<Cmd>execute 'e ' .. expand('%:p:h')<CR>]],{ noremap = true })
km('n', '-', [[<Cmd>lua require('lir.float').toggle()<CR>]],{ noremap = true,silent = true })
--[[ km("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
km("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
km("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
km("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
km("i", "<C-Space>", "compe#confirm()", {expr = true})
km("i", "<C-e>", "compe#close('<C-e>')", {expr = true})

km("i", "<C-f>", "compe#scroll({ 'delta': +4 }", {expr = true})
km("i", "<C-d>", "compe#scroll({ 'delta': -4 }", {expr = true}) ]]
--vim.api.nvim_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', {noremap = true,silent = true})
--vim.api.nvim_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', {noremap = true,silent = true})
--vim.api.nvim_set_keymap('n', '<leader>wl', '<cmd><CR>', {noremap = true,silent = true})
-- use which keys
-- remap.keys()
--}}}
-- {{{ - [[ auto commands ]]
local augroups = require('my.globals').create_augroups
augroups({
    ['lir-settings'] = {
      {'Filetype', 'lir lua require("my.lir").settings()'}
    };
    Lint = {
      {"BufWritePost", [[<buffer> lua require('lint').try_lint()]]};
    };
    Lightbulb = {
      {"CursorHold,CursorHoldI", [[* silent! lua require'nvim-lightbulb'.update_lightbulb()]]};
    };
    Yank = {
      {"TextYankPost", [[* silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=400})]]};
    };
    Terminal = {
      {"TermOpen", [[* tnoremap <buffer> <Esc> <c-\><c-n>]]};
      {"TermOpen", [[* set nonu]]};
    };
})
 -- }}}
