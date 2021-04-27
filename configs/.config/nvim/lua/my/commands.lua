local M = {}
M.version = 'v0.0.1' 
--[[
-- com[mand][!] [{attr}...] {cmd} {rep}
usage:
require('my.commands')({
 -- 'cmdName' key value  can use string
  PackerClean = "packadd packer.nvim | lua require('my/plugins').clean()";
  -- 'cmdName' key value can use tables with explicit 'attr' and 'rep' keys
  -- rep key value can be a string or a table
  Explore = {
	  attr = {'-nargs=?', '-complete=dir' },
	  rep = "Dirvish <args>"  };
  Vexplore = {
	  attr = {'-nargs=?', '-complete=dir' },
	  rep = {'leftabove', 'vsplit', '|', 'silent', 'Dirvish', '<args>'}
  }
]]-- value 

local set = function( tbl )
    for name, value in pairs(tbl) do
      local rep, attr
      if type(value) == 'string' then
	rep = {value}
	attr = {}
      end
      if type(value) == 'table' then
	attr = value['attr']
	rep = value['rep']
      end
      local command = table.concat(vim.tbl_flatten{'command!', attr , name, rep }, ' ')
      vim.api.nvim_command(command)
    end
  end

M.set = set

return M.set
