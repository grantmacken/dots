--- Test suite for show module
--- @see dot-config/nvim/lua/show/init.lua

local MiniTest = require('mini.test')
local expect = MiniTest.expect

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      -- Load show module fresh for each test
      package.loaded['show'] = nil
      _G.show = require('show')
    end,
  },
})

-- Version tests
T['version'] = MiniTest.new_set()

T['version']['has version string'] = function()
  expect.equality(type(show.version), 'string')
end

T['version']['matches semantic versioning format'] = function()
  local version = show.version
  local matches = version:match('^%d+%.%d+%.%d+$') ~= nil
  expect.equality(matches, true)
end

T['version']['is version 0.1.0'] = function()
  expect.equality(show.version, '0.1.0')
end

-- Buffer management tests
T['M.buffer()'] = MiniTest.new_set({
  hooks = {
    post_case = function()
      -- Clean up: delete any test buffers created
      local test_vars = {
        'bufScratch',
        'bufShell',
        'bufScratchLogs',
        'bufShellBuild',
        'bufTaskBuild',
        'bufTaskTest',
        'bufTaskLint',
      }
      local tabID = vim.api.nvim_get_current_tabpage()

      for _, var_name in ipairs(test_vars) do
        local ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, tabID, var_name)
        if ok and vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
        pcall(vim.api.nvim_tabpage_del_var, tabID, var_name)
      end
    end,
  },
})

-- Tests for bufScratch
T['M.buffer()']['creates bufScratch when it does not exist'] = function()
  local bufnr, msg = show.buffer('bufScratch')

  expect.equality(type(bufnr), 'number')
  expect.equality(bufnr > 0, true)
  expect.equality(vim.api.nvim_buf_is_valid(bufnr), true)
  expect.equality(type(msg), 'string')
end

T['M.buffer()']['returns existing bufScratch on second call'] = function()
  local bufnr1, msg1 = show.buffer('bufScratch')
  local bufnr2, msg2 = show.buffer('bufScratch')

  expect.equality(bufnr1, bufnr2)
  expect.equality(msg2:match('existing buffer found') ~= nil, true)
end

T['M.buffer()']['stores bufScratch in vim.t variable'] = function()
  local bufnr = show.buffer('bufScratch')
  expect.equality(vim.t.bufScratch, bufnr)
end

T['M.buffer()']['creates unlisted scratch buffer for bufScratch'] = function()
  local bufnr = show.buffer('bufScratch')

  expect.equality(vim.bo[bufnr].buflisted, false)
  expect.equality(#vim.bo[bufnr].buftype > 0, true)
end

-- Tests for bufShell
T['M.buffer()']['creates bufShell when it does not exist'] = function()
  local bufnr, msg = show.buffer('bufShell')

  expect.equality(type(bufnr), 'number')
  expect.equality(bufnr > 0, true)
  expect.equality(vim.api.nvim_buf_is_valid(bufnr), true)
  expect.equality(type(msg), 'string')
end

T['M.buffer()']['returns existing bufShell on second call'] = function()
  local bufnr1, msg1 = show.buffer('bufShell')
  local bufnr2, msg2 = show.buffer('bufShell')

  expect.equality(bufnr1, bufnr2)
  expect.equality(msg2:match('existing buffer found') ~= nil, true)
end

T['M.buffer()']['stores bufShell in vim.t variable'] = function()
  local bufnr = show.buffer('bufShell')
  expect.equality(vim.t.bufShell, bufnr)
end

T['M.buffer()']['creates unlisted scratch buffer for bufShell'] = function()
  local bufnr = show.buffer('bufShell')

  expect.equality(vim.bo[bufnr].buflisted, false)
  expect.equality(#vim.bo[bufnr].buftype > 0, true)
end

-- Tests for bufTask{Name} pattern (with suffix)
T['M.buffer()']['creates bufTaskBuild when it does not exist'] = function()
  local bufnr, msg = show.buffer('bufTaskBuild')

  expect.equality(type(bufnr), 'number')
  expect.equality(bufnr > 0, true)
  expect.equality(vim.api.nvim_buf_is_valid(bufnr), true)
  expect.equality(type(msg), 'string')
end

T['M.buffer()']['returns existing bufTaskBuild on second call'] = function()
  local bufnr1, msg1 = show.buffer('bufTaskBuild')
  local bufnr2, msg2 = show.buffer('bufTaskBuild')

  expect.equality(bufnr1, bufnr2)
  expect.equality(msg2:match('existing buffer found') ~= nil, true)
end

T['M.buffer()']['stores bufTaskBuild in vim.t variable'] = function()
  local bufnr = show.buffer('bufTaskBuild')
  expect.equality(vim.t.bufTaskBuild, bufnr)
end

T['M.buffer()']['creates unlisted scratch buffer for bufTaskBuild'] = function()
  local bufnr = show.buffer('bufTaskBuild')

  expect.equality(vim.bo[bufnr].buflisted, false)
  expect.equality(#vim.bo[bufnr].buftype > 0, true)
end

T['M.buffer()']['handles multiple different bufTask names'] = function()
  local bufnr1 = show.buffer('bufTaskBuild')
  local bufnr2 = show.buffer('bufTaskTest')
  local bufnr3 = show.buffer('bufTaskLint')

  -- All should be different buffers
  expect.no_equality(bufnr1, bufnr2)
  expect.no_equality(bufnr2, bufnr3)
  expect.no_equality(bufnr1, bufnr3)

  -- All should be valid
  expect.equality(vim.api.nvim_buf_is_valid(bufnr1), true)
  expect.equality(vim.api.nvim_buf_is_valid(bufnr2), true)
  expect.equality(vim.api.nvim_buf_is_valid(bufnr3), true)

  -- All should be stored in tab variables
  expect.equality(vim.t.bufTaskBuild, bufnr1)
  expect.equality(vim.t.bufTaskTest, bufnr2)
  expect.equality(vim.t.bufTaskLint, bufnr3)
end

T['M.buffer()']['accepts bufTask with alphanumeric and underscore name'] = function()
  local bufnr = show.buffer('bufTask_my_task_123')
  expect.equality(type(bufnr), 'number')
  expect.equality(bufnr > 0, true)

  -- Cleanup this specific test buffer
  local tabID = vim.api.nvim_get_current_tabpage()
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
  pcall(vim.api.nvim_tabpage_del_var, tabID, 'bufTask_my_task_123')
end

-- Tests for named variants (with suffixes)
T['M.buffer()']['creates bufScratchLogs'] = function()
  local bufnr, msg = show.buffer('bufScratchLogs')
  expect.equality(bufnr > 0, true)
  expect.equality(vim.t.bufScratchLogs, bufnr)
end

T['M.buffer()']['creates bufShellBuild'] = function()
  local bufnr, msg = show.buffer('bufShellBuild')
  expect.equality(bufnr > 0, true)
  expect.equality(vim.t.bufShellBuild, bufnr)
end

-- Error handling tests
T['M.buffer()']['rejects invalid buffer name without valid prefix'] = function()
  local bufnr, msg = show.buffer('invalidName')
  expect.equality(bufnr, 0)
  expect.equality(type(msg), 'string')
  expect.equality(msg:match('must start with') ~= nil, true)
end

T['M.buffer()']['rejects non-string parameter'] = function()
  local bufnr, msg = show.buffer(123)
  expect.equality(bufnr, 0)
  expect.equality(type(msg), 'string')
  expect.equality(msg:match('non%-empty string') ~= nil, true)
end

T['M.buffer()']['rejects nil parameter'] = function()
  local bufnr, msg = show.buffer(nil)
  expect.equality(bufnr, 0)
  expect.equality(type(msg), 'string')
  expect.equality(msg:match('non%-empty string') ~= nil, true)
end

T['M.buffer()']['rejects bufTask with special characters in suffix'] = function()
  local bufnr, msg = show.buffer('bufTask[build]')
  expect.equality(bufnr, 0)
  expect.equality(msg:match('alphanumeric') ~= nil, true)
end

T['M.buffer()']['rejects bufShell with spaces in suffix'] = function()
  local bufnr, msg = show.buffer('bufShell build')
  expect.equality(bufnr, 0)
  expect.equality(msg:match('alphanumeric') ~= nil, true)
end

T['M.buffer()']['rejects bufScratch with hyphens in suffix'] = function()
  local bufnr, msg = show.buffer('bufScratch-logs')
  expect.equality(bufnr, 0)
  expect.equality(msg:match('alphanumeric') ~= nil, true)
end

-- Tab-scoped behavior tests
T['M.buffer()']['is tab-specific for bufScratch'] = function()
  -- Create buffer in current tab
  local bufnr1 = show.buffer('bufScratch')
  local tabID1 = vim.api.nvim_get_current_tabpage()

  -- Create new tab
  vim.cmd('tabnew')
  local tabID2 = vim.api.nvim_get_current_tabpage()

  -- Create buffer with same name in new tab
  local bufnr2 = show.buffer('bufScratch')

  -- Buffers should be different because they're in different tabs
  expect.no_equality(bufnr1, bufnr2)

  -- Clean up: close new tab
  vim.cmd('tabclose')

  -- Verify we're back in original tab with original buffer
  expect.equality(tabID1, vim.api.nvim_get_current_tabpage())
  expect.equality(bufnr1, vim.t.bufScratch)
end

T['M.buffer()']['is tab-specific for bufShell'] = function()
  -- Create buffer in current tab
  local bufnr1 = show.buffer('bufShell')
  local tabID1 = vim.api.nvim_get_current_tabpage()

  -- Create new tab
  vim.cmd('tabnew')
  local tabID2 = vim.api.nvim_get_current_tabpage()

  -- Create buffer with same name in new tab
  local bufnr2 = show.buffer('bufShell')

  -- Buffers should be different because they're in different tabs
  expect.no_equality(bufnr1, bufnr2)

  -- Clean up: close new tab
  vim.cmd('tabclose')

  -- Verify we're back in original tab with original buffer
  expect.equality(tabID1, vim.api.nvim_get_current_tabpage())
  expect.equality(bufnr1, vim.t.bufShell)
end

T['M.buffer()']['is tab-specific for bufTaskBuild'] = function()
  -- Create buffer in current tab
  local bufnr1 = show.buffer('bufTaskBuild')
  local tabID1 = vim.api.nvim_get_current_tabpage()

  -- Create new tab
  vim.cmd('tabnew')
  local tabID2 = vim.api.nvim_get_current_tabpage()

  -- Create buffer with same name in new tab
  local bufnr2 = show.buffer('bufTaskBuild')

  -- Buffers should be different because they're in different tabs
  expect.no_equality(bufnr1, bufnr2)

  -- Clean up: close new tab
  vim.cmd('tabclose')

  -- Verify we're back in original tab with original buffer
  expect.equality(tabID1, vim.api.nvim_get_current_tabpage())
  expect.equality(bufnr1, vim.t.bufTaskBuild)
end

-- Window management tests
T['M.window()'] = MiniTest.new_set({
  hooks = {
    post_case = function()
      -- Clean up: delete test buffers and close show window
      local test_vars = {
        'bufScratch',
        'bufShell',
        'bufTaskBuild',
      }
      local tabID = vim.api.nvim_get_current_tabpage()

      -- Close show window if it exists
      local ok, winID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'winID')
      if ok and vim.api.nvim_win_is_valid(winID) then
        vim.api.nvim_win_close(winID, true)
      end
      pcall(vim.api.nvim_tabpage_del_var, tabID, 'winID')

      -- Clean up buffers
      for _, var_name in ipairs(test_vars) do
        local buf_ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, tabID, var_name)
        if buf_ok and vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
        pcall(vim.api.nvim_tabpage_del_var, tabID, var_name)
      end
    end,
  },
})

T['M.window()']['fails when buffer does not exist'] = function()
  local winID, msg = show.window('bufScratch')
  expect.equality(winID, 0)
  expect.equality(type(msg), 'string')
  expect.equality(msg:match('not found') ~= nil, true)
end

T['M.window()']['creates window when buffer exists and window does not'] = function()
  -- Create buffer first
  local bufnr = show.buffer('bufScratch')
  expect.equality(bufnr > 0, true)
  
  -- Create window
  local winID, msg = show.window('bufScratch')
  expect.equality(type(winID), 'number')
  expect.equality(winID > 0, true)
  expect.equality(vim.api.nvim_win_is_valid(winID), true)
  expect.equality(msg:match('created new window') ~= nil, true)
end

T['M.window()']['stores window ID in vim.t.winID'] = function()
  local bufnr = show.buffer('bufScratch')
  local winID = show.window('bufScratch')
  
  expect.equality(vim.t.winID, winID)
end

T['M.window()']['creates window with 30% screen height'] = function()
  local bufnr = show.buffer('bufScratch')
  local winID = show.window('bufScratch')
  
  local expected_height = math.floor(vim.o.lines * 0.3)
  local actual_height = vim.api.nvim_win_get_height(winID)
  
  expect.equality(actual_height, expected_height)
end

T['M.window()']['creates window with full screen width'] = function()
  local bufnr = show.buffer('bufScratch')
  local winID = show.window('bufScratch')
  
  local actual_width = vim.api.nvim_win_get_width(winID)
  
  expect.equality(actual_width, vim.o.columns)
end

T['M.window()']['creates window below current window'] = function()
  local current_win = vim.api.nvim_get_current_win()
  
  local bufnr = show.buffer('bufScratch')
  local winID = show.window('bufScratch')
  
  -- Show window should be different from current window
  expect.no_equality(winID, current_win)
  -- Current window should still be focused
  expect.equality(vim.api.nvim_get_current_win(), current_win)
end

T['M.window()']['sets window options correctly'] = function()
  local bufnr = show.buffer('bufScratch')
  local winID = show.window('bufScratch')
  
  expect.equality(vim.wo[winID].sidescrolloff, 0)
  expect.equality(vim.wo[winID].winfixheight, true)
  expect.equality(vim.wo[winID].wrap, false)
  expect.equality(type(vim.wo[winID].winbar), 'string')
  expect.equality(#vim.wo[winID].winbar > 0, true)
end

T['M.window()']['displays correct buffer in window'] = function()
  local bufnr = show.buffer('bufScratch')
  local winID = show.window('bufScratch')
  
  local displayed_bufnr = vim.api.nvim_win_get_buf(winID)
  expect.equality(displayed_bufnr, bufnr)
end

T['M.window()']['reuses existing window on second call'] = function()
  local bufnr = show.buffer('bufScratch')
  local winID1, msg1 = show.window('bufScratch')
  local winID2, msg2 = show.window('bufScratch')
  
  expect.equality(winID1, winID2)
  expect.equality(msg2:match('reused existing window') ~= nil, true)
end

T['M.window()']['switches buffer in existing window'] = function()
  -- Create two buffers
  local bufnr1 = show.buffer('bufScratch')
  local bufnr2 = show.buffer('bufShell')
  
  -- Open window with first buffer
  local winID1 = show.window('bufScratch')
  expect.equality(vim.api.nvim_win_get_buf(winID1), bufnr1)
  
  -- Reuse window with second buffer
  local winID2 = show.window('bufShell')
  expect.equality(winID1, winID2)
  expect.equality(vim.api.nvim_win_get_buf(winID2), bufnr2)
end

T['M.window()']['handles multiple buffers in same window'] = function()
  local bufScratch = show.buffer('bufScratch')
  local bufShell = show.buffer('bufShell')
  local bufTask = show.buffer('bufTaskBuild')
  
  -- Open window with each buffer
  local win1 = show.window('bufScratch')
  local win2 = show.window('bufShell')
  local win3 = show.window('bufTaskBuild')
  
  -- All should return the same window ID
  expect.equality(win1, win2)
  expect.equality(win2, win3)
  
  -- Last buffer should be displayed
  expect.equality(vim.api.nvim_win_get_buf(win3), bufTask)
end

T['M.window()']['is tab-specific'] = function()
  -- Create buffer and window in first tab
  local bufnr1 = show.buffer('bufScratch')
  local winID1 = show.window('bufScratch')
  local tabID1 = vim.api.nvim_get_current_tabpage()
  
  -- Create new tab
  vim.cmd('tabnew')
  local tabID2 = vim.api.nvim_get_current_tabpage()
  
  -- Create buffer and window with same name in second tab
  local bufnr2 = show.buffer('bufScratch')
  local winID2 = show.window('bufScratch')
  
  -- Windows should be different
  expect.no_equality(winID1, winID2)
  
  -- Clean up: close new tab
  vim.cmd('tabclose')
  
  -- Verify back in original tab
  expect.equality(tabID1, vim.api.nvim_get_current_tabpage())
  expect.equality(vim.t.winID, winID1)
end

T['M.window()']['validates buffer name'] = function()
  -- Create a buffer with old bracket notation (should fail)
  local bufnr = show.buffer('bufScratch')
  
  -- Try to open window with different buffer name that doesn't exist
  local winID, msg = show.window('bufShell')
  expect.equality(winID, 0)
  expect.equality(msg:match('not found') ~= nil, true)
end

-- Channel management tests
T['M.channel()'] = MiniTest.new_set({
  hooks = {
    post_case = function()
      -- Clean up: delete test buffers, channels, and close show window
      local test_vars = {
        'bufScratch',
        'bufScratchLogs',
        'bufShell',
        'bufShellBuild',
        'bufTask',
        'bufTaskTest',
      }
      local tabID = vim.api.nvim_get_current_tabpage()

      -- Close show window if it exists
      local ok, winID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'winID')
      if ok and vim.api.nvim_win_is_valid(winID) then
        vim.api.nvim_win_close(winID, true)
      end
      pcall(vim.api.nvim_tabpage_del_var, tabID, 'winID')

      -- Clean up buffers and their channels
      for _, var_name in ipairs(test_vars) do
        local buf_ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, tabID, var_name)
        if buf_ok and vim.api.nvim_buf_is_valid(bufnr) then
          -- Try to close channel if it exists
          local chan_ok, chanID = pcall(vim.api.nvim_buf_get_var, bufnr, 'channel')
          if chan_ok and chanID and chanID > 0 then
            pcall(vim.fn.chanclose, chanID)
          end
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
        pcall(vim.api.nvim_tabpage_del_var, tabID, var_name)
      end
    end,
  },
})

-- Error handling tests
T['M.channel()']['fails when buffer does not exist'] = function()
  local chanID, msg = show.channel('bufScratch')
  expect.equality(chanID, 0)
  expect.equality(type(msg), 'string')
  expect.equality(msg:match('not found') ~= nil, true)
end

T['M.channel()']['fails with invalid buffer name'] = function()
  local chanID, msg = show.channel('invalidName')
  expect.equality(chanID, 0)
  expect.equality(type(msg), 'string')
  expect.equality(msg:match('must start with') ~= nil, true)
end

-- bufScratch tests
T['M.channel()']['clears bufScratch buffer'] = function()
  local bufnr = show.buffer('bufScratch')
  expect.equality(bufnr > 0, true)
  
  -- Add some content to buffer
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {'line1', 'line2', 'line3'})
  vim.bo[bufnr].modified = true
  
  -- Call channel should clear it
  local result, msg = show.channel('bufScratch')
  
  expect.equality(result, bufnr)
  expect.equality(msg:match('buffer cleared') ~= nil, true)
end

T['M.channel()']['returns buffer number for bufScratch'] = function()
  local bufnr = show.buffer('bufScratch')
  local chanID, msg = show.channel('bufScratch')
  
  expect.equality(chanID, bufnr)
  expect.equality(type(msg), 'string')
end

-- bufShell tests
T['M.channel()']['creates channel for bufShell'] = function()
  local bufnr = show.buffer('bufShell')
  expect.equality(bufnr > 0, true)
  
  local chanID, msg = show.channel('bufShell')
  
  expect.equality(type(chanID), 'number')
  expect.equality(chanID > 0, true)
  expect.equality(msg:match('created channel') ~= nil, true)
end

T['M.channel()']['stores channel ID in buffer variable'] = function()
  local bufnr = show.buffer('bufShell')
  local chanID = show.channel('bufShell')
  
  local stored_chanID = vim.api.nvim_buf_get_var(bufnr, 'channel')
  expect.equality(stored_chanID, chanID)
end

T['M.channel()']['reuses existing channel for bufShell'] = function()
  local bufnr = show.buffer('bufShell')
  local chanID1, msg1 = show.channel('bufShell')
  local chanID2, msg2 = show.channel('bufShell')
  
  expect.equality(chanID1, chanID2)
  expect.equality(msg2:match('existing channel') ~= nil, true)
end

T['M.channel()']['creates different channels for different bufShell buffers'] = function()
  local bufnr1 = show.buffer('bufShell')
  local bufnr2 = show.buffer('bufShellBuild')
  
  local chanID1 = show.channel('bufShell')
  local chanID2 = show.channel('bufShellBuild')
  
  expect.no_equality(chanID1, chanID2)
  expect.equality(chanID1 > 0, true)
  expect.equality(chanID2 > 0, true)
end

-- bufTask tests
T['M.channel()']['creates channel for bufTask'] = function()
  local bufnr = show.buffer('bufTask')
  expect.equality(bufnr > 0, true)
  
  local chanID, msg = show.channel('bufTask')
  
  expect.equality(type(chanID), 'number')
  expect.equality(chanID > 0, true)
  expect.equality(msg:match('created channel') ~= nil, true)
end

T['M.channel()']['reuses existing channel for bufTask'] = function()
  local bufnr = show.buffer('bufTaskTest')
  local chanID1, msg1 = show.channel('bufTaskTest')
  local chanID2, msg2 = show.channel('bufTaskTest')
  
  expect.equality(chanID1, chanID2)
  expect.equality(msg2:match('existing channel') ~= nil, true)
end

T['M.channel()']['creates different channels for different bufTask buffers'] = function()
  local bufnr1 = show.buffer('bufTask')
  local bufnr2 = show.buffer('bufTaskTest')
  
  local chanID1 = show.channel('bufTask')
  local chanID2 = show.channel('bufTaskTest')
  
  expect.no_equality(chanID1, chanID2)
  expect.equality(chanID1 > 0, true)
  expect.equality(chanID2 > 0, true)
end

-- Channel type differences
T['M.channel()']['bufShell channel differs from bufTask channel'] = function()
  local buf_shell = show.buffer('bufShell')
  local buf_task = show.buffer('bufTask')
  
  local chan_shell = show.channel('bufShell')
  local chan_task = show.channel('bufTask')
  
  -- Both should be valid but different
  expect.equality(chan_shell > 0, true)
  expect.equality(chan_task > 0, true)
  expect.no_equality(chan_shell, chan_task)
end

-- Tab-scoped behavior
T['M.channel()']['is tab-specific for bufShell'] = function()
  -- Create buffer and channel in first tab
  local bufnr1 = show.buffer('bufShell')
  local chanID1 = show.channel('bufShell')
  local tabID1 = vim.api.nvim_get_current_tabpage()
  
  -- Create new tab
  vim.cmd('tabnew')
  local tabID2 = vim.api.nvim_get_current_tabpage()
  
  -- Create buffer and channel with same name in second tab
  local bufnr2 = show.buffer('bufShell')
  local chanID2 = show.channel('bufShell')
  
  -- Buffers and channels should be different
  expect.no_equality(bufnr1, bufnr2)
  expect.no_equality(chanID1, chanID2)
  
  -- Clean up: close new tab
  vim.cmd('tabclose')
  
  -- Verify back in original tab
  expect.equality(tabID1, vim.api.nvim_get_current_tabpage())
end

T['M.channel()']['is tab-specific for bufTask'] = function()
  -- Create buffer and channel in first tab
  local bufnr1 = show.buffer('bufTask')
  local chanID1 = show.channel('bufTask')
  local tabID1 = vim.api.nvim_get_current_tabpage()
  
  -- Create new tab
  vim.cmd('tabnew')
  local tabID2 = vim.api.nvim_get_current_tabpage()
  
  -- Create buffer and channel with same name in second tab
  local bufnr2 = show.buffer('bufTask')
  local chanID2 = show.channel('bufTask')
  
  -- Buffers and channels should be different
  expect.no_equality(bufnr1, bufnr2)
  expect.no_equality(chanID1, chanID2)
  
  -- Clean up: close new tab
  vim.cmd('tabclose')
  
  -- Verify back in original tab
  expect.equality(tabID1, vim.api.nvim_get_current_tabpage())
end

-- Send management tests
T['M.send()'] = MiniTest.new_set({
  hooks = {
    post_case = function()
      -- Clean up: delete test buffers, channels, and close show window
      local test_vars = {
        'bufScratch',
        'bufScratchTest',
        'bufShell',
        'bufShellTest',
        'bufTask',
        'bufTaskTest',
      }
      local tabID = vim.api.nvim_get_current_tabpage()

      -- Close show window if it exists
      local ok, winID = pcall(vim.api.nvim_tabpage_get_var, tabID, 'winID')
      if ok and vim.api.nvim_win_is_valid(winID) then
        vim.api.nvim_win_close(winID, true)
      end
      pcall(vim.api.nvim_tabpage_del_var, tabID, 'winID')

      -- Clean up buffers and their channels
      for _, var_name in ipairs(test_vars) do
        local buf_ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, tabID, var_name)
        if buf_ok and vim.api.nvim_buf_is_valid(bufnr) then
          -- Try to close channel if it exists
          local chan_ok, chanID = pcall(vim.api.nvim_buf_get_var, bufnr, 'channel')
          if chan_ok and chanID and chanID > 0 then
            pcall(vim.fn.chanclose, chanID)
          end
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
        pcall(vim.api.nvim_tabpage_del_var, tabID, var_name)
      end
    end,
  },
})

-- Error handling tests
T['M.send()']['fails when buffer does not exist'] = function()
  local success, msg = show.send('bufScratch', 'test data')
  expect.equality(success, false)
  expect.equality(type(msg), 'string')
  expect.equality(msg:match('not found') ~= nil, true)
end

T['M.send()']['fails with invalid buffer name'] = function()
  local success, msg = show.send('invalidName', 'test')
  expect.equality(success, false)
  expect.equality(type(msg), 'string')
  expect.equality(msg:match('must start with') ~= nil, true)
end

T['M.send()']['fails with empty string for bufShell'] = function()
  local bufnr = show.buffer('bufShell')
  local chanID = show.channel('bufShell')
  
  local success, msg = show.send('bufShell', '')
  expect.equality(success, false)
  expect.equality(msg:match('cannot be empty') ~= nil, true)
end

T['M.send()']['fails with empty string for bufTask'] = function()
  local bufnr = show.buffer('bufTask')
  local chanID = show.channel('bufTask')
  
  local success, msg = show.send('bufTask', '')
  expect.equality(success, false)
  expect.equality(msg:match('cannot be empty') ~= nil, true)
end

-- bufScratch send tests
T['M.send()']['sends string to bufScratch'] = function()
  local bufnr = show.buffer('bufScratch')
  
  local success, msg = show.send('bufScratch', 'test line')
  
  expect.equality(success, true)
  -- Give schedule time to run
  vim.wait(100, function() return false end)
  
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  expect.equality(#lines > 0, true)
end

T['M.send()']['sends table of strings to bufScratch'] = function()
  local bufnr = show.buffer('bufScratch')
  
  local data = {'line 1', 'line 2', 'line 3'}
  local success, msg = show.send('bufScratch', data)
  
  expect.equality(success, true)
  -- Give schedule time to run
  vim.wait(100, function() return false end)
  
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  expect.equality(#lines >= 3, true)
end

T['M.send()']['fails with table containing non-string for bufScratch'] = function()
  local bufnr = show.buffer('bufScratch')
  
  local data = {'line 1', 123, 'line 3'}
  local success, msg = show.send('bufScratch', data)
  
  expect.equality(success, false)
  expect.equality(msg:match('not a string') ~= nil, true)
end

T['M.send()']['fails with invalid data type for bufScratch'] = function()
  local bufnr = show.buffer('bufScratch')
  
  local success, msg = show.send('bufScratch', 123)
  
  expect.equality(success, false)
  expect.equality(msg:match('must be a string or table') ~= nil, true)
end

-- bufShell send tests
T['M.send()']['sends command to bufShell'] = function()
  local bufnr = show.buffer('bufShell')
  local chanID = show.channel('bufShell')
  
  -- Use a simple command that should always exist
  local success, msg = show.send('bufShell', 'echo test')
  
  expect.equality(success, true)
end

T['M.send()']['fails with non-executable command for bufShell'] = function()
  local bufnr = show.buffer('bufShell')
  local chanID = show.channel('bufShell')
  
  local success, msg = show.send('bufShell', 'nonexistentcommand123')
  
  expect.equality(success, false)
  expect.equality(msg:match('not executable') ~= nil or msg:match('Command not found') ~= nil, true)
end

T['M.send()']['fails with table data for bufShell'] = function()
  local bufnr = show.buffer('bufShell')
  local chanID = show.channel('bufShell')
  
  local success, msg = show.send('bufShell', {'echo', 'test'})
  
  expect.equality(success, false)
  expect.equality(msg:match('must be a string') ~= nil, true)
end

T['M.send()']['fails when channel does not exist for bufShell'] = function()
  local bufnr = show.buffer('bufShell')
  -- Don't create channel
  
  local success, msg = show.send('bufShell', 'echo test')
  
  expect.equality(success, false)
  expect.equality(msg:match('no open channel') ~= nil, true)
end

-- bufTask send tests
T['M.send()']['sends data to bufTask'] = function()
  local bufnr = show.buffer('bufTask')
  local chanID = show.channel('bufTask')
  
  local success, msg = show.send('bufTask', 'test output')
  
  expect.equality(success, true)
end

T['M.send()']['fails with non-string data for bufTask'] = function()
  local bufnr = show.buffer('bufTask')
  local chanID = show.channel('bufTask')
  
  local success, msg = show.send('bufTask', {'test'})
  
  expect.equality(success, false)
  expect.equality(msg:match('must be a string') ~= nil, true)
end

T['M.send()']['fails when channel does not exist for bufTask'] = function()
  local bufnr = show.buffer('bufTask')
  -- Don't create channel
  
  local success, msg = show.send('bufTask', 'test output')
  
  expect.equality(success, false)
  expect.equality(msg:match('no open channel') ~= nil, true)
end

-- Multiple sends
T['M.send()']['handles multiple sends to bufScratch'] = function()
  local bufnr = show.buffer('bufScratch')
  
  local success1 = show.send('bufScratch', 'line 1')
  local success2 = show.send('bufScratch', 'line 2')
  local success3 = show.send('bufScratch', 'line 3')
  
  expect.equality(success1, true)
  expect.equality(success2, true)
  expect.equality(success3, true)
  
  -- Give schedule time to run
  vim.wait(100, function() return false end)
  
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  expect.equality(#lines >= 3, true)
end

T['M.send()']['handles multiple sends to bufShell'] = function()
  local bufnr = show.buffer('bufShell')
  local chanID = show.channel('bufShell')
  
  local success1 = show.send('bufShell', 'echo test1')
  local success2 = show.send('bufShell', 'echo test2')
  
  expect.equality(success1, true)
  expect.equality(success2, true)
end

-- Different buffer instances
T['M.send()']['sends to different bufScratch instances independently'] = function()
  local bufnr1 = show.buffer('bufScratch')
  local bufnr2 = show.buffer('bufScratchTest')
  
  show.send('bufScratch', 'data 1')
  show.send('bufScratchTest', 'data 2')
  
  expect.no_equality(bufnr1, bufnr2)
end

T['M.send()']['sends to different bufShell instances independently'] = function()
  local bufnr1 = show.buffer('bufShell')
  local bufnr2 = show.buffer('bufShellTest')
  local chan1 = show.channel('bufShell')
  local chan2 = show.channel('bufShellTest')
  
  local success1 = show.send('bufShell', 'echo test1')
  local success2 = show.send('bufShellTest', 'echo test2')
  
  expect.equality(success1, true)
  expect.equality(success2, true)
  expect.no_equality(bufnr1, bufnr2)
  expect.no_equality(chan1, chan2)
end

T['M.send()']['sends to different bufTask instances independently'] = function()
  local bufnr1 = show.buffer('bufTask')
  local bufnr2 = show.buffer('bufTaskTest')
  local chan1 = show.channel('bufTask')
  local chan2 = show.channel('bufTaskTest')
  
  local success1 = show.send('bufTask', 'output 1')
  local success2 = show.send('bufTaskTest', 'output 2')
  
  expect.equality(success1, true)
  expect.equality(success2, true)
  expect.no_equality(bufnr1, bufnr2)
  expect.no_equality(chan1, chan2)
end

return T
