--- @see dot-config/nvim/plugin/08_scratch.lua for commands that use the scratch module
--- @see dot-config/nvim/lua/scratch/init.lua  the scratch module
---
--[[ markdown block
--]]
--
vim.api.nvim_create_user_command(
  'ScratchExample',
  function()
    local tbl = {
      'This is an example of using the scratch module.',
      'You can use it to display output in a temporary buffer.',
      'This buffer will not be saved and will be hidden when abandoned.',
      '',
      'Feel free to modify this example to suit your needs!',
    }
    local scratch = require('scratch')
    scratch.buffer()
    local show = require('show')
    show.window(vim.t.scratch)
    show.append_lines(vim.t.scratch, tbl)
  end,
  { desc = 'An example action that shows output in a Interactive Terminal' }
)

vim.api.nvim_create_user_command(
  'ScratchProjectExample',
  function()
    local tbl = { 'winID: ' .. vim.inspect(vim.t.winID) }
    local scratch = require('scratch')
    scratch.buffer()
    local show = require('show')
    show.window(vim.t.scratch)
    show.append_lines(vim.t.scratch, tbl)
  end,
  { desc = 'An example action that shows output in a Interactive Terminal' }
)
