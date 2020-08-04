
local M = {}
M.version = 'v0.0.1'

local gDoNotLoad = {
  loaded_2html_plugin = 1,
  loaded_getscriptPlugin = 1,
  loaded_gzip = 1,
  loaded_html_plugin = 1,
  loaded_logiPat = 1,
  loaded_man = 1,
  loaded_matchit = 1,
  loaded_matchparen = 1,
  loaded_netrwPlugin = 1,
  loaded_python_provider = 1,
  loaded_rrhelper = 1,
  loaded_tarPlugin = 1,
  loaded_tutor_mode_plugin = 1,
  loaded_vimballPlugin = 1,
  loaded_zipPlugin = 1,
  nvim_lsp = 1 -- don't load all server configs at startup

}

-- local setFloatermVars = {
--  floaterm_wintype = 'floating',
--  floaterm_rootmarkers = {
--    '.projections',
--    'Makefile',
--    '.git' },
--  floaterm_gitcommit = 'floaterm'
-- }
 -- vim.g.floaterm_position = 'center' -- default
 -- vim.g.floaterm_height = '0.6' -- default
 -- vim.g.floaterm_width = '0.6' -- default
 -- vim.g.floaterm_open_command = 'edit' -- default
 -- open gitcommit file in the floaterm window;
 -- vim.g:floaterm_autoclose = 1 -- default



local main = {
  python3_host_prog = '/usr/bin/python3',
  mapleader = ' ',
  maplocalleader = ',',
  workspace = {}
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
