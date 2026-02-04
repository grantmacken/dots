local M = {}
M.version = '0.1.0'
M.description = 'Custom setup for GitHub issues and PRs'

--- align issue with some conventional commits
M.types = {
  'fix', 'feature', 'refactor', 'chore', 'docs' }


--TODO!
-- use show module to display labels in show window,
-- maybe with some color coding based on label type
M.view_labels = function()
  local cmd = { 'gh', 'issue', 'view', '--json', 'labels', '--jq', '.labels[].name' }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    vim.notify('Error fetching labels: ' .. obj.stderr, vim.log.levels.ERROR)
    return
  end

  local data = vim.split(obj.stdout, '\n')
  require('show').scratch('Labels', data)
end


--- CRUD operations for GitHub issues

M.create = function()
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





return M
