local M = {}
M.version = 'v0.0.1'

local cmds = {
  PackerClean = "packadd packer.nvim | lua require('plugins').clean()";
  PackerCompile = "packadd packer.nvim | lua require('plugins').compile('~/.config/nvim/plugin/packer_load.vim')";
  PackerInstall = "packadd packer.nvim | lua require('plugins').install()";
  PackerSync = "packadd packer.nvim | lua require('plugins').sync()";
  PackerUpdate = "packadd packer.nvim | lua require('plugins').update()";
}

local setCmds = function()
local cmd = vim.api.nvim_command
 local opts = {
  cmds
  }
  for i, v in ipairs( opts ) do
    for name, value in pairs(v) do
      cmd( "command! " .. name .. " " ..  value )
    end
  end
end

M.setCmds = setCmds

--[[ test
 - uncomment setCmds
 - comment out return
 - luafile %
--]]
--setCmds()
return M
