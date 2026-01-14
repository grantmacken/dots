--[[
 working with git using the show module
 - git status
 - git commit
   - using vim.ui.prompt
 - git add --all
 - git push
 - git forced push
working with github using the show module
 - repo view
 - issue create:
   a short descriptive tile
   a checkbox list for issue body
   tasks:
   - vim.ui.select to choose choose issue type (bug, feature, enhancement, question)
   - vim.ui.prompt to establish issue title
   - vim.ui.prompt to establish checkbox list entry for issue body
   - For each checkbox list entry, prompt the user if they want to add another entry until they say no
   - finally, assemble the issue body from the checkbox list and send gh issue create as a task to terminal buffer
 - issue list:
 - issue view <number>
 - issue edit <number>:


 - gh pr view <number>
 - gh pr list
 - gh pr create
 - gh pr checkout <number>
 - gh pr status
 - gh issue create
 - gh issue status
]] --

vim.api.nvim_create_user_command(
  'GitAddAll',
  function()
    local show = require('show')
    show.task('GitAddAll', { 'git', 'add', '--all', })
    show.task('GitStatusAfterAdd', { 'git', '-c', 'color.status=always', 'status', '--short', '--branch' })
  end,
  { desc = 'Send git add --all as a task to terminal buffer' }
)

--[[ git commit with message from vim.ui.input
]] --

vim.api.nvim_create_user_command(
  'GitCommitMessage',
  function()
    vim.ui.input({ prompt = 'Enter commit message: ' }, function(input)
      if input == nil or input == '' then
        vim.notify('Commit message cannot be empty.', vim.log.levels.WARN)
        return
      end
      local tbl = { 'git', 'commit', '-am', input }
      -- vim.print(tbl)
      local show = require('show')
      show.task('GitCommit', tbl)
    end)
  end,
  { desc = 'Prompt for commit message and send git commit as a task to terminal buffer' }
)


vim.api.nvim_create_user_command(
  'GitStatus',
  function()
    local show = require('show')
    show.task('GitStatus', { 'clear' })
    show.task('GitStatus', { 'git', '-c', 'color.status=always', 'status', '--short', '--branch' })
  end,
  { desc = 'Send git status a task to terminal buffer' }
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

vim.api.nvim_create_user_command(
  'GitPush',
  function()
    local show = require('show')
    show.shell('GitPush', 'git push')
  end,
  { desc = 'git push' }
)


vim.api.nvim_create_user_command(
  'GitForcePush',
  function()
    local show = require('show')
    show.shell('GitForcePush', 'git push --force')
  end,
  { desc = 'git forced push' }
)


--[[ ISSUES:
   gh issue list
   gh issue view <number>
   gh issue edit <number>
]] --


vim.api.nvim_create_user_command(
  'IssuesList',
  function()
    local show = require('show')
    show.shell('GitHub', 'gh issue list')
  end,
  { desc = 'gh issue list' }
)

-- vim.api.nvim_create_user_command(
--   'GitHubIssueEdit',
--   function()
--     local show = require('show')
--     show.shell('GitHub', 'gh issue create --edit --a @me')
--   end,
--   { desc = 'gh issue create --editor --a @me' }
-- )

--[[ branch create:
   create git branch from issue title
   hyphenate title and lowercase
]] --
-- vim.api.nvim_create_user_command(
--   'Gissue',
--   function(opts)
--     local input = opts.args
--     if input == nil or input == '' then
--       vim.notify('Issue name cannot be empty.', vim.log.levels.WARN)
--       return
--     end
--     local issue = input:lower():gsub('%s+', '-'):gsub('[^%w%-]', '')
--     vim.notify('Creating branch for issue: ' .. issue, vim.log.levels.INFO)
--   end,
--   { desc = 'Create issue', nargs = 1 }
-- )

--[[ issue create:
   a short descriptive tile
   a checkbox list for issue body
   tasks:
   - vim.ui.select to choose choose issue type (bug, enhancement )
   - vim.ui.prompt to establish issue title
   - vim.ui.prompt to establish checkbox list entry for issue body
   - For each checkbox list entry, prompt the user if they want to add another entry until they say no
   - finally, assemble the issue body from the checkbox list and send gh issue create as a task to terminal buffer
]] --

vim.api.nvim_create_user_command(
  'IssueCreate',
  function()
    -- Step 1: Select issue type
    vim.ui.select(
      { 'fix', 'enhancement' },
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
                    local branch_name = title:lower():gsub('%s+', '-'):gsub('[^%w%-]', '')
                    -- Create GitHub issue
                    local args = { 'gh', 'issue', 'create', '--title', '"' .. title .. '"', '--body', '"' .. body .. '"' }
                    if issue_type then
                      table.insert(args, '--label')
                      table.insert(args, '"' .. issue_type .. '"')
                    end
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
  end,
  { desc = 'Create GitHub issue with checkbox list' }
)

--[[ issue view <number>:
]] --

vim.api.nvim_create_user_command(
  'GitHubIssueView',
  function(opts)
    local name = 'GitHubIssueView'
    local issue_number = opts.args
    if issue_number == nil or issue_number == '' then
      vim.notify('Issue number cannot be empty.', vim.log.levels.WARN)
      return
    end
    local show = require('show')
    show.shell(name, 'gh issue view ' .. issue_number)
  end,
  { desc = 'gh issue view <number>', nargs = 1 }
)

-- Get issue body for a given issue number
-- show in scratch buffer
--
---
vim.api.nvim_create_user_command(
  'IssueFocus',
  function()
    local showBuf  = 'bufEdit'
    local showWhat = 'IssueBody'
    local showName = showBuf .. showWhat
    local show     = require('show')
    local focus    = show.win_is_focused()
    vim.print(vim.inspect(focus))
    local bufnr = show.get_bufnr_by_name(showName)
    vim.print(bufnr)
  end,
  { desc = 'An example action that shows output in a edit buffer' }
)

vim.api.nvim_create_user_command(
  'IssueBlur',
  function()
    local showBuf  = 'bufEdit'
    local showWhat = 'IssueBody'
    local showName = showBuf .. showWhat
    local show     = require('show')
    vim.print(vim.t[showName])
    local bufnr = show.get_bufnr_by_name(showName)
    vim.print(bufnr)
  end,
  { desc = 'An example action that shows output in a edit buffer' }
)

vim.api.nvim_create_user_command(
  'IssuePushToGitHub',
  function()
    local showBuf  = 'bufEdit'
    local showWhat = 'IssueBody'
    local showName = showBuf .. showWhat
    local show     = require('show')
    vim.print(vim.t[showName])
    local bufnr = show.get_bufnr_by_name(showName)
    vim.print(bufnr)
  end,
  { desc = 'An example action that shows output in a edit buffer' }
)
vim.api.nvim_create_user_command(
  'IssuePullFromGitHub',
  function()
    local showBuf  = 'bufEdit'
    local showWhat = 'IssueBody'
    local showName = showBuf .. showWhat
    local show     = require('show')
    vim.print(vim.t[showName])
    local bufnr = show.get_bufnr_by_name(showName)
    vim.print(bufnr)
  end,
  { desc = 'An example action that shows output in a edit buffer' }
)




-- gh pr create \
--title "$(gh issue view $ISSUE_ID --json title -q .title)" \
--body "$(gh issue view $ISSUE_ID --json body -q .body)"

vim.api.nvim_create_user_command(
  'IssueView',
  function()
    local bufName = 'IssueBody'
    -- get the latest issue number
    local cmd = { 'gh', 'issue', 'list', '--limit', '1', '--json', 'number', '--jq', ".[0].number" }
    local obj = vim.system(cmd):wait()
    if obj.code ~= 0 then
      vim.notify('Error fetching issue: ' .. obj.stderr, vim.log.levels.ERROR)
      return
    end
    local int = vim.trim(obj.stdout)
    local data = vim.fn.systemlist('gh issue view ' .. int .. ' --json title --template {{.title}}')
    table.insert(data, '') -- add a blank line between title and body:w
    local body = vim.fn.systemlist('gh issue view ' .. int .. ' --json body --template {{.body}}')
    vim.list_extend(data, body)
    local show = require('show')
    show.edit(bufName, data)
    -- the buffer handle is stored in vim.t[bufName]
    --  create user keymaps specific to this buffer for convenience
    --  keymaps can be used from main buffer to trigger actions in a 'bufEdit' buffer
    --  uses show module to get handle  to the buffer
    --local bufnr = show.get_bufnr_by_name(bufName)
    --  used keymap module to create keymaps
    --local keymap = require('keymap')
    -- mimic behaviour like quickfix buffer `cclose` `copen`


    -- <leader>ic : close issue body buffer and return to previous buffer
    --   local bufnr = show.get_bufnr_by_name(bufName)
    --   keymap.leader(
    --     'ic',
    --     function()
    --       local delete_opts = { force = true, unload = true }
    --       vim.api.nvim_buf_delete(bufnr, delete_opts)
    --     end,
    --     'Close issue body buffer')
    -- end,
    -- { desc = 'View GitHub issue body in scratch buffer', nargs = 1 }
  end,
  { desc = 'View GitHub issue body in scratch buffer' }
)

--[[ Pull request commands:
   gh pr list
   gh pr create
   gh pr checkout <number>
   gh pr view <number>
   gh pr status
]] --

vim.api.nvim_create_user_command(
  'PRList',
  function()
    local show = require('show')
    show.shell('GitHubPR', 'gh pr list')
  end,
  { desc = 'gh pr list' }
)

vim.api.nvim_create_user_command(
  'PRCreate',
  function()
    -- commit and push all changes first
    local cmd = { 'git', 'commit', '-am', 'Auto commit before creating PR' }
    local obj = vim.system(cmd):wait()
    if obj.code ~= 0 then
      vim.notify('Error committing changes: ' .. obj.stderr, vim.log.levels.ERROR)
      return
    end
    cmd = { 'git', 'push' }
    obj = vim.system(cmd):wait()
    if obj.code ~= 0 then
      vim.notify('Error pushing changes: ' .. obj.stderr, vim.log.levels.ERROR)
      return
    end
    -- get the latest issue number
    cmd = { 'gh', 'issue', 'list', '--limit', '1', '--json', 'number', '--jq', ".[0].number" }
    local obj = vim.system(cmd):wait()
    if obj.code ~= 0 then
      vim.notify('Error fetching issue: ' .. obj.stderr, vim.log.levels.ERROR)
      return
    end
    local int = vim.trim(obj.stdout)
    cmd = { 'gh', 'issue', 'view', int, '--json', 'title', '--template', '{{.title}}' }
    obj = vim.system(cmd):wait()
    if obj.code ~= 0 then
      vim.notify('Error fetching issue title: ' .. obj.stderr, vim.log.levels.ERROR)
      return
    end
    local title = vim.trim(obj.stdout)
    cmd = { 'gh', 'issue', 'view', int, '--json', 'body', '--template', '{{.body}}' }
    obj = vim.system(cmd):wait()
    if obj.code ~= 0 then
      vim.notify('Error fetching issue body: ' .. obj.stderr, vim.log.levels.ERROR)
      return
    end
    local body = vim.trim(obj.stdout)
    vim.notify('Creating PR with title: ' .. title, vim.log.levels.INFO)
    cmd = { 'gh', 'pr', 'create', '--title', title, '--body', body }
    obj = vim.system(cmd):wait()
    if obj.code ~= 0 then
      vim.notify('Error creating pull request: ' .. obj.stderr, vim.log.levels.ERROR)
      return
    end
    vim.notify('Pull request created successfully: ' .. obj.stdout, vim.log.levels.INFO)
    vim.print(obj.stdout)
    -- view created pull request tin show window
    --local show = require('show')
    --show.shell('GitHubPR', 'gh pr view --web')
    -- local args = { 'gh', 'pr', 'create', '--title', '"' .. title .. '"', '--body', '"' .. body .. '"' }
    -- show.shell('GitHubPR', table.concat(args, ' '))

    -- local body = vim.fn.systemlist('gh issue view ' .. int .. ' --json body --template {{.body}}')
    -- local
    --
    -- 'gh', 'pr', 'create', '--title' "$(gh issue view 123 --json title -q .title)" \
    --   --body "$(gh issue view 123 --json body -q .body)
    --     local show = require('show')
    --
    --
    --
    --     show.shell('GitHubPR', 'gh pr create --web')
  end,
  { desc = 'gh pr create --web' }
)



vim.api.nvim_create_user_command(
  'PRView',
  function(opts)
    local name = 'PRView'
    local pr_number = opts.args
    if pr_number == nil or pr_number == '' then
      vim.notify('Pull request number cannot be empty.', vim.log.levels.WARN)
      return
    end
    local show = require('show')
    show.shell(name, 'gh pr view ' .. pr_number)
  end,
  { desc = 'gh pr view <number>', nargs = 1 }
)

vim.api.nvim_create_user_command(
  'PRCheckout',
  function(opts)
    local name = 'PRCheckout'
    local pr_number = opts.args
    if pr_number == nil or pr_number == '' then
      vim.notify('Pull request number cannot be empty.', vim.log.levels.WARN)
      return
    end

    local show = require('show')
    show.shell(name, 'gh pr checkout ' .. pr_number)
  end,
  { desc = 'gh pr checkout <number>', nargs = 1 }
)
