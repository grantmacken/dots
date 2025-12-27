--[[
In my universe, git contolled projects
- have their own nvim configuration
- each project is opened in its own tabpage
- each project tabpage can define its its own tabpage window layout
- each project tabpage has its own terminal buffer for running project related commands
- each project tabpage can define its own set of plugins and plugin settings
- each project tabpage can define its own keymaps and commands
- each project tabpage can define its own autocommands
- each project tabpage can define its own fileviews for the project files
- each project tabpage can define its own makeprg and errformat for building the project
- each project tabpage can define its own arglist for the project files:
- each project tabpage can define alternarive files for the project fil:es
--]]
--
local cwd = vim.fn.getcwd()
vim.t.working_dir = cwd
vim.t.project_name = vim.fn.fnamemodify(cwd, ":t") -- Determine project name from cwd
---@see file gf dot-config/nvim/lua/projects/init.lua

---@see gf dot-config/nvim/lua/arglists/init.lua
require('arglists').setup()

--[[ Test Setup
 - set the test patterns for the project specific tests
 @see dot-config/nvim/lua/alt/init.lua
--]]
vim.t.alt_pairs = {
  tests = { 'dot-config/nvim/lua/*/init.lua', 'dot-config/nvim/tests/*_spec.lua' },
}

--[[ Window Layout Setup
 - set the window layout for the project specific layout
--]]

--
local setup_window_layout = function()
  local tabID = vim.api.nvim_get_current_tabpage()
  -- close all existing windows except the first one
  vim.cmd('only')
  -- open first arg in the arglist in the first window
  local first_arg = vim.fn.argv(0)
  vim.cmd('edit ' .. first_arg)
  --open the show window'
  local argCount = function()
    local int = vim.fn.argc()
    return string.format("%d", int)
  end
  -- local bufName  = 'buf_scratch'
  -- local show     = require('show')
  -- show.window(show.buffer(bufName)) -- open show window with scratch buffer
  -- -- sets vim.t['winID'] and vim.t['scratch'] for the tabpage
  -- local tbl = {
  --   "Project specific settings loaded.",
  --   "Project name:      " .. vim.t['project_name'],
  --   "Working diriectory: " .. vim.t['working_dir'],
  --   "Tabpage ID:         " .. tabID,
  --   "Show window:        " .. vim.t['winID'],
  --   "Scratch buffer:     " .. vim.t[bufName],
  --   "Arglist Count:      " .. argCount(),
  -- }
  -- show.append_lines(tbl)
end


vim.defer_fn(setup_window_layout, 100)
-- open a horizontal split in the left window
