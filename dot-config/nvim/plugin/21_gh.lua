--[[ working with git using the show module
 - git status
 - git commit
   - using vim.ui.prompt

]] --

vim.api.nvim_create_user_command(
  'GitStatus',
  function()
    local show = require('show')
    show.task('GitStatus', { 'git', '-c', 'color.status=always', 'status', '--short', '--branch' })
  end,
  { desc = 'Send git status a task to terminal buffer' }
)

vim.api.nvim_create_user_command(
  'GitAddAll',
  function()
    local show = require('show')
    show.task('GitAddAll', { 'git', 'add', '--all' })
    show.task('GitStatusAfterAdd', { 'git', '-c', 'color.status=always', 'status', '--short', '--branch' })
  end,
  { desc = 'Send git add --all as a task to terminal buffer' }
)


-- git commit using vim.ui.prompt
vim.api.nvim_create_user_command(
  'GitCommitAll',
  function()
    vim.ui.input({ prompt = 'Enter commit message: ' }, function(input)
      if input == nil or input == '' then
        vim.notify('Commit message cannot be empty.', vim.log.levels.WARN)
        return
      end
      local show = require('show')
      show.task('GitCommit', { 'git', 'commit', '-am', input })
    end)
  end,
  { desc = 'Prompt for commit message and send git commit as a task to terminal buffer' }
)

-- vim.api.nvim_create_user_command(
--   'GitStatus',
--   function()
--     local bufName        = 'bufTaskGitStatus'
--     local show           = require('show')
--     -- get a named buffer, create if named buffer does not exist
--     local bufnr, buf_msg = show.buffer(bufName)
--     if bufnr == 0 then
--       vim.notify(buf_msg, vim.log.levels.ERROR)
--       return
--     end
--     local winID, win_msg = show.window(bufName)
--     if winID == 0 then
--       vim.notify(win_msg, vim.log.levels.ERROR)
--       return
--     end
--     local chanID, chan_msg = show.channel(bufName)
--     if chanID == 0 then
--       vim.notify(chan_msg, vim.log.levels.ERROR)
--       return
--     end
--     local send = show.send
--     local cmd  = { 'git', '-c', 'color.status=always', 'status', '--short', '--branch' }
--     local opts = { text = true }
--     vim.system(cmd, opts, function(res)
--       vim.schedule(function()
--         --send(bufName, string.format(' - code:  %s', res.code))
--         --send(bufName, string.format(' - signal:  %s', res.signal))
--         send(bufName, res.stdout)
--         -- send(bufName, string.format(' - stderr:  %s', res.stderr))
--       end)
--     end)
--   end,
--   { desc = 'An example action sends a cmd to terminal buffer' }
-- )

vim.api.nvim_create_user_command(
  'GitCommitPrompt',
  function()
    local bufName        = 'bufTaskGitCommitPrompt'
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
    local send   = show.send
    local prompt = '/conventional-commitprompt'
    local cmd    = { 'copilot', '-p', prompt, '--allow-all-tools', '--add-dir', '.' }
    local opts   = { text = true }
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
