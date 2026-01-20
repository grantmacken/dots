local M = {}

--- @alias gh.Integer integer
--- @alias gh.Error string
--- @alias gh.List  string

--- Get the last list from GitHub CLI
--- @param list_type gh.List Type of list to fetch ('pr' or 'issue')
--- @return gh.Integer|gh.Error result Positive integer if success or error message if fail
M.get_last = function(list_type)
  local cmd = { 'gh', list_type, 'list', '--limit', '1', '--json', 'number', '--jq', ".[0].number" }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    return 'Error fetching PR: ' .. obj.stderr
  end
  local pr_number = tonumber(obj.stdout)
  if not pr_number then
    return obj.stderr
  end
  return pr_number
end

--- Push text body to latest gh PR or Issue
--- @param list_type gh.List Type of list to push ('pr' or 'issue')
--- @param body string text body to push
--- @return gh.Error? error_msg Error message if failed
M.push_body = function(list_type, body)
  local int = M.get_last(list_type)
  if type(int) == 'string' then
    return int
  end
  local cmd = { 'gh', list_type, 'edit', tostring(int), '--body', body }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    return 'Error pushing PR body: ' .. obj.stderr
  end
  vim.notify('PR body updated successfully', vim.log.levels.INFO)
  return nil
end


return M
