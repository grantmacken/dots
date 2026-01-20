--- @see dot-config/nvim/lua/show/init.lua  the show module
---
--[[ markdown
# Show Module Example Commands
  The following commands demonstrate how to use the show module
  to display output in a dedicated per-tab show window.

  These commands create or reuse the show window for the current tab,
  ensuring that output is organized per project tabpage.
dd
--]]
--
vim.api.nvim_create_user_command(
  'ShowEdit',
  function()
    local bufName = 'bufEditExample'
    local show    = require('show')
    local data    = vim.fn.systemlist('ls -al .')
    show.edit(bufName, data)
  end,
  { desc = 'An example action that shows output in a edit buffer' }
)

vim.api.nvim_create_user_command(
  'ShowScratchExample',
  function()
    local bufName        = 'bufScratchExample'
    local show           = require('show')
    -- get a named buffer, create if named buffer does not exist
    local bufnr, buf_msg = show.buffer(bufName)
    if bufnr == 0 then
      vim.notify(buf_msg, vim.log.levels.ERROR)
      return
    end
    -- notify about buffer creation [optional]
    vim.notify(buf_msg, vim.log.levels.INFO)
    -- vim.notify("Using buffer: " .. bufName .. " (bufnr: " .. bufnr .. ")", vim.log.levels.INFO)
    local winID, win_msg = show.window(bufName)
    if winID == 0 then
      vim.notify(win_msg, vim.log.levels.ERROR)
      return
    end
    -- notify about window creation [optional]
    vim.notify(win_msg, vim.log.levels.INFO)
    local chanID, chan_msg = show.channel(bufName)
    if chanID == 0 then
      vim.notify(chan_msg, vim.log.levels.ERROR)
      return
    end
    show.send(bufName, "clear && echo 'Hello from ShowShellExample'")
  end,
  { desc = 'An example action that shows output in a scratch buffer' }
)

vim.api.nvim_create_user_command(
  'ShowShell',
  function()
    local bufName = 'bufShellExample'
    local show    = require('show')
    show.shell(bufName, "clear" .. " && echo 'Hello from ShowShell'")
  end,
  { desc = 'An example action sends a cmd to terminal buffer' }
)

vim.api.nvim_create_user_command(
  'ShowShellExample',
  function()
    local bufName        = 'bufShellExample'
    local show           = require('show')
    -- get a named buffer, create if named buffer does not exist
    local bufnr, buf_msg = show.buffer(bufName)
    if bufnr == 0 then
      vim.notify(buf_msg, vim.log.levels.ERROR)
      return
    end
    -- notify about buffer creation [optional]
    vim.notify(buf_msg, vim.log.levels.INFO)
    -- vim.notify("Using buffer: " .. bufName .. " (bufnr: " .. bufnr .. ")", vim.log.levels.INFO)
    local winID, win_msg = show.window(bufName)
    if winID == 0 then
      vim.notify(win_msg, vim.log.levels.ERROR)
      return
    end
    -- notify about window creation [optional]
    vim.notify(win_msg, vim.log.levels.INFO)
    local chanID, chan_msg = show.channel(bufName)
    if chanID == 0 then
      vim.notify(chan_msg, vim.log.levels.ERROR)
      return
    end
    -- -- send a shell command to the show buffer
    show.send(bufName, "clear && echo 'Hello from ShowShellExample'")
    -- show.send(bufName, "ls -al .")
  end,
  { desc = 'An example action sends a cmd to terminal buffer' }
)

vim.api.nvim_create_user_command(
  'ShowTaskExample',
  function()
    local bufName        = 'bufTaskExample'
    local show           = require('show')
    -- get a named buffer, create if named buffer does not exist
    local bufnr, buf_msg = show.buffer(bufName)
    if bufnr == 0 then
      vim.notify(buf_msg, vim.log.levels.ERROR)
      return
    end
    -- notify about buffer creation [optional]
    vim.notify(buf_msg, vim.log.levels.INFO)
    -- vim.notify("Using buffer: " .. bufName .. " (bufnr: " .. bufnr .. ")", vim.log.levels.INFO)
    local winID, win_msg = show.window(bufName)
    if winID == 0 then
      vim.notify(win_msg, vim.log.levels.ERROR)
      return
    end
    -- notify about window creation [optional]
    vim.notify(win_msg, vim.log.levels.INFO)
    local chanID, chan_msg = show.channel(bufName)
    vim.notify(chan_msg, vim.log.levels.INFO)
    if chanID == 0 then
      vim.notify(chan_msg, vim.log.levels.ERROR)
      return
    end
    -- local set   = show.tput_set
    -- local style = {
    --   bold    = set('bold'),
    --   warn    = set('warn'),
    --   good    = set('good'),
    --   caution = set('caution'),
    --   reset   = set('reset'),
    -- }
    local send = show.send
    local cmd  = { 'git', 'status', '--short', '--branch' }
    local opts = { text = true }
    vim.system(cmd, opts, function(res)
      vim.schedule(function()
        send(bufName, string.format(' - code:  %s', res.code))
        send(bufName, string.format(' - signal:  %s', res.signal))
        send(bufName, string.format(' - stdout:  %s', res.stdout))
        send(bufName, string.format(' - stderr:  %s', res.stderr))
      end)
    end)

    cmd = { 'ls', '-al', '.' }
    vim.system(cmd, opts, function(res)
      vim.schedule(function()
        send(bufName, string.format(' - code:  %s', res.code))
        send(bufName, string.format(' - signal:  %s', res.signal))
        send(bufName, string.format(' - stdout:  %s', res.stdout))
        send(bufName, string.format(' - stderr:  %s', res.stderr))
      end)
    end)

    cmd = { 'ls', '-al', '/nonexistent' }
    vim.system(cmd, opts, function(res)
      vim.schedule(function()
        send(bufName, string.format(' - code:  %s', res.code))
        send(bufName, string.format(' - signal:  %s', res.signal))
        send(bufName, string.format(' - stdout:  %s', res.stdout))
        send(bufName, string.format(' - stderr:  %s', res.stderr))
      end)
    end)
  end,
  { desc = 'An example action sends a cmd to terminal buffer' }
)

-- vim.api.nvim_create_user_command(
--   'ShowKillCurrentBuffer',
--   function()
--     local show = require('show')
--     show.kill_buffer()
--   end,
--   { desc = 'kill the current buffer in the show window' }
-- )

vim.api.nvim_create_user_command(
  'GitStatus',
  function()
    local bufName        = 'bufTaskGitStatus'
    local show           = require('show')
    -- get a named buffer, create if named buffer does not exist
    local bufnr, buf_msg = show.buffer(bufName)
    if bufnr == 0 then
      vim.notify(buf_msg, vim.log.levels.ERROR)
      return
    end
    -- notify about buffer creation [optional]
    vim.notify(buf_msg, vim.log.levels.INFO)
    -- vim.notify("Using buffer: " .. bufName .. " (bufnr: " .. bufnr .. ")", vim.log.levels.INFO)
    local winID, win_msg = show.window(bufName)
    if winID == 0 then
      vim.notify(win_msg, vim.log.levels.ERROR)
      return
    end
    -- notify about window creation [optional]
    vim.notify(win_msg, vim.log.levels.INFO)
    local chanID, chan_msg = show.channel(bufName)
    vim.notify(chan_msg, vim.log.levels.INFO)
    if chanID == 0 then
      vim.notify(chan_msg, vim.log.levels.ERROR)
      return
    end
    -- local set   = show.tput_set
    -- local style = {
    --   bold    = set('bold'),
    --   warn    = set('warn'),
    --   good    = set('good'),
    --   caution = set('caution'),
    --   reset   = set('reset'),
    -- }
    local send = show.send
    local cmd  = { 'git', '-c', 'color.status=always', 'status', '--short', '--branch' }
    local opts = { text = true }
    vim.system(cmd, opts, function(res)
      vim.schedule(function()
        --send(bufName, string.format(' - code:  %s', res.code))
        --send(bufName, string.format(' - signal:  %s', res.signal))
        send(bufName, res.stdout)
        -- send(bufName, string.format(' - stderr:  %s', res.stderr))
      end)
    end)
  end,
  { desc = 'An example action sends a cmd to terminal buffer' }
)
--
-- local group = vim.api.nvim_create_augroup('my_group', {})
-- local au = function(event, pattern, callback, desc)
--   vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback, desc = desc })
-- end

--[[
-- Clear tabpage variables when show window is closed
--]]

-- au('WinClosed', '*', function(args)
--     local closedWinID = tonumber(args.match)
--     local closedBufnr = tonumber(args.buf)
--     -- check if the closed window is the show window for the tabpage
--     if vim.t['winID'] == closedWinID then
--       local tabID = vim.api.nvim_get_current_tabpage()
--       vim.api.nvim_tabpage_del_var(tabID, 'winID')
--       vim.notify('Show window closed, cleared tabpage variables', vim.log.levels.INFO)
--     end
--   end,
--   'Clear tabpage variables when show window is closed'
-- )

-- vim.api.nvim_create_autocmd("QuitPre", {
--   pattern = "*",
--   callback = function(args)
--     vim.notify(vim.inspect(args), vim.log.levels.INFO)
--     -- -- Insert your condition here
--     -- local is_safe_to_close = false
--     --
--     -- if not is_safe_to_close then
--     --     -- Throwing an error aborts the :quit command
--     --     error("⚠️ Close cancelled: You must finish the task first!")
--     -- end
--     --
--     -- If we don't error, the window continues to close as normal
--   end,
-- })
