--- GLOBALS
---
vim.g.mapleader = vim.keycode("<space>")      -- Set leader key to space
vim.g.maplocalleader = vim.keycode("<space>") -- Set local leader key to space
vim.g.projects_dir = vim.fn.expand("~") .. "/Projects"
vim.g.sessions_dir = vim.fn.expand("~") .. "/.config/nvim/sessions"
vim.g.inlay_hints = false
--[[
INITIAL UI SETUP
 - colorscheme
 - icons
 - notify
--]]

local setup = require('setup')
-- nvim pack site startup dir
setup.icons()
setup.notify()
setup.statusline()
-- nvim pack site opt dir 
setup.colorscheme()
setup.oil()
