local M = {}
M.version = '0.1.0'
M.description = [[
a nvim lua module to manage my GitHub repos
- Provides commands to create, view, and manage GitHub issues and PRs
- Integrates with the GitHub CLI (`gh`) to perform operations
- Uses the `show` module to display issue and PR details in a dedicated window

Notes: formating
 - private functions: lower_snake_case e.g. get_issue_data, format_issue_body, etc.
 - public functions: lowerCamelCase e.g. createIssue viewIssues viewIssueNumber, etc.
 - commands:  UpperCamelCase  with word prefix the module name e.g. IssueCreate, IssueView, IssueViewNumber, etc.
]]
M.repo_owner = 'grantmacken'

--[[ section:  private local functions here ]] --
-- add any helper functions here that are not exposed as part of the module's public API
-- these functions can be used internally by the public functions defined below
-- deps:  this module dependencies
local show = require('show')
local repo_owner = 'grantmacken'

-- helper function to get the repo owner and name from the current working directory, assuming it's a git repository
-- @return string, string the repo owner and name, or empty string if not in a git repository
local get_repo_api_name = function()
  local root = vim.fs.root('.', { ".git" }) or ''
  local dir_name = root and vim.fs.basename(root) or ''
  return repo_owner, dir_name
end

--- align issue with some conventional commits
-- local issue_types = { 'fix', 'feature', 'refactor', 'chore', 'docs' }

-- each command is a string with the format "IssueCommandName"
-- each keymap is a table with the format { mode, lhs, rhs, desc }

---@pram commands string[] a list of command names to set up, e.g. { 'RepoIssueCreate', 'RepoIssueView', etc. }
---@param bufnr integer|nil the buffer number to set the commands for, if nil the commands will be global
---@return nil
local set_commands = function(commands, bufnr)
  --[[ Command conventions: begin with this module name: `repo` with  first letter uppercase, then more context:  e.g. "RepoIssueCreate"
     - the function to call is the substring after "Repo", with the first letter lowercased e.g. "RepoIssueCreate" -> "issueCreate"
     - the description for the command is the cmd  split into words, e.g. "RepoIssueCreate" -> "Repo Issue Create"
     - the spliting function call is cmd:gsub("%u", " %0"):gsub("^%s+", "")
     ]]
  -- split command name into words for descriptio
  local words_to_description = function(s) return s:gsub("%u", " %0"):gsub("^%s+", "") end
  if not bufnr then
    for _, cmd in ipairs(commands) do
      -- get the function name by removing "Repo" prefix and lowercasing first letter
      local func = cmd:sub(5, 5):lower() .. cmd:sub(6)
      if M[func] then
        vim.api.nvim_create_user_command(cmd, function(opts) M[func](opts) end, { desc = words_to_description(cmd) })
      else
        vim.notify('Repo: no function found for command ' .. cmd, vim.log.levels.WARN)
      end
    end
  else
    vim.notify('Repo: setting up buffer-local commands for buffer ' .. bufnr)
    local function lowercase_first(s) return (s:gsub("^%u", string.lower)) end
    for _, cmd in ipairs(commands) do
      local func = lowercase_first(cmd) -- get the function name by lowercasing first letter
      if M[func] then
        vim.api.nvim_buf_create_user_command(bufnr, cmd, function(opts) M[func](opts) end,
          { desc = words_to_description(cmd) })
      else
        vim.notify('Repo no function found for command ' .. cmd, vim.log.levels.WARN)
      end
    end
  end
end

---@param keymaps table[] a list of keymap definitions, where each keymap is a table with the format { mode, lhs, rhs, desc }
---@param bufnr integer|nil the buffer number to set the commands for, if nil the commands will be global
---@return nil
local set_keymaps = function(keymaps, bufnr)
  if not bufnr then
    vim.notify('Repo: setting up global keymaps')
    for _, keymap in ipairs(keymaps) do
      vim.keymap.set(keymap[1], keymap[2], keymap[3], { desc = keymap[4] })
    end
  else
    vim.notify('Repo: setting up buffer-local keymaps for buffer ' .. bufnr)
    for _, keymap in ipairs(keymaps) do
      vim.keymap.set(keymap[1], keymap[2], keymap[3], { buffer = bufnr, desc = keymap[4] })
    end
  end
end

--- autocmds are defined as tables in the `autocmds` table, with the format { event, pattern, group, callback, desc }
---@param autocmds table[] a list of autocmd definitions, where each autocmd is a table with the format { event, pattern, group, callback, desc }
---@param bufnr integer|nil the buffer number to set the commands for, if nil the commands will be global
---@return nil
local set_autocmds = function(autocmds, bufnr)
  if not bufnr then
    vim.notify('Repo: setting up global autocmds')
    for _, autocmd in ipairs(autocmds) do
      vim.api.nvim_create_autocmd(autocmd.event, {
        group = autocmd.group,
        pattern = autocmd.pattern,
        callback = autocmd.callback,
        desc = autocmd.desc,
      })
    end
  else
    vim.notify('Repo: setting up buffer-local autocmds for buffer ' .. bufnr)
  end
end

M.setup = function()
  --[[ Command conventions: begin with this module name: `repo` with  first letter uppercase, then more context:  e.g. "RepoIssueCreate"
     - the function to call is the substring after "Repo", with the first letter lowercased e.g. "RepoIssueCreate" -> "issueCreate"
     - the description for the command is the cmd  split into words, e.g. "RepoIssueCreate" -> "Repo Issue Create"
     - the spliting function call is cmd:gsub("%u", " %0"):gsub("^%s+", "")
     ]]
  set_commands({
    -- GIT BRANCHES
    'RepoBranchList', --  branchList
    --'RepoBranchCreate',    --  branchCreate
    -- ISSUES
    'RepoIssueList',        -- issueList
    'RepoIssueCreate',      -- issueCreate
    'RepoIssueDevelopList', -- issueDevelopList -- list issues that are being developed, i.e. issues that have a branch created from them
    'RepoIssueView',        -- issueView
    'RepoPullRequestList',  -- pullRequestList
    'RepoPullRequestView',  -- pullRequestView
    -- 'RepoViewLabels',    -- viewLabels
    'RepoWorkflowRun',      -- workflowRun
    'RepoWorkflowView',     -- workflowView
    'RepoGitPush',          -- gitPush
    'RepoStatus',           -- status
    'RepoGhHelp',           -- ghHelp
    'RepoGitCommitAll',     -- gitCommitAll
  })

  set_keymaps({
    { 'n', '<leader>ric', ':RepoIssueCreate<CR>', 'Create a new GitHub issue' }
  })

  set_autocmds({
    -- add any autocmds here if needed, e.g. to refresh issue list after creating a new issue, or to update the status of an issue when the buffer is written, etc.
  })
  vim.notify('Repo module setup complete')
end

-- helper function to auto commit and push changes before creating a branch or pull request, to ensure the branch or pull request is created from the latest commit on the current branch
-- @param what string the action that is being performed, e.g. "creating branch" or "creating pull request", used for the commit message
-- @return boolean, string true if the commit and push were successful, false otherwise and a notify message with the result of the operation
local auto_commit_push = function(what)
  local cmd = { 'git', 'commit', '-am', 'Auto commit before ' .. what }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    return false, string.format('Error committing changes before %s: %s', what, obj.stderr)
  end
  cmd = { 'git', 'push' }
  obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    return false, string.format('Error pushing changes before %s: %s', what, obj.stderr)
  end
  return true, 'Changes pushed successfully'
end

--- helper function to get the latest issue or pull request number using the GitHub CLI
--- @param what string the type of item to fetch, either "issue" or "pr"
--- return number the latest issue or pull request number, or 0 if there was an error fetching the data and the std err message
--- @return number, string: the latest issue or pull request number, or 0 if there was an error fetching the data, and the error message if there was an error
local get_latest = function(what)
  local cmd = { 'gh', what, 'list', '--limit', '1', '--json', 'number', '--jq', ".[0].number" }
  local obj = vim.system(cmd):wait()
  local msg = ''
  if obj.code ~= 0 then
    msg = string.format('Error fetching latest %s: %s', what, obj.stderr)
    return 0, msg
  end
  -- stdout of the command should be the number of the latest issue or pull request, we can trim it and convert it to a number
  local int = vim.trim(obj.stdout)
  local ok, num = pcall(tonumber, int)
  if not ok then
    msg = string.format('Error converting latest %s number to a number: %s', what, int)
    return 0, msg
  else
    msg = string.format('Latest %s number: %d', what, num)
    return num or 0, msg
  end
end

--- helper function to get the title and body of an issue or pull request using the GitHub CLI
--- @param what string the type of item to fetch, either "issue" or "pr"
--- @param int number the number of the issue or pull request to fetch
--- @return table a list of lines containing the title and body of the issue or pull request
local get_remote_view_data = function(what, int)
  local data = {}
  local title = vim.fn.systemlist('gh ' .. what .. ' view ' .. tostring(int) .. ' --json title --template {{.title}}')
  vim.list_extend(data, title)
  -- the title is the first line of the buffer, and the body is everything after the first line
  -- add a blank line between the title and the body for better readability
  table.insert(data, '') -- add a blank line between title and body
  local body = vim.fn.systemlist('gh ' .. what .. ' view ' .. tostring(int) .. ' --json body --template {{.body}}')
  vim.list_extend(data, body)
  return data
end

--- @param bufnr integer the buffer number of the issue or pull request view buffer
--- @return string, string the title and body of the issue or pull request as entered in the buffer, with any markdown formatting removed from the title and leading/trailing whitespace removed from the body
local get_local_view_data = function(bufnr)
  local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  -- The title is on the first line, and the body is everything after the first line
  local title = content[1] or ''
  -- remove any markdown formatting from the title, e.g. if the title is "# Issue Title" we want to remove the "# " part
  title = title:gsub('^#%s*', '')
  -- the body is everything after the first line, joined together with newlines
  -- trim any leading or trailing whitespace from the body
  local body = table.concat(vim.list_slice(content, 2), '\n')
  body = body:gsub('^%s+', ''):gsub('%s+$', '')
  return title, body
end

---@param what string the type of item to edit, either "issue" or "pr"
---@param int number the number of the issue or pull request to edit
---@param title string the new title of the issue or pull request
---@param body string the new body of the issue or pull request
---@return boolean, string true if the edit was successful, false otherwise and a notify or error message
local edit_remote_view = function(what, int, title, body)
  local cmd = { 'gh', what, 'edit', tostring(int), '--title', title, '--body', body }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    return false, string.format('Error saving %s: %s', what, obj.stderr)
  end
  return true, string.format('%s #%d remote update successfully', what, int)
end

local update_view = function(what)
  local num, ok, msg, title, body
  local bufnr = vim.api.nvim_get_current_buf()
  num, msg = get_latest(what)
  if num == 0 then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end
  title, body = get_local_view_data(bufnr)
  ok, msg = edit_remote_view(what, num, title, body)
  if ok then
    vim.notify(msg, vim.log.levels.INFO)
  else
    vim.notify(msg, vim.log.levels.ERROR)
  end
end

--- helper function to create a new issue or pull request using the GitHub CLI, with the title and body provided as arguments
--- @param what string the type of item to create, either "issue" or "pr"
--- @param title string the title of the issue or pull request to create
--- @param body string the body of the issue or pull request to create
--- @return boolean, string true if the creation was successful, false otherwise and a notify or error message
local createRemote = function(what, title, body)
  vim.print('Repo: creating ' .. what)
  local cmd = { 'gh', what, 'create', '--title', title, '--body', body }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    return false, string.format('Error creating %s: %s', what, obj.stderr)
  end
  return true, string.format('%s created: %s', what, obj.stdout)
end

--- helper function to create a new comment on an issue or pull request using the GitHub CLI, with the comment body provided as an argument
--- @param what string the type of item to comment on, either "issue" or "pr"
--- @param num number the number of the issue or pull request to comment on
--- @param body string the body of the comment to create
--- @return boolean, string true if the comment was created successfully, false otherwise and a notify or error message
local comment_send = function(what, num, body)
  local cmd = { 'gh', what, 'comment', tostring(num), '--body', body }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    return false, string.format('Error creating comment on %s #%d: %s', what, num, obj.stderr)
  end
  return true, string.format('Comment created successfully on %s #%d', what, num)
end

--- helper function to create a new comment on an issue or pull request
--- @param what string the type of item to comment on, either "issue" or "pr"
--- @param num number? the number of the issue or pull request to comment on, if not provided the function will fetch the latest issue or pull request number using the GitHub CLI
--- @param body string? the body of the comment to create, if not provided the function will prompt the user for the comment body using vim.ui.input
--- @return nil the function will notify the user of the result of the operation, but does not return any value
local comment_create = function(what, num, body)
  local msg, prompt
  if not num then
    num, msg = get_latest(what)
    if num == 0 then
      vim.notify(msg, vim.log.levels.WARN)
      return
    end
  end
  if body and body ~= '' then
    comment_send(what, num, body)
  else
    prompt = string.format('Enter comment body for %s #%d: ', what, num)
    vim.ui.input({ prompt = prompt }, function(input)
      if not input or input == '' then
        vim.notify(string.format('%s comment body cannot be empty', what), vim.log.levels.WARN)
        return
      end
      comment_send(what, num, input)
    end)
  end
end


--- helper function to close an issue using the GitHub CLI
--- @param issue_number number the number of the issue to close
--- @param comment string the comment to add to the issue before closing it, e.g. "Closing issue as it has been resolved in the latest commit"
--- @param reason string the reason for closing the issue, e.g. "completed", "not planned", "duplicate", etc. this will be added as a label to the issue before closing it
local issue_close = function(issue_number, comment, reason)
  local cmd = {
    'gh', 'issue', 'close', tostring(issue_number), --reason reason, '--comment', comment
  }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error closing issue: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  local msg = string.format('Issue #%d closed successfully', issue_number)
  vim.notify(msg, vim.log.levels.INFO)
end

--[[ section:  public functions here ]] --
-- add any functions here that are exposed as part of the module's public API
M.ghHelp = function()
  show.shell('Repo', 'gh help')
end

M.workflowRun = function()
  show.shell('Repo', 'gh workflow run default.yml')
end

M.workflowView = function()
  show.shell('Repo', 'gh workflow view default.yml --limit 1')
end

--[[ Git operations functions here ]] --
-- git status oneliner with branch info and color coding, using git status --short --branch and setting color.status=always to ensure colors are included in the output
M.status = function()
  show.shell('Repo', 'git -c "color.status=always" status --short --branch')
end

M.branchList = function()
  local owner, repo = get_repo_api_name()
  if owner == '' or repo == '' then
    vim.notify('Not in a git repository or unable to determine repo name', vim.log.levels.WARN)
    return
  end
  local api_call = string.format('repos/%s/%s/%s', owner, repo, 'branches')
  local template = string.format('{{range .}}{{.name}}{{"\\n"}}{{end}}')
  local cmd = { 'gh', 'api', api_call, '--paginate', '--template', template }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error fetching branches: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  --[[ TODO use show module to display branches in a nice way, maybe with some color coding based on branch type (e.g. feature, bugfix, etc.)
   split test into lines
   local branches = vim.split(obj.stdout, '\n')
  vim.print('Repo: listing branches')
  ]]
  local body = vim.tbl_map(
    function(t)
      return '- [ ] ' .. t
    end, vim.split(obj.stdout, '\n')
  )
  -- remove last list item if it's empty (which can happen if the output ends with a newline)
  if body[#body] == '- [ ] ' then
    table.remove(body, #body)
  end
  show.edit('Branches', body)
  --[[ TODO:  we can also add some interactivity to the branch list, e.g. keymaps to checkout a branch, delete a branch, etc. using the show module's edit window and buffer-local keymaps ]]
end

M.issueDevelopWithBranch = function()
  --[[ develop branch from issue:
  create a new branch from the current branch, with the name and description derived from the issue,
  using the GitHub CLI to create the branch and then checking it out,
  only available in the issue view buffer
  Steps:
   1. commit and push all changes first, to ensure the branch is created from the latest commit on the current branch
   2. get the latest issue number using the GitHub CLI, and use the issue title and body to create a new branch name and description for the branch
   3, name issue with naming convention -- issue-issue_number-issue-title, e.g. "issue-123-add-login-feature"
   4. create branch using to create a new branch from the current branch, with the name and description derived from the issue
   5. if branch creation is successful, we can also add a comment to the issue with the link to the branch
  ]] --
  local ok, msg, cmd, obj, issue_number, bufnr
  ok, msg = auto_commit_push('creating branch')
  if not ok then
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end
  vim.notify(msg, vim.log.levels.INFO)
  issue_number, msg = get_latest('issue')
  if issue_number == 0 then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end
  bufnr = vim.api.nvim_get_current_buf()
  vim.notify('Repo: creating branch from issue view buffer ' .. bufnr, vim.log.levels.INFO)
  local edit_title, _ = get_local_view_data(bufnr)
  local branch_name = string.format('%s-%d-%s', 'issue', issue_number, edit_title:gsub('%s+', '-'):gsub('[^%w%-]', ''))
  cmd = { 'gh', 'issue', 'develop', issue_number, '--branch', branch_name, '--checkout', '--base', 'main' }
  obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify(string.format('Error creating branch: %s', obj.stderr), vim.log.levels.ERROR)
    vim.print(obj.stderr)
    return
  end
  vim.notify(string.format('%s created', vim.trim(obj.stdout)), vim.log.levels.INFO)
end

M.gitCommitAll = function()
  vim.ui.input({ prompt = 'Enter commit message: ' }, function(input)
    if input == nil or input == '' then
      vim.notify('Commit message cannot be empty.', vim.log.levels.WARN)
      return
    end
    show.task('GitCommit', { 'git', 'commit', '-am', input })
  end)
end

M.gitPush = function()
  show.shell('Repo', 'git push')
end

M.gitPushForce = function()
  show.shell('Repo', 'git push --force')
end

--[[ labels management functions here ]] --
-- use show module to display labels in show window,
-- maybe with some color coding based on label type
M.viewLabels = function()
  local cmd = { 'gh', 'issue', 'view', '--json', 'labels', '--jq', '.labels[].name' }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error fetching labels: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  local data = vim.split(obj.stdout, '\n')
  show.scratch('Labels', data)
end

--[[
CRUD operations for GitHub issues
 - list issues
 - create issue with title and body, maybe also with labels and assignees
 - view:  issue details in a show window,
-  update: edit the issue in show window and save changes
 - delete: close issue
--]] --

M.issueList = function()
  show = require('show')
  show.shell('Git', 'gh issue list')
end
---
M.issueCreate = function()
  local ok, msg, prompt, select
  -- step 1: select issue type from a list of options
  select = { 'fix', 'feat', 'chore', 'docs' }
  prompt = 'Select issue type: '
  local issue = {}
  vim.ui.select(select, { prompt = prompt }, function(choice)
    if not choice then return end
    issue['type'] = choice
  end)
  -- step 2: enter issue title, with the issue type as a prefix to the title, e.g. "fix: add login feature"
  prompt = string.format('Enter a short title for %s : ', issue['type'])
  vim.ui.input({ prompt = prompt }, function(input)
    if not input or input == '' then
      vim.notify(string.format('%s title cannot be empty', issue['type']), vim.log.levels.WARN)
      return
    end
    issue['title'] = input
  end)
  -- Step 3: Collect checkbox list items
  local tasks = {}
  prompt = 'Add a task for the issue (empty to finish): '
  local function prompt_task()
    vim.ui.input(
      { prompt = prompt },
      function(task)
        if not task or task == '' then
          -- Assemble and create issue
          if #tasks == 0 then
            vim.notify('No tasks added, aborting issue creation', vim.log.levels.WARN)
            return
          end
          local title = string.format('%s: %s', issue['type'], issue['title'])
          local task_list = vim.tbl_map(function(t) return '- [ ] ' .. t end, tasks)
          -- convert task list to a string with newlines between each task
          ok, msg = createRemote('issue', title, table.concat(task_list, '\n'))
          if not ok then
            vim.notify(msg, vim.log.levels.ERROR)
            return
          else
            vim.notify(msg, vim.log.levels.INFO)
          end
          M.issueView() -- open the issue view for the newly created issue
        else
          -- Add task and prompt for another
          table.insert(tasks, task)
          prompt_task()
        end
      end
    )
  end
  -- call recursive function to prompt for tasks until the user enters an empty string
  prompt_task()
end

M.issueDevelopList = function()
  local issue_number, msg = get_latest('issue')
  if issue_number == 0 then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end
  local cmd = { 'gh', 'issue', 'develop', issue_number, '--list' }
  show.shell('BranchesInDevelopment', cmd)
  -- local obj = vim.system(cmd):wait()
  -- if obj.code ~= 0 then
  --   vim.notify('Error fetching issues in development: ' .. obj.stderr, vim.log.levels.ERROR)
  --   return
  -- end
end

--[[ issue view:  fetch the latest issue using the GitHub CLI, then display the title and body in a show window, with the title as the first line and the body as the rest of the lines,
 - the issue view is displyed in a show.edit window
   as such we provide buffer specific keymaps and commands to interact with the issue,
   keymap: <C-s> save buffer modification to GitHub using the GitHub CLI
   commands:
    - CreateBranch to create a branch from the current issue using the GitHub CLI
    - CreatePullRequestCreate to create a pull request from the current issue using the GitHub CLI
  ]]

M.issueView = function()
  local issue_number, msg = get_latest('issue')
  if issue_number == 0 then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end
  local data = get_remote_view_data('issue', issue_number)
  local bufnr = show.edit('IssueView', data)
  if bufnr == 0 then
    vim.notify('Error creating buffer for issue view', vim.log.levels.ERROR)
    return
  end
  --[[  set buffer specific commands, keymaps, autocommands ]] --
  -- update issue with <C-s> keymap, which will save the changes to GitHub using the GitHub CLI, we can also add a command to save the changes, but I think the keymap is more convenient for this use case
  local km1 = { 'n', '<C-s>', function() update_view('issue') end, 'Save to GitHub' }
  -- vim.print(string.format('Repo: setting up keymaps for issue view buffer %d', bufnr))
  set_keymaps({ km1 }, bufnr)
  local cmd = { 'git', 'branch', '--show-current' }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error fetching current branch: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  local current_branch = vim.trim(obj.stdout)
  --[[
  - if on main then provide a Branch create command
  - if on a feature branch then provide a Pull request create command,
  since it's more likely that the user wants to create a pull request
  from a feature branch rather than creating another branch from a feature branch
  --]] --
  --
  set_commands({
    'IssueCommentCreate', -- issueCommentCreate
  }, bufnr)

  if current_branch ~= 'main' then
    set_commands({
      'PullRequestCreate', --  pullRequestCreate
    }, bufnr)
  else
    set_commands({
      'IssueDevelopWithBranch', --  issueDevelopWithBranch
    }, bufnr)
  end
end

-- Branches management functions here
-- you can add functions here to create, view, and manage branch
--- use git to list branches and show them in a show window, maybe with some color coding based on branch type (e.g. feature, bugfix, etc.)
M.branchRemotesList = function()
  show.shell('GitHub', 'git remote -v')
end

--[[ Pull request management functions here ]] --
-- you can add functions here to create, view, and manage pull requests using the GitHub CLI and the show module
M.pullRequestList = function()
  show.shell('GitHub', 'gh pr list')
end

-- pull request view:  fetch the latest pull request using the GitHub CLI, then display the title and body in a show window, with the title as the first line and the body as the rest of the lines,
M.pullRequestView = function()
  local pr_number, msg = get_latest('pr')
  if pr_number == 0 then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end
  local data = get_remote_view_data('pr', pr_number)
  local bufnr = show.edit('PullRequestView', data)
  if bufnr == 0 then
    vim.notify('Error creating buffer for pull request view', vim.log.levels.ERROR)
    return
  end
  local km1 = { 'n', '<C-s>', function() update_view('pr') end, 'Save to GitHub' }
  set_keymaps({ km1 }, bufnr)
  set_commands({
    'PullRequestUpdate',        -- pullRequestUpdate
    'PullRequestCommentCreate', --  pullRequestCommentCreate
    'PullRequestMerge',         -- pullRequestMerge
  }, bufnr)
end

M.pullRequestStatus = function()
  -- TODO
  show.shell('GitHub', 'gh pr list')
end

M.pullRequestCreate = function()
  vim.print('Repo: creating pull request')
  local ok, msg, cmd, obj, issue_number, pr_number, title, body,
  ok, msg = auto_commit_push('creating pull request')
  if not ok then
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end
  issue_number, msg = get_latest('issue')
  if issue_number == 0 then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end
  title, body = get_local_view_data(vim.api.nvim_get_current_buf())
  if title == '' then
    vim.notify('Pull request title cannot be empty', vim.log.levels.WARN)
    return
  end
  if body == '' then
    vim.notify('Pull request body cannot be empty', vim.log.levels.WARN)
    return
  end
  ok, msg = createRemote('pr', title, body)
  if not ok then
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end
  vim.notify(msg, vim.log.levels.INFO)
  pr_number, msg = get_latest('pr')
  if pr_number == 0 then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end
  cmd = { 'gh', 'pr', 'view', tostring(pr_number), '--json', 'url', '--template', '{{.url}}' }
  obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error fetching pull request URL: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  local pr_url = vim.trim(obj.stdout)
  comment_send('pr', pr_number, string.format('Pull request created: %s', pr_url))
  -- show the pull request view after creating the pull request,
  local data = get_remote_view_data('pr', pr_number)
  local bufnr = show.edit('PullRequestView', data)
  if bufnr == 0 then
    vim.notify('Error creating buffer for issue view', vim.log.levels.ERROR)
    return
  end
  vim.notify(string.format('Opened pull request view in buffer #%d', bufnr), vim.log.levels.INFO)
end


M.issueCommentCreate = function()
  comment_create('issue')
end

M.pullRequestUpdate = function()
  update_view('pr')
end

M.pullRequestCommentCreate = function()
  comment_create('pr')
end

M.pullRequestMerge = function()
  -- Step 1: auto commit and push any changes before merging
  local ok, msg, pr_number, title, body
  ok, msg = auto_commit_push('merging pull request')
  if not ok then
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end
  vim.notify(msg, vim.log.levels.INFO)
  -- Step 2: get the latest pull request number using the GitHub CLI, and use the pull request title and body to create a merge commit message for the merge commit that will be created when merging the pull request, we can also use the title and body to update the pull request before merging, to ensure the pull request has the latest title and body before merging
  pr_number, msg = get_latest('pr')
  if pr_number == 0 then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end
  title, body = get_local_view_data(vim.api.nvim_get_current_buf())
  if title == '' then
    vim.notify('Pull request title cannot be empty', vim.log.levels.WARN)
    return
  end
  if body == '' then
    vim.notify('Pull request body cannot be empty', vim.log.levels.WARN)
    return
  end
  ok, msg = edit_remote_view('pr', pr_number, title, body)
  if not ok then
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end
  -- Step 3: use the GitHub CLI to merge the pull request
  local subject = string.format('pr merged #closes %d', pr_number)
  local cmd = {
    'gh', 'pr', 'merge', tostring(pr_number), '--squash', '--delete-branch', '--body', body, '--subject', subject
  }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error merging pull request: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  vim.notify('Pull request merged successfully', vim.log.levels.INFO)
  -- step 4: after merging the pull request, we can also close the related issue if there is one, since the pull request has been merged and the issue has been resolved, we can close the issue with a comment indicating that it has been resolved by the pull request
  local issue_number
  issue_number, msg = get_latest('issue')
  if issue_number == 0 then
    vim.notify(msg, vim.log.levels.WARN)
    return
  end
  local comment = 'Closing issue as it has been resolved by pull request #' ..
      pr_number .. ' which has been merged successfully.'
  local reason = 'completed'
  issue_close(issue_number, comment, reason)
  -- step 5: switch to main branch after merging, since the pull request branch has been merged and deleted, we can switch back to main to continue working from there
  local checkout_cmd = { 'git', 'switch', 'main' }
  obj = vim.system(checkout_cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error checking out main branch: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  vim.notify('Checked out main branch successfully', vim.log.levels.INFO)
  -- step 6: on main branch, we can also pull the latest changes to ensure we have the latest code after the merge
  -- this is especially important if the user was on the pull request branch before merging, since that branch has now been merged and deleted, we want to make sure they are on the latest code on main after the merge
  local pull_cmd = { 'git', 'pull' }
  obj = vim.system(pull_cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error pulling latest changes on main branch: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  vim.notify('Pulled latest changes on main branch successfully', vim.log.levels.INFO)
  -- step 7: make sure open files are refreshed after the merge, since the merge may have changed or deleted files that are currently open in the editor, we want to make sure those buffers are refreshed to reflect the latest state of the repository after the merge
  vim.cmd('checktime')
  -- step 8: status update after merging, to show the latest status of the repository after the merge, including any changes that were pulled on main after the merge
  M.status()
  --TODO the bufEditIssueView and bufEditPullRequestView buffers can be deleted after merging, since the issue and pull request have been resolved and merged, we can close those buffers to clean up the workspace after the merge
end



return M
