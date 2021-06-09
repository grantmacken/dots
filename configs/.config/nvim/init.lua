require('my.settings')
vim.g.mapleader = ' '

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end
vim.cmd [[packadd packer.nvim]]
local ok, packer = pcall(require, "packer")
if not ok then
return print( 'Err: failed to load packer' )
end
packer.startup( require('my.packer').plugins )

-- KEY BIND MAPPINGS
local remap = require( 'my.remaps' )

-- greate global funcs
tab_complete = remap.tab_complete
s_tab_complete = remap.s_tab_complete
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#confirm()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", {expr = true})

vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 }", {expr = true})
vim.api.nvim_set_keymap("i", "<C-d>", "compe#scroll({ 'delta': -4 }", {expr = true})
--vim.api.nvim_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', {noremap = true,silent = true})
--vim.api.nvim_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', {noremap = true,silent = true})
--vim.api.nvim_set_keymap('n', '<leader>wl', '<cmd><CR>', {noremap = true,silent = true})
-- use which keys
remap.keys()


require('my.autocmds')({
    lint = {
      {"BufWritePost", [[<buffer> lua require('lint').try_lint()]]};
    };
    lightbulb = {
      {"CursorHold,CursorHoldI", [[* silent! lua require'nvim-lightbulb'.update_lightbulb()]]};
    };
    yank = {
      {"TextYankPost", [[* silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=400})]]};
    };
})
