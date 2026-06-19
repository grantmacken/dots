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

--[[ section:  private local functions here ]] --
-- add any helper functions here that are not exposed as part of the module's public API
-- these functions can be used internally by the public functions defined below
-- deps:  this module dependencies
local show = require('show')

--- align issue with some conventional commits
-- local issue_types = { 'fix', 'feature', 'refactor', 'chore', 'docs' }

-- each command is a string with the format "IssueCommandName"
local commands = {
  'RepoBranchList',      --  branchList
  'RepoIssueList',       --  issueList
  'RepoIssueView',       -- issueView
  'RepoPullRequestList', -- pullRequestList
  -- 'RepoViewLabels',    -- viewLabels
  'RepoWorkflowRun',     -- workflowRun
  'RepoWorkflowView',    -- workflowView
  'RepoGitPush',         -- gitPush
  'RepoGitStatus',       -- gitStatus
  'RepoGhHelp',          -- ghHelp
  --'RepoIssueCreate', -- issueCreate
}
-- each keymap is a table with the format { mode, lhs, rhs, desc }
local keymaps = {
  { 'n', '<leader>ric', ':RepoIssueCreate<CR>', 'Create a new GitHub issue' },
}

local autocmds = {
  -- add autocmds here if needed
}

M.setup = function()
  --[[ Command conventions: begin with this module name: `repo` with  first letter uppercase, then more context:  e.g. "RepoIssueCreate"
     - the function to call is the substring after "Repo", with the first letter lowercased e.g. "RepoIssueCreate" -> "issueCreate"
     - the description for the command is the cmd  split into words, e.g. "RepoIssueCreate" -> "Repo Issue Create"
     - the spliting function call is cmd:gsub("%u", " %0"):gsub("^%s+", "")
     ]]
  for _, cmd in ipairs(commands) do
    local func = cmd:sub(5, 5):lower() ..
        cmd:sub(6) -- get the function name by removing "Repo" prefix and lowercasing first letter
    -- vim.notify('Repo: setting up command ' .. cmd .. ' to call function ' .. func)
    local description = cmd:gsub("%u", " %0"):gsub("^%s+", "")
    if M[func] then
      vim.api.nvim_create_user_command(cmd, function(opts) M[func](opts) end, { desc = description })
    else
      vim.notify('Repo: no function found for command ' .. cmd, vim.log.levels.WARN)
    end
  end
  -- keymaps are defined as tables in the `keymaps` table, with the format { mode, lhs, rhs, desc }
  for _, keymap in ipairs(keymaps) do
    -- keymap is a table with the format { mode, lhs, rhs, desc }
    vim.keymap.set(keymap[1], keymap[2], keymap[3], { desc = keymap[4] })
  end
  -- autocmds are defined as tables in the `autocmds` table, with the format { event, pattern, group, callback, desc }
  for _, autocmd in ipairs(autocmds) do
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = autocmd.group,
      pattern = autocmd.pattern,
      callback = autocmd.callback,
      desc = autocmd.desc,
    })
  end
  vim.notify('Repo module setup complete')
end





--- helper function to get the latest issue number using the GitHub CLI
--- @return number the latest issue number, or 0 if there was an error
local get_latest_issue_number = function()
  -- get the latest issue number
  local cmd = { 'gh', 'issue', 'list', '--limit', '1', '--json', 'number', '--jq', ".[0].number" }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error fetching issue: ' .. obj.stderr, vim.log.levels.ERROR)
    return 0
  end
  local int = vim.trim(obj.stdout)
  return tonumber(int)
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
M.gitStatus = function()
  show.shell('Repo', 'git -c "color.status=always" status --short --branch')
end

M.branchList = function()
  show.shell({ 'Repo', 'git branch -vv' })
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

--[[ issues management functions here ]] --

M.issueList = function()
  show = require('show')
  show.shell('Git', 'gh issue list')
end

--[[ issue view:  fetch the latest issue using the GitHub CLI, then display the title and body in a show window, with the title as the first line and the body as the rest of the lines,
 - the issue view is dispalyed in a bufEdit window
   as such we provide buffer specific keymaps and commands to interact with the issue,
   keymap: <C-s> save buffer modification to GitHub using the GitHub CLI
   command: CreatePullRequestCreateFromIssue to create a pull request from the current issue using the GitHub CLI
  ]]

M.issueView = function()
  local int = get_latest_issue_number()
  if int == 0 then
    vim.notify('No issues found or error fetching issues', vim.log.levels.WARN)
    return
  end
  local data = vim.fn.systemlist('gh issue view ' .. int .. ' --json title --template {{.title}}')
  -- the title is the first line of the buffer, and the body is everything after the first line
  -- add a blank line between the title and the body for better readability
  table.insert(data, '') -- add a blank line between title and body
  local body = vim.fn.systemlist('gh issue view ' .. int .. ' --json body --template {{.body}}')
  vim.list_extend(data, body)
  -- data is now a list of lines
  show.edit('IssueView', data)
  local bufnr = show.get_bufnr_by_name('bufEditIssueView')
  if bufnr == 0 then
    vim.notify('Error creating buffer for issue view', vim.log.levels.ERROR)
    return
  end
  vim.notify('CTRL + s : to save issue to github', vim.log.levels.INFO)
  -- vim.api.nvim_buf_set_option(bufnr, 'filetype', 'markdown')
  local mode, rhs, lhs, opt
  opt = { buffer = bufnr, desc = 'Save to github' }
  mode = 'n'
  -- push to github us control + s in normal mode, maybe also in insert mode
  lhs = '<C-s>'
  rhs = function()
    local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    -- The title is on the first line, and the body is everything after the first line
    local title = content[1] or ''
    -- remove any markdown formatting from the title, e.g. if the title is "# Issue Title" we want to remove the "# " part
    title = title:gsub('^#%s*', '')
    -- the body is everything after the first line, joined together with newlines
    -- trim any leading or trailing whitespace from the body
    local body = table.concat(vim.list_slice(content, 2), '\n')
    body = body:gsub('^%s+', ''):gsub('%s+$', '')
    vim.notify('Saving issue #' .. int .. ' with title: ' .. title, vim.log.levels.INFO)
    vim.notify(body, vim.log.levels.INFO)
    local cmd = { 'gh', 'issue', 'edit', tostring(int), '--title', title, '--body', body }
    local obj = vim.system(cmd):wait()
    if obj.code ~= 0 then
      vim.notify('Error saving issue: ' .. obj.stderr, vim.log.levels.ERROR)
    else
      vim.notify('Issue saved successfully', vim.log.levels.INFO)
    end
    --use vim.system to run the command in async just notify if there was an error or if it was successful
    -- we can also use the on_exit callback to notify when the command is done
    -- use vim defer_fn to defer the notification until after the command is done, since vim.system runs asynchronously
    -- vim.system(cmd, {
    --   on_exit = function(obj)
    --     if obj.code ~= 0 then
    --       vim.defer_fn(function()
    --         vim.notify('Error saving issue: ' .. obj.stderr, vim.log.levels.ERROR)
    --       end, 100) -- defer the notification by 100ms to ensure it happens after the command is done
    --     else
    --       vim.defer_fn(function()
    --         vim.notify('Issue saved successfully', vim.log.levels.INFO)
    --       end, 100) -- defer the notification by 100ms to ensure it happens after the command is done
    --     end
    --   end,
    -- })
  end
  vim.keymap.set(mode, lhs, rhs, opt)
  cmd = 'CreatePullRequestCreateFromIssue'
  func = 'createPullRequestCreateFromIssue'
  description = 'Create a pull request from the current issue'
  vim.api.nvim_buf_create_user_command(bufnr, cmd, function(int) M[func](int) end, { desc = description })
end

M.createPullRequestCreateFromIssue = function(int)
  local int = get_latest_issue_number()
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

--- CRUD operations for GitHub issues
M.createIssue = function()
  -- Step 1: Select issue type
  local labels = require('issues').types
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
                  local body = table.concat(vim.tbl_map(function(t)
                    return '- [ ] ' .. t
                  end, tasks), '\n')
                  local show = require('show')
                  -- Create git branch with hyphenated title
                  --local branch_name = title:lower():gsub('%s+', '-'):gsub('[^%w%-]', '')
                  -- Create GitHub issue
                  local prefixed_title = string.format('[%s] %s', issue_type, title)
                  local args = { 'gh', 'issue', 'create', '--title', '"' .. prefixed_title .. '"', '--body', '"' ..
                  body .. '"' }
                  show.shell('IssueCreate', table.concat(args, ' '))
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
