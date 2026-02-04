local M = {}
M.version = '0.1.0'
M.description = 'Custom setup for GitHub issues and PRs'

--- align lables with some conventional commits
M.labels = {
  'fix', 'feature', 'refactor', 'chore' }

return M
