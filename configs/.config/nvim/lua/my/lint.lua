M = {}
-- before plugin enabled
-- local setup = function() end

-- after plugin enabled
local config = function()
   require('lint').linters_by_ft = {
    sh = {'shellcheck'}
  }
  vim.api.nvim_exec([[
  augroup nvim_lint
  autocmd!
  autocmd BufWritePost * lua require('lint').try_lint()
  augroup END
    ]], false)

  vim.cmd("command! Lint lua require('lint').try_lint()")
end

--M.setup = setup
M.config = config

return M

