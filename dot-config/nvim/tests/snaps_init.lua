--- Snapshot testing init for mini.test
--- Based on mini.nvim testing approach for UI snapshot tests
--- @see file /var/home/gmack/.local/share/nvim/site/pack/core/start/mini.nvim/tests/

-- Setup package path for local modules
local config_path = vim.fn.getcwd()
package.path = config_path .. '/lua/?.lua;' .. config_path .. '/lua/?/init.lua;' .. package.path

-- Add mini.nvim to runtimepath
local mini_path = vim.fn.stdpath('data') .. '/site/pack/core/start/mini.nvim'
vim.opt.runtimepath:append(mini_path)

-- Load mini.test
_G.MiniTest = require('mini.test')

-- Create helpers similar to mini.nvim's helpers.lua
local Helpers = {}

-- Add extra expectations
Helpers.expect = vim.deepcopy(MiniTest.expect)

Helpers.expect.match = MiniTest.new_expectation(
  'string matching',
  function(str, pattern) return str:find(pattern) ~= nil end,
  function(str, pattern)
    return string.format('Pattern: %s\nObserved string: %s', vim.inspect(pattern), str)
  end
)

-- Monkey-patch MiniTest.new_child_neovim with helpful wrappers
Helpers.new_child_neovim = function()
  local child = MiniTest.new_child_neovim()

  local prevent_hanging = function(method)
    if not child.is_blocked() then return end
    local msg = string.format('Cannot use `child.%s` because child process is blocked.', method)
    error(msg)
  end

  child.setup = function()
    -- Start with absolutely minimal config
    child.restart({ '-u', 'NONE', '--noplugin' })

    -- Disable loading any plugins/after files
    child.o.loadplugins = false

    -- Set up ONLY the lua path, not full rtp
    local cwd = vim.fn.getcwd()
    child.lua(string.format([[package.path = '%s/lua/?.lua;%s/lua/?/init.lua;' .. package.path]], cwd, cwd))

    -- Add mini.nvim to path for mini.test
    child.lua(string.format([[package.path = '%s/lua/?.lua;%s/lua/?/init.lua;' .. package.path]], mini_path, mini_path))

    -- Set reproducible dimensions and options
    child.o.lines = 15
    child.o.columns = 80
    child.o.laststatus = 0 -- No statusline for cleaner screenshots
    child.o.cmdheight = 1
    child.o.showmode = false
    child.bo.readonly = false

    -- Load ONLY the show module in child (not all plugins!)
    child.lua([[require('show')]])

    -- Define ONLY the ShowScratchExample command for testing
    -- Don't source the entire plugin file which loads other stuff
    child.cmd([[
      command! ShowScratchExample lua require('show').buffer('bufScratchExample', 'Example scratch buffer content')
    ]])
  end

  child.set_lines = function(arr, start, finish)
    prevent_hanging('set_lines')
    if type(arr) == 'string' then arr = vim.split(arr, '\n') end
    child.api.nvim_buf_set_lines(0, start or 0, finish or -1, false, arr)
  end

  child.get_lines = function(start, finish)
    prevent_hanging('get_lines')
    return child.api.nvim_buf_get_lines(0, start or 0, finish or -1, false)
  end

  child.set_cursor = function(line, column, win_id)
    prevent_hanging('set_cursor')
    child.api.nvim_win_set_cursor(win_id or 0, { line, column })
  end

  child.get_cursor = function(win_id)
    prevent_hanging('get_cursor')
    return child.api.nvim_win_get_cursor(win_id or 0)
  end

  child.set_size = function(lines, columns)
    prevent_hanging('set_size')
    if type(lines) == 'number' then child.o.lines = lines end
    if type(columns) == 'number' then child.o.columns = columns end
  end

  child.type_keys = function(...)
    prevent_hanging('type_keys')
    local keys = {}
    for _, key in ipairs({ ... }) do
      table.insert(keys, vim.api.nvim_replace_termcodes(key, true, true, true))
    end
    child.api.nvim_feedkeys(table.concat(keys, ''), 'tx', false)
  end

  -- Screenshot helper with same signature as mini.nvim
  child.expect_screenshot = function(opts, path)
    opts = opts or {}
    local screenshot_opts = { redraw = opts.redraw }
    opts.redraw = nil
    MiniTest.expect.reference_screenshot(child.get_screenshot(screenshot_opts), path, opts)
  end

  child.ensure_normal_mode = function()
    local mode = child.api.nvim_get_mode().mode
    if mode ~= 'n' then
      child.cmd('stopinsert')
      child.type_keys('<Esc>')
    end
  end

  return child
end

-- Export helpers globally
_G.helpers = Helpers

-- Setup mini.test - when a specific file is provided via CLI, use that
MiniTest.setup({
  collect = {
    find_files = function()
      -- Check if TEST_FILE env var is set
      local test_file = vim.env.TEST_FILE
      if test_file then
        return { test_file }
      end
      return {}
    end,
  },
})

-- Make global for test files to use
_G.MiniTest = MiniTest

-- Return MiniTest
return MiniTest
