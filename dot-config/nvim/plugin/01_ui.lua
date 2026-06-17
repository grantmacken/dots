--- GLOBALS
---
vim.g.mapleader = vim.keycode("<space>")      -- Set leader key to space
vim.g.maplocalleader = vim.keycode("<space>") -- Set local leader key to space
vim.g.projects_dir = vim.fn.expand("~") .. "/Projects"
vim.g.sessions_dir = vim.fn.expand("~") .. "/.config/nvim/sessions"
vim.g.inlay_hints = false

-- ui2: native Neovim 0.12+ message/cmdline redesign
-- provides pager as a buffer+window.
-- default options
require("vim._core.ui2").enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = {        -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = "cmd",
    cmd = {           -- Options related to messages in the cmdline window.
      height = 0.5,   -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = {        -- Options related to dialog window.
      height = 0.5,   -- Maximum height.
    },
    msg = {           -- Options related to msg window.
      height = 0.5,   -- Maximum height.
      timeout = 4000, -- Time a message is visible in the message window.
    },
    pager = {         -- Options related to message window.
      height = 1,     -- Maximum height.
    },
  },
})




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
