local M = {}
M.version = 'v0.0.1'

local tWhichKey = {
	-- top
	-- ['w'] = {'<C-W>w'     , 'other-window'};
	-- a is for actions
	['f'] = {
		name = '+file',
		['s'] = { 'update', 'save-file' },
		['d'] = { 'e $MYVIMRC', 'open-init' },
		['o'] = { 'vsp +Dirvish %:p', 'dirvish split' }
          },
	['w'] = {
		name = '+window',
		['w'] = { '<C-W>w', 'other-window' },
		['d'] = { '<C-W>c', 'delete-window' },
		['-'] = { '<C-W>s', 'split-window-below' },
		['|'] = { '<C-W>v', 'split-window-right' }
    }


}


-- local tNormKeys = {
--   ['gD'] = '<cmd>lua vim.lsp.buf.declaration()<CR>',
--   ['gD'] = '<cmd>lua vim.lsp.buf.declaration()<CR>',
--   ['gd'] = '<cmd>lua vim.lsp.buf.definition()<CR>',
--   ['K'] = '<cmd>lua vim.lsp.buf.hover()<CR>',
--   ['gi'] = '<cmd>lua vim.lsp.buf.implementation()<CR>',
--   ['gTD'] = '<cmd>lua vim.lsp.buf.type_definition()<CR>',
--   ['gr'] = '<cmd>lua vim.lsp.buf.references()<CR>',
--   ['gA'] = '<cmd>lua vim.lsp.buf.code_action()<CR>',
--   ['g='] = '<cmd>lua vim.lsp.buf.formatting()<CR>',
--   [']e'] = '<cmd>NextDiagnosticCycle<cr>',
--   ['[e'] = '<cmd>PrevDiagnosticCycle<cr>',
-- }

local tWhichKeyOptions = {
  which_key_sep = '→',
  which_key_use_floating_win = 1
}

local register = function( tbl )
local opts = {noremap = true, silent = true}
local mode = 'n'
local keymap = vim.api.nvim_buf_set_keymap
keymap(0,mode,"<leader>","<Cmd>WhichKey '<Space>'<CR>",opts)
local tWK = {}
local opts = {noremap = true, silent = true}
local mode = 'n'
for ky1,value in pairs( tbl ) do
	tWK[ky1] = { name = value.name  }
	for ky2, item in pairs( value ) do
		if ( type( item ) == 'table' ) then
			tWK[ky1][ky2] = item
			local leaderKeys = '<leader>' ..ky1 .. ky2
			local cmdValue = '<Cmd>' .. item[1] .. '<CR>'
			keymap(0,mode,leaderKeys,cmdValue,opts)
		end
	end
	end
 vim.g.which_key_map = tWK
 vim.fn['which_key#register']('<Space>', 'g:which_key_map')
 -- vim.g.which_key_map = nil
 -- print(vim.inspect(tWK))
 -- print(vim.inspect(vim.api.nvim_buf_get_keymap(0,'n')) ) 
end

M.register = register

return M.register( tWhichKey )
