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
  'Gpush',
  function()
    local show = require('show')
    show.shell('GitPush', 'git push')
  end,
  { desc = 'git push' }
)


vim.api.nvim_create_user_command(
  'GitHubForcePush',
  function()
    local show = require('show')
    show.task('GitForcePush', { 'git', 'push', '--force' })
  end,
  { desc = 'git forced push' }
)


--[[ ISSUES:
   gh issue list
   gh issue view <number>
   gh issue edit <number>
]] --


vim.api.nvim_create_user_command(
  'GitHubIssues',
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
  'GitHubIssueCreate',
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
                    show.shell('GitHubIssueCreate', table.concat(args, ' '))
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


vim.api.nvim_create_user_command(
  'GitHubIssueViewBody',
  function(opts)
    local name = 'GitHubIssueView'
    local NUMBER = opts.args
    if NUMBER == nil or NUMBER == '' then
      vim.notify('Issue number cannot be empty.', vim.log.levels.WARN)
      return
    end
    vim.system(
      { 'gh', 'issue', 'view', NUMBER, '--json', 'body', '--template', '{{.body}}' },
      {},
      function(result)
        if result.code ~= 0 then
          vim.schedule(function()
            vim.notify('Error fetching issue body: ' .. result.stderr, vim.log.levels.ERROR)
          end)
          return
        end
        local body = result.stdout
        vim.schedule(function()
          -- Create a new scratch buffer to display the issue body
          vim.notify('Issue Body:\n' .. body, vim.log.levels.INFO)
          local show    = require('show')
          local bufName = 'bufScratch' .. name
          show.scratch('GitHubIssueBody', body)
          local bufnr = show.get_bufnr_by_name(bufName)
          vim.notify('Buffer: ' .. bufName, vim.log.levels.INFO)
          vim.notify('Bufnr: ' .. bufnr, vim.log.levels.INFO)
          -- make the buffer modifiable true
          vim.bo[bufnr].modifiable = true
          -- local buf = vim.api.nvim_get_current_buf()
        end)
      end
    )
  end,
  { desc = 'View GitHub issue body in scratch buffer', nargs = 1 }
)




-- ISSUE_BODY=$(gh issue view "$NUMBER" --json body --template '{{.body}}')
