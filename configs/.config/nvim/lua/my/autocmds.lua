local M = {}
M.version = 'v0.0.1'
local tAutocmds = {
  startup = {
    {'FileType', 'dirvish', 'noremap <buffer> n', ':e %'};
    {'FileType', 'lua', 'setlocal', 'omnifunc=v:lua.vim.lsp.omnifunc'};
    -- {'BufEnter,BufNew', '*', [[:lua require('ft.init')()]] };
    {'BufEnter,BufNew', '*.lua', [[:lua require('ft.lua').setBufferOptions()]] };
  };
  TextYankHighlight = {
    {'TextYankPost', '*', "silent!", [[:lua require('vim.highlight').on_yank()]] };
  }
}

--[[
BufRead
BufEnter After entering a buffer.  Useful for setting
	options for a file type.  Also executed when
	starting to edit a buffer,
	after
	BufAdd BufReadPost
--]]
 -- {"BufNew", "*", [[:lua require('ft.init') ]] };
 -- {"BufEnter", '*', [[:lua require('ft.init') ]] };
 --   {'BufReadPost', '*', [[lua require('ft.init') ]] }
--[[
h: autocommand events
au[tocmd] [group] {event} {pat} [++once] [++nested] {cmd}
 --]]

 local function setAugroups( tbl )
   local cmd = vim.api.nvim_command
   for sGroup, tList in pairs( tbl ) do
     cmd('augroup ' .. sGroup )
     cmd('autocmd!')
     for _, tItem in ipairs( tList ) do
       local command = table.concat(vim.tbl_flatten{'autocmd', tItem }, ' ')
       -- print(vim.inspect(command))
       cmd(command)
     end
     cmd('augroup END')
   end
   --  print(vim.inspect(command))
 end

local set = function()
  print(' set autocommands ')
  setAugroups( tAutocmds )
end

M.set = set
-- return M.set()
return M
