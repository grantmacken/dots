local M = {}
M.version = 'v0.0.1'
--[[
usage:
require('my.autocmds')({
 startup = {
    {'TextYankPost', '*', "silent!", ":lua require('vim.highlight').on_yank()" };
  };
})
]]--
    -- {'BufEnter', '*', [[:lua require('ft.filetypes')()]] };
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

 local function set( tbl )
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

M.set = set
return M.set

