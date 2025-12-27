local child = MiniTest.new_child_neovim()

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      -- Restart child process with custom 'init.lua' script
      child.restart({ '-u', 'scripts/minimal_init.lua' })
      -- Load tested plugin
      child.lua([[M = require('hello_lines')]])
    end,
    -- Stop once all test cases are finished
    post_once = child.stop,
  },
})

-- Define some tests here

return T
