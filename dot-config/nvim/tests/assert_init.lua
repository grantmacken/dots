--- Minimal init for running mini.test
--- Loads only mini.test and sets up paths for testing

-- Setup package path for local modules
local config_path = vim.fn.getcwd()
package.path = config_path .. '/lua/?.lua;' .. config_path .. '/lua/?/init.lua;' .. package.path

-- Add mini.nvim to runtimepath (it's installed as opt package)
local mini_path = vim.fn.stdpath('data') .. '/site/pack/core/opt/mini.nvim'
vim.opt.runtimepath:append(mini_path)

local MiniTest = require('mini.test')

-- TAP (Test Anything Protocol) reporter for mini.test
local function create_tap_reporter()
  local all_cases = {}
  local reported = {} -- Track which cases we've reported
  
  local write = function(text)
    text = type(text) == 'table' and table.concat(text, '\n') or text
    io.stdout:write(text .. '\n')
    io.stdout:flush()
  end
  
  return {
    start = function(cases)
      all_cases = cases
      write('TAP version 13')
      write('1..' .. #cases)
    end,
    
    update = function(case_num)
      -- Only report each case once (update is called multiple times)
      if reported[case_num] then return end
      
      local case = all_cases[case_num]
      local exec = case.exec
      
      -- Only report when execution exists
      if not exec then return end
      
      reported[case_num] = true
      
      -- Build test description from case.desc table
      local desc = type(case.desc) == 'table' and table.concat(case.desc, ' | ') or tostring(case.desc)
      
      -- Determine pass/fail based on exec.notes
      -- If there are notes, it's a failure; otherwise it's a pass
      local has_errors = exec.notes and #exec.notes > 0
      
      if has_errors then
        write(string.format('not ok %d - %s', case_num, desc))
        
        -- Add diagnostic info for failures
        write('  ---')
        write('  message: |')
        for _, note in ipairs(exec.notes) do
          -- Indent each line of the note
          for line in note:gmatch('[^\n]+') do
            write('    ' .. line)
          end
        end
        write('  ...')
      else
        write(string.format('ok %d - %s', case_num, desc))
      end
    end,
    
    finish = function()
      -- Count results based on exec.notes (failures have notes)
      local n_pass = 0
      local n_fail = 0
      local n_total = #all_cases
      
      for _, case in ipairs(all_cases) do
        if case.exec then
          local has_errors = case.exec.notes and #case.exec.notes > 0
          if has_errors then
            n_fail = n_fail + 1
          else
            n_pass = n_pass + 1
          end
        end
      end
      
      -- Summary
      write(string.format('# tests %d', n_total))
      write(string.format('# pass %d', n_pass))
      write(string.format('# fail %d', n_fail))
      
      -- Exit with appropriate code
      local exit_code = n_fail > 0 and 1 or 0
      vim.cmd(string.format('silent! %scquit', exit_code))
    end,
  }
end

-- Load and setup mini.test (make it global for test files)
_G.MiniTest = require('mini.test')
MiniTest.setup({
  collect = {
    find_files = function()
      -- Find all test_*.lua files in tests directory
      return vim.fn.globpath('tests', 'test_*.lua', false, true)
    end,
  },
  execute = {
    reporter = create_tap_reporter(),
  },
})
