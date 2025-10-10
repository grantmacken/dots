local M = {}

--[[
Helper function to execute a shell command and return the output.
@see dot-config/nvim/plugin/10_git.lua
@see dot-config/nvim/lua/git/init.lua
@see dot-config/nvim/lua/scratch/init.lua

]] --

-- Executes a shell command and returns the output (trimmed)
local function get_shell_output(cmd)
  -- Use vim.fn.system() to execute the command.
  -- We include `2> /dev/null` to silence git errors if it's not a repo.
  local result = vim.fn.system(cmd .. " 2> /dev/null")
  -- vim.fn.system() output includes a trailing newline, so we trim it.
  return result:gsub("[\r\n]", "")
end

function M.get_current_branch()
  -- Use `git branch --show-current` (available in modern Git versions)
  -- to get the branch name directly.
  local branch = get_shell_output("git branch --show-current")
  if branch ~= "" then
    return branch
  end

  -- Fallback for detached HEAD state or older git versions
  -- which prints the abbreviated commit hash.
  local detached_head = get_shell_output("git rev-parse --abbrev-ref HEAD")

  if detached_head == "HEAD" then
    return detached_head -- In detached state, it shows 'HEAD'
  elseif detached_head ~= "" then
    return detached_head -- Must be a branch name
  else
    return ""            -- Not a git repository
  end
end

function M.update_branch_name()
  -- Check if the current buffer is in a git work tree
  if vim.fs.root(0, ".git") then
    vim.b.current_git_branch = M.get_current_branch()
  else
    vim.b.current_git_branch = ""
  end
end

-- Commit changes using copilot-cli to generate commit message
-- and show the output in a scratch buffer
function M.commit()
  local obj = vim.system({
      'copilot',
      '-p',
      'add commit message since last commit',
      '--allow-all-tools',
      '--add-dir', vim.fn.getcwd()
    },
    { text = true }, function(obj)
      local scratch = require('scratch')
      scratch.show(vim.split(obj.stdout, '\n'), 'Copilot')
    end)
end

function M.push()
  local obj = vim.system({
      'git',
      'push',
    },
    { text = true }, function(obj)
      local scratch = require('scratch')
      scratch.show(vim.split(obj.stdout, '\n'), 'Copilot')
    end)
end

function M.revert()
  local obj = vim.system({
      'git',
      'revert',
      '--no-edit',
      'HEAD',
    },
    { text = true }, function(obj)
      local scratch = require('scratch')
      scratch.show(vim.split(obj.stdout, '\n'), 'Git Revert')
    end)
end

-- Find the commit hash: git log -1
M.get_last_commit_hash = function()
  local commit_hash = get_shell_output("git log -1 --pretty=format:%H")
  return commit_hash
end


M.list = function()
  local obj = vim.system({
      'git',
      'log',
      '--oneline',
      '--graph',
      '--decorate',
      '--all',
      '--color=always'
    },
    { text = true }, function(obj)
      local scratch = require('scratch')
      scratch.show(vim.split(obj.stdout, '\n'), 'Git List Commits')
    end)
end

return M
