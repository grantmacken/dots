local setup = function()
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

return setup
