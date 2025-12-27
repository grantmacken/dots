--- Snapshot tests for show plugin user commands
--- @see dot-config/nvim/plugin/15_show.lua
--- @see dot-config/nvim/lua/show/init.lua
---
--- These tests verify UI output using screenshots
--- First run: Creates screenshot files (will fail with notes)
--- Subsequent runs: Compares output to screenshots (should pass)
---
--- Run with: make snapshot-show
--- Update snapshots: make snapshot-show-update
---
local expect = MiniTest.expect
local child = MiniTest.new_child_neovim()
local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      -- Restart child process with custom 'init.lua' script
      child.restart({ '-u', 'scripts/minimal_init.lua' })
      child.bo.readonly = false
      -- Load tested plugin
      child.lua([[M = require('show')]])
    end,
    -- Stop once all test cases are finished
    post_once = child.stop,
  },
})

-- Define some tests here
return T
