local M = {}

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

function M.commit()
  local on_exit = function(obj)
    vim.notify(vim.inspect(obj.code))
    vim.notify(vim.inspect(obj.stdout))
    local scratch = require('scratch')
    scratch.show(vim.split(obj.stdout, '\n'), 'Copilot')
  end
  -- Runs asynchronously:

  local obj = vim.system({
      'copilot',
      '-p',
      'add commit message since last commit',
      '--allow-all-tools',
      '--add-dir', vim.fn.getcwd()
    },
    { text = true, on_exit })
end





return M
