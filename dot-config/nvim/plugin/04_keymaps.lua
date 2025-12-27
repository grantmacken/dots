--[[ Generic keymaps
--- Keymaps that don't fit into a specific category
--]]

local keymap = require('keymap')
local map    = keymap.map    -- mode defaults to normal 'n' otherwise add mode
local leader = keymap.leader -- mode defaults to normal 'n' otherwise add mode

map('<ESC>', [[<cmd>noh<CR>]], 'ESC to remove search highlights')

-- generic
map('<leader>aa', function()
  -- add current file to arglist.
  vim.cmd.argedit(vim.fn.expand('%'))
  -- remove dups from arglist.
  vim.cmd('argdedupe')
  vim.cmd('args')
end, 'Arglist Again')

--  in normal mode: Navigate widows with ctrl + arrow keys
map('<C-Down>', '<CMD>wincmd j<CR>', 'Move to lower window')
map('<C-Up>', '<CMD>wincmd k<CR>', 'Move to upper window')
map('<C-Left>', '<CMD>wincmd h<CR>', 'Move to left window')
map('<C-Right>', '<CMD>wincmd l<CR>', 'Move to right window')
-- in insert mode:  Navigate widows with Mod + arrow keys
map('<M-Down>', '<Esc><CMD>wincmd j<CR>a', 'Move to lower window', 'i')
map('<M-Up>', '<Esc><CMD>wincmd k<CR>a', 'Move to upper window', 'i')
map('<M-Left>', '<Esc><CMD>wincmd h<CR>a', 'Move to left window', 'i')
map('<M-Right>', '<Esc><CMD>wincmd l<CR>a', 'Move to right window', 'i')

-- `<C-s>` in Insert mode - save and go to Normal mode
-- map('<C-s>', '<Esc><cmd>w<CR>a', 'Save file', 'i')
-- `<C-q>` in Insert mode - quit and go to Normal mode
map('<C-q>', '<Esc><cmd>q<CR>', 'Quit file', 'i')
--`go` / `gO` - insert empty line before/after in Normal mode
map('go', 'o<Esc>', 'Insert empty line below', 'n')
-- `<C-w>` in Insert mode - close current buffer and go to Normal mode
--
-- Paste linewise before/after current line
-- Usage: `yiw` to yank a word and `]p` to put it on the next line.
map('[p', '<Cmd>exe "put! " . v:register<CR>', 'Paste Above')
map(']p', '<Cmd>exe "put "  . v:register<CR>', 'Pa ste Below')

leader('RR', [[ <Cmd>restart<CR>]], 'Restart Neovim')
leader('RL', [[ <Cmd>luafile %<CR>]], 'Luafile Reload')


-- Leader group clues
--
vim.g.leader_group_clues = {
  { mode = 'n', keys = '<Leader>a', desc = '+[a]rglist' },
  { mode = 'n', keys = '<Leader>c', desc = '+[c]ode' },
  { mode = 'n', keys = '<Leader>e', desc = '+[e]dit or explore' },
  { mode = 'n', keys = '<Leader>R', desc = '[R]eload' },

}

-- CLUES
local ok_clues, clue = pcall(require, 'mini.clue')
if ok_clues then
  -- TODO
  local clue_window = {
    delay = 500, -- Delay in milliseconds before showing the clue window
    scroll_down = '<C-d>',
    scroll_up = '<C-u>',
    config = function(bufnr)
      local max_width = 0
      for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
        max_width = math.max(max_width, vim.fn.strchars(line))
      end
      -- Keep some right padding.
      max_width = max_width + 2
      return {
        -- Dynamic width capped at 70.
        width = math.min(70, max_width),
      }
    end,
  }

  -- Leader group clues

  -- Clues setup
  -- clue triggers:
  local clue_triggers = {
    { mode = 'n', keys = '<Leader>' }, -- Leader triggers
    { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = '\\' },       -- mini.basics
    { mode = 'n', keys = '[' },        -- mini.bracketed
    { mode = 'n', keys = ']' },
    { mode = 'x', keys = '[' },
    { mode = 'x', keys = ']' },
    { mode = 'i', keys = '<C-x>' }, -- Built-in completion
    { mode = 'n', keys = 'g' },     -- `g` key
    { mode = 'x', keys = 'g' },
    { mode = 'n', keys = "'" },     -- Marks
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },
    { mode = 'n', keys = '"' }, -- Registers
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' }, -- Window commands
    { mode = 'n', keys = 'z' },     -- `z` key
    { mode = 'x', keys = 'z' }
  }

  clue.setup({
    window = clue_window,
    triggers = clue_triggers,
    clues = {
      vim.g.leader_group_clues,
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows({ submode_resize = true }),
      clue.gen_clues.z(),
    },
  })
end







-- opt plugin specifix



-- e is for 'Explore' and 'Edit'. Common usage:

leader('ei', '<Cmd>edit $MYVIMRC<CR>', '+[i]nit.lua')
leader('ed', '<Cmd>lua MiniFiles.open()<CR>', 'Directory')
--{ mode = 'n', keys = '<Leader>d', desc = '+Diagnostic' },
-- { mode = 'n', keys = '<Leader>n', desc = '+[n]avigation' },
-- { mode = 'n', keys = '<Leader>J', desc = '+Split[j]oin' },
-- { mode = 'n', keys = '<Leader>S', desc = '+Session' },
-- { mode = 'n', keys = '<Leader>b', desc = '+buffer' },
-- { mode = 'n', keys = '<Leader>f', desc = '+fuzzyFind' },
-- { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
-- { mode = 'n', keys = '<Leader>m', desc = '+markdown' },
-- { mode = 'n', keys = '<Leader>p', desc = '+project' },
-- { mode = 'n', keys = '<Leader>s', desc = '+search' },
-- { mode = 'n', keys = '<Leader>t', desc = '+terminal' },
-- { mode = 'n', keys = '<Leader>g', desc = '+git' },

--{ mode = 'n', keys = '<Leader>S', desc = '+mk[S]ession' },
--{ mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
