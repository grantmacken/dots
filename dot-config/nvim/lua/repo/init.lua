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
      -- BranchCreate  branchCreate
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
    'RepoIssueList',       -- issueList
    'RepoIssueCreate',     -- issueCreate
    'RepoIssueView',       -- issueView
    'RepoPullRequestList', -- pullRequestList
    -- 'RepoViewLabels',    -- viewLabels
    'RepoWorkflowRun',     -- workflowRun
    'RepoWorkflowView',    -- workflowView
    'RepoGitPush',         -- gitPush
    'RepoStatus',          -- status
    'RepoGhHelp',          -- ghHelp
    'RepoGitCommitAll',    -- gitCommitAll
  })

  set_keymaps({
    { 'n', '<leader>ric', ':RepoIssueCreate<CR>', 'Create a new GitHub issue' }
  })

  set_autocmds({
    -- add any autocmds here if needed, e.g. to refresh issue list after creating a new issue, or to update the status of an issue when the buffer is written, etc.
  })
  vim.notify('Repo module setup complete')
end

--- helper function to get the latest issue or pull request number using the GitHub CLI
--- @param what string the type of item to fetch, either "issue" or "pr"
--- @return number : the latest issue or pull request number, or 0 if there was an error
local get_latest = function(what)
  local cmd = { 'gh', what, 'list', '--limit', '1', '--json', 'number', '--jq', ".[0].number" }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error fetching issue: ' .. obj.stderr, vim.log.levels.ERROR)
    return 0
  end
  -- stdout of the command should be the number of the latest issue or pull request, we can trim it and convert it to a number
  local int = vim.trim(obj.stdout)
  local ok, num = pcall(tonumber, int)
  if not ok then
    vim.notify('Error converting issue number to a number: ' .. int, vim.log.levels.ERROR)
    return 0
  else
    vim.notify('Latest ' .. what .. ' number: ' .. num, vim.log.levels.INFO)
    return num or 0
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
  local msg = ''
  local cmd = { 'gh', what, 'edit', tostring(int), '--title', title, '--body', body }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    msg = string.format('Error saving %s: %s', what, obj.stderr)
  else
    msg = string.format('%s saved successfully', what)
  end
  return true, msg
end


--[[ section:  public functions here ]] --
-- add any functions here that are exposed as part of the module's public API
--
--
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

M.branchCreate = function()
  --[[
  BranchCreate available in the issue view buffer
  Steps:
   1. commit and push all changes first, to ensure the branch is created from the latest commit on the current branch
   2. get the latest issue number using the GitHub CLI, and use the issue title and body to create a new branch name and description for the branch
   3, name issue with naming convention -- issue-issue_number-issue-title, e.g. "issue-123-add-login-feature"
   4. create branch using to create a new branch from the current branch, with the name and description derived from the issue
   5. if branch creation is successful, we can also add a comment to the issue with the link to the branch
  ]] --
  -- vimvim.print('Repo: creating branch' .. bufnr)
  local cmd = { 'git', 'commit', '-am', 'Auto commit before creating branch' }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error committing changes: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  vim.notify('Changes committed successfully, now pushing to remote...')
  cmd = { 'git', 'push' }
  obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error pushing changes: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  local issue_number = get_latest('issue')
  if issue_number == 0 then
    vim.notify('No issues found or error fetching issues', vim.log.levels.WARN)
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  vim.notify('Repo: creating branch from issue view buffer ' .. bufnr, vim.log.levels.INFO)
  local edit_title, _ = get_local_view_data(bufnr)
  local branch_name = string.format('%s-%d-%s', 'issue', issue_number, edit_title:gsub('%s+', '-'):gsub('[^%w%-]', ''))
  cmd = { 'git', 'checkout', '-b', branch_name }
  obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error creating branch: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  vim.notify('Branch ' .. branch_name .. ' created successfully', vim.log.levels.INFO)
  -- push the branch to remote
  cmd = { 'git', 'push', '-u', 'origin', branch_name }
  obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error pushing branch to remote: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  vim.notify('Branch ' .. branch_name .. ' pushed to remote successfully', vim.log.levels.INFO)
end

M.pullRequestCreate = function()
  vim.print('Repo: creating pull request')
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
  -- Step 1: Select issue type
  local labels = { 'fix', 'feat', 'refact', 'chore', 'docs' }
  vim.ui.select(
    labels,
    { prompt = 'Select issue type:' },
    function(issue_type)
      if not issue_type then return end
      -- Step 2: Get issue title
      vim.ui.input(
        { prompt = 'Issue title: ' },
        function(title)
          if not title or title == '' then return end
          -- Step 3: Collect checkbox list items
          local tasks = {}
          local function prompt_task()
            vim.ui.input(
              { prompt = 'Add task (empty to finish): ' },
              function(task)
                if not task or task == '' then
                  -- Assemble and create issue
                  if #tasks == 0 then
                    vim.notify('No tasks added, aborting issue creation', vim.log.levels.WARN)
                    return
                  end
                  local data = {}
                  table.insert(data, string.format(' %s: %s', issue_type, title)) -- Title as markdown header
                  table.insert(data, '')                                          -- add a blank line between title and body
                  local body = vim.tbl_map(
                    function(t)
                      return '- [ ] ' .. t
                    end, tasks)
                  vim.list_extend(data, body)
                  vim.print(data)
                  local bufnr = show.edit('IssueCreated', data)
                  if bufnr == 0 then
                    vim.notify('Error creating buffer for issue creation', vim.log.levels.ERROR)
                    return
                  end
                  local opt = { buffer = bufnr, desc = 'Save to github' }
                  local keybinds = {
                    { 'n', '<C-s>', function()
                      local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                      local title = content[1] or ''
                      title = title:gsub('^%s*%w+:%s*', '')                       -- remove issue type prefix from title
                      local body = table.concat(vim.list_slice(content, 3), '\n') -- skip title and blank line
                      body = body:gsub('^%s+', ''):gsub('%s+$', '')
                      vim.notify('Saving issue with title: ' .. title, vim.log.levels.INFO)
                      local cmd = { 'gh', 'issue', 'create', '--title', title, '--body', body }
                      local obj = vim.system(cmd):wait()
                      if obj.code ~= 0 then
                        vim.notify('Error creating issue: ' .. obj.stderr, vim.log.levels.ERROR)
                      else
                        vim.notify('Issue created successfully', vim.log.levels.INFO)
                      end
                    end, opt },
                    { 'i', '<C-s>', function()
                      local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                      local title = content[1] or ''
                      title = title:gsub('^%s*%w+:%s*', '')                       -- remove issue type prefix from title
                      local body = table.concat(vim.list_slice(content, 3), '\n') -- skip title and blank line
                      body = body:gsub('^%s+', ''):gsub('%s+$', '')
                      vim.notify('Saving issue with title: ' .. title, vim.log.levels.INFO)
                      local cmd = { 'gh', 'issue', 'create', '--title', title, '--body', body }
                      local obj = vim.system(cmd):wait()
                      if obj.code ~= 0 then
                        vim.notify('Error creating issue: ' .. obj.stderr, vim.log.levels.ERROR)
                      else
                        vim.notify('Issue created successfully', vim.log.levels.INFO)
                      end
                    end, opt },
                  }
                else
                  -- Add task and prompt for another
                  table.insert(tasks, task)
                  prompt_task()
                end
              end
            )
          end
          prompt_task()
        end
      )
    end
  )
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
  local int = get_latest('issue')
  if int == 0 then
    vim.notify('No issues found or error fetching issues', vim.log.levels.WARN)
    return
  end
  local data = get_remote_view_data('issue', int)
  local bufnr = show.edit('IssueView', data)
  if bufnr == 0 then
    vim.notify('Error creating buffer for issue view', vim.log.levels.ERROR)
    return
  end
  --[[  set buffer specific commands, keymaps, autocommands ]] --
  local km1 = { 'n', '<C-s>', function()
    local edit_title, edit_body = get_local_view_data(bufnr)
    local ok, msg = edit_remote_view('issue', int, edit_title, edit_body)
    if ok then
      vim.notify(msg, vim.log.levels.INFO)
    else
      vim.notify(msg, vim.log.levels.ERROR)
    end
  end,
    'Save to GitHub' }
  vim.print(string.format('Repo: setting up keymaps for issue view buffer %d', bufnr))
  set_keymaps({ km1 }, bufnr)
  set_commands({         -- GIT BRANCHES
    'BranchCreate',      --  branchCreate
    'PullRequestCreate', --  pullRequestCreate
  }, bufnr)
end

--[[
  cmd = 'CreatePullRequest'
  func = 'createPullRequestCreateFromIssue'
  description = 'Create a pull request from the current issue'
  vim.api.nvim_buf_create_user_command(bufnr, cmd, function(int) M[func](int) end, { desc = description })
  ]] --

M.createPullRequestCreateFromIssue = function(int)
  int = get_latest('issue')
  if int == 0 then
    vim.notify('No issues found or error fetching issues', vim.log.levels.WARN)
    return
  end
  local title = vim.fn.system('gh issue view ' .. int .. ' --json title --template {{.title}}')
  local body = vim.fn.system('gh issue view ' .. int .. ' --json body --template {{.body}}')
  local cmd = { 'gh', 'pr', 'create', '--title', title, '--body', body }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error creating pull request: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end
  -- stdout of the command should contain the URL of the created pull request, we can extract it using a simple pattern match
  local pr_url = vim.trim(obj.stdout)

  -- we can now also add a comment to the issue with the link to the pull request, but we would need to get the URL of the pull request from the output of the command,
  -- which is a bit more complicated since the output is not just the URL but also some other information about the pull request
  local comment = 'Closed in favor of PR ' .. pr_url
  cmd = { 'gh', 'issue', 'close', int, '--comment', comment }
  obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error closing issue: ' .. obj.stderr, vim.log.levels.ERROR)
    return
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

-- M.pullRequestCreate = function()
--   local obj, cmd, int
--   -- commit and push all changes first
--   cmd = { 'git', 'commit', '-am', 'Auto commit before creating PR' }
--   obj = vim.system(cmd):wait()
--   if obj.code ~= 0 then
--     vim.notify('Error committing changes: ' .. obj.stderr, vim.log.levels.ERROR)
--     return
--   end
--   vim.notify('Changes committed successfully, now pushing to remote...')
--   cmd = { 'git', 'push' }
--   obj = vim.system(cmd):wait()
--   if obj.code ~= 0 then
--     vim.notify('Error pushing changes: ' .. obj.stderr, vim.log.levels.ERROR)
--     return
--   end
--   vim.notify('Changes pushed successfully, now creating pull request...')
--   -- get the latest issue number
--   cmd = { 'gh', 'issue', 'list', '--limit', '1', '--json', 'number', '--jq', ".[0].number" }
--   obj = vim.system(cmd):wait()
--   if obj.code ~= 0 then
--     vim.notify('Error fetching issue: ' .. obj.stderr, vim.log.levels.ERROR)
--     vim.notify('Create An issue before creation pull request: ' .. obj.stderr, vim.log.levels.WARN)
--     return
--   end
--   int = vim.trim(obj.stdout)
--   vim.notify('Fetching issue #' .. int .. ' to use as pull request title and body...')
--   cmd = { 'gh', 'issue', 'view', int, '--json', 'title', '--template', '{{.title}}' }
--   obj = vim.system(cmd):wait()
--   if obj.code ~= 0 then
--     vim.notify('Error fetching issue title: ' .. obj.stderr, vim.log.levels.ERROR)
--     return
--   end
--   local title = vim.trim(obj.stdout)
--   cmd = { 'gh', 'issue', 'view', int, '--json', 'body', '--template', '{{.body}}' }
--   obj = vim.system(cmd):wait()
--   if obj.code ~= 0 then
--     vim.notify('Error fetching issue body: ' .. obj.stderr, vim.log.levels.ERROR)
--     return
--   end
--   local body = vim.trim(obj.stdout)
--   cmd = { 'gh', 'pr', 'create', '--title', title, '--body', body }
--   obj = vim.system(cmd):wait()
--   if obj.code ~= 0 then
--     vim.notify('Error creating pull request: ' .. obj.stderr, vim.log.levels.ERROR)
--     return
--   end
--   vim.notify('Created PR with title: ' .. title, vim.log.levels.INFO)
-- end

return M
