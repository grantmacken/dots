--[[ markdown
In my Neovim setup, each project is opened in its own tabpage.
This allows me to have project-specific settings, keymaps, and autocommands
that are only active when working within that project.

@see dot-config/nvim/lua/projects/init.lua
@see dot-config/nvim/plugin/02.3_project_autocmds.lua
@see help:tabpage
@see help:VimEnter
@see help:TabEnter
@see help:TabLeave
@see help:TabNewEntered
@see help:TabClosed

## Tabpage specific autocommands

 - TabNewEntered: After BufEnter. When a new tab is opened, load the project specific settings
 - TabClosed: When a tab is closed, clean up tabpage specific variables

## TabNewEntered autocommand
When a new tab is opened, load the project specific settings

--]]
--
--- @see dot-config/nvim/lua/util.lua
--- @see dot-config/nvim/lua/show/init.lua
local util = require('util')
local group = util.augroup('project_tabpage_autocmds')
local au = util.au
au("TabNewEntered", "*",
  function()
    local cwd = vim.fn.getcwd()
    -- vim.notify('Loading project specific settings for new tabpage', vim.log.levels.INFO)
    if vim.fn.filereadable('.nvim.lua') == 1 then
      vim.notify('Loading project specific settings from .nvim.lua for new tabpage: ' .. cwd, vim.log.levels.INFO)
      local ok, err = pcall(dofile, '.nvim.lua')
      if not ok then
        vim.notify('Error loading .nvim.lua for new tabpage: ' .. err, vim.log.levels.ERROR)
      end
    else
      vim.notify('No .nvim.lua file found for new tabpage: ' .. cwd, vim.log.levels.WARN)
      return
    end
    -- create scratch window for tabpage if needed
  end,
  'Load project specific settings on new tab')

au("TabClosed", "*",
  function()
    vim.notify('Cleaning up tabpage specific variables for closed tabpage', vim.log.levels.INFO)
    -- Clean up tabpage specific variables here
    -- e.g., vim.t.my_var = nil
  end,
  'Clean up tabpage specific variables on tab close')
--
