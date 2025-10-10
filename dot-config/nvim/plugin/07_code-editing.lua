local keymap = require('util').keymap
local ok_surround, surround = pcall(require, 'mini.surround')
if ok_surround then
  surround.setup({
    mappings = {
      add = '<Leader>sa',       -- Add surrounding
      delete = '<Leader>sd',    -- Delete surrounding
      find = '<Leader>sf',      -- Find surrounding (to the right)
      find_left = '<Leader>sF', -- Find surrounding (to the left)
      highlight = '<Leader>sh', -- Highlight surrounding
      replace = '<Leader>sr',   -- Replace surrounding
    },
  })
end

--SPLITJOIN
local ok_splitjoin, splitjoin = pcall(require, 'mini.splitjoin')
-- Toggle between split and join
-- Split a line into :wmultiple linesJoin multiple lines into one
splitjoin.setup({
  mappings = {
    toggle = '<Leader>Jt',
    split = '<Leader>Js',
    join = '<Leader>Jj',
  },
})

local ok_yanky, yanky = pcall(require, 'yanky')
if ok_yanky then
  yanky.setup({
    ring = {
      history_length = 20,
    },
    highlight = {
      timer = 250,
    },
  })

  -- Keymaps for yanky.nvim
  keymap('y', '<Plug>(YankyYank)', 'Yank', { 'x', 'n' })
  keymap('p', '<Plug>(YankyPutAfter)', 'Put yanked text after cursor')
  keymap('P', '<Plug>(YankyPutBefore)', 'Put yanked text before cursor')
  keymap('=p', '<Plug>(YankyPutAfterLinewise)', 'Put yanked text in line below')
  keymap('=P', '<Plug>(YankyPutBeforeLinewise)', 'Put yanked text in line above')
  -- yankring
  keymap('[y', '<Plug>(YankyCycleForward)', 'Cycle forward through yank history')
  keymap(']y', '<Plug>(YankyCycleForward)', 'Cycle forward through yank history')
  --
end
