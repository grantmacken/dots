--[[
Git commands using custom lua module
@see dot-config/nvim/lua/git/init.lua
@see dot-config/nvim/lua/show/init.lua
@see dot-config/nvim/plugin/10_git.lua

--]]


vim.api.nvim_create_user_command(
  'GitPush',
  require('git').push, {
    desc = 'Use git to push commits to remote',
  })

vim.api.nvim_create_user_command(
  'GitCommit',
  function()
    vim.schedule(function()
      local res = require('git').commit()
      local show = require('show')
      show.open_term(res, 'Git Commit Message')
    end)
  end,
  { desc = 'Use Copilot to generate a git commit message' }
)


vim.api.nvim_create_user_command(
  'GitListCommits',
  function()
    vim.schedule(function()
      local res = require('git').list()
      local show = require('show')
      show.open_term(res, 'Git Commits')
    end)
  end,
  { desc = 'List git commits in scratch buffer' }
)

vim.api.nvim_create_user_command(
  'GitLastCommitHash',
  function()
    local hash = require('git').get_last_commit_hash()
    if hash and hash ~= '' then
      vim.notify('Last commit hash: ' .. hash, vim.log.levels.INFO, { title = 'Git Last Commit Hash' })
    else
      vim.notify('No commits found', vim.log.levels.WARN, { title = 'Git Last Commit Hash' })
    end
  end,
  { desc = 'notify last commit hash' }
)

local keymap = require('util').keymap
keymap('<leader>gc', require('git').commit, 'git [c]ommit')
keymap('<leader>gl', require('git').list, 'git [c]ommit')
keymap('<leader>gp', require('git').push, 'git [p]push')
keymap('<leader>gr', require('git').revert, 'git [r]evert last commit')
