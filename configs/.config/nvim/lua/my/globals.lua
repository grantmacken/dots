
local M = {}
M.version = 'v0.0.1'

local gDoNotLoad = {
  loaded_2html_plugin = 1,
  loaded_2html_plugin = 1,
  loaded_getscript = 1,
  loaded_getscriptPlugin = 1,
  loaded_getscriptPlugin = 1,
  loaded_gzip = 1,
  loaded_gzipPlugin = 1,
  loaded_logiPat = 1,
  loaded_matchit = 1,
  loaded_matchparen = 1,
  loaded_netrw = 1,
  loaded_netrwFileHandlers  = 1,
  loaded_netrwPlugin  = 1,
  loaded_netrwSettings  = 1,
  loaded_python_provider = 1,
  loaded_rrhelper = 1,
  loaded_tar  = 1,
  loaded_tarPlugin = 1,
  loaded_tutor_mode_plugin = 1,
  loaded_vimball = 1,
  loaded_vimballPlugin = 1,
  loaded_zipPlugin = 1,
  loaded_zip = 1,
}


local main = {
  python3_host_prog = '/usr/bin/python3',
  mapleader = ' ',
  maplocalleader = ',',
}

local whichKey = {
  which_key_sep = '→',
  which_key_use_floating_win = 1
}

local set = function( tbl )
  for key,value in pairs( tbl ) do
    vim.g[key] = value
  end
end

local doNotLoad = function()
  set( gDoNotLoad )
end



local setGlobals = function()
  set( main )
  set( whichKey )
end

M.set = set
M.doNotLoad = doNotLoad
M.gVars = setGlobals

return M
