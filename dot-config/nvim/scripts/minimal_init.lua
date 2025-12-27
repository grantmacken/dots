--- Snapshot testing init for mini.test
--- Based on mini.nvim testing approach for UI snapshot tests
--- @see file /var/home/gmack/.local/share/nvim/site/pack/core/start/mini.nvim/tests/
-- Load mini.test
-- vim.cmd([[let &rtp.=','.getcwd()]])
---- Set up 'mini.test' only when calling headless Neovim (like with `make test`)
if #vim.api.nvim_list_uis() == 0 then
  -- mini in packpath
  --local mini_path = vim.fn.stdpath('data') .. '/site/pack/core/start/mini.nvim'
  --vim.opt.runtimepath:append(mini_path)
  -- Set up 'mini.test'
  require('mini.test').setup()
end
