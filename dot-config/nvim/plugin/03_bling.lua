-- vim.opt.showmode = false
--
-----@type rainbow_delimiters.config
-- vim.g.rainbow_delimiters = {
--   strategy = {
--     [''] = 'rainbow-delimiters.strategy.global',
--     vim = 'rainbow-delimiters.strategy.local',
--   },
--   query = {
--     [''] = 'rainbow-delimiters',
--     lua = 'rainbow-blocks',
--   },
--   priority = {
--     [''] = 110,
--     lua = 210,
--   },
--   highlight = {
--     'RainbowDelimiterRed',
--     'RainbowDelimiterYellow',
--     'RainbowDelimiterBlue',
--     'RainbowDelimiterOrange',
--     'RainbowDelimiterGreen',
--     'RainbowDelimiterViolet',
--     'RainbowDelimiterCyan',
--   },
-- }
--
--[[ markdown
with tabline use tabby plugin
 - [x] each tab organises buffer windows under a git branch
 - [x] when moving to a tab we are working on a git branch
 - [x] each tab_name in the tabline should represent the name of git branch name we are working on in that tab
 - [x] each tab is number and keybinds based on the numbers are used to move between tabs

Enhanced tabline configuration:
- Show git branch with icon in tab names
- Number each tab for easy navigation:
- Auto-switch to git branch when changing tabs
- Fallback to directory name if no git repo
--]]


-- "\u{E0A0}"
-- '  -- "\u{E0A0}"
-- '  -- "\u{E0A0}"
-- '  -- "\u{E0A0}"

-- Tab navigation keybinds (1-9)
local keymap = require('util').keymap
for i = 1, 9 do
  keymap(
    '<leader>' .. i,
    function() vim.cmd('tabn ' .. i) end,
    'Go to tab ' .. i)
end

-- Additional tab navigation
-- vim.keymap.set('n', '<leader>0', '<cmd>tablast<cr>', { desc = 'Go to last tab', silent = true })
-- vim.keymap.set('n', '<leader>tc', '<cmd>tabnew<cr>', { desc = 'Create new tab', silent = true })
-- vim.keymap.set('n', '<leader>tx', '<cmd>tabclose<cr>', { desc = 'Close current tab', silent = true })
-- vim.keymap.set('n', '<leader>tn', '<cmd>tabnext<cr>', { desc = 'Next tab', silent = true })
-- vim.keymap.set('n', '<leader>tp', '<cmd>tabprevious<cr>', { desc = 'Previous tab', silent = true })

local ok_tabby, tabby = pcall(require, 'tabby')
if ok_tabby then
  vim.o.showtabline = 2
  vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

  local neovim_symbol = "  " -- Neovim icon
  local git_branch_icon = '🌿'
  local folder = '📁'
  local fldr_open = '📂'


  -- Custom tab name function with branch and number
  local function get_tab_name(tab_id)
    local tab_nr = vim.api.nvim_tabpage_get_number(tab_id)
    local current_dir = vim.fn.getcwd(-1, tab_nr)

    -- Try to get git branch
    local branch_name = nil
    local git_cmd = 'cd "' .. current_dir .. '" && git branch --show-current 2>/dev/null'
    local handle = io.popen(git_cmd)
    if handle then
      branch_name = handle:read("*l")
      handle:close()
    end

    local display = ''
    -- Fallback to directory name if no git branch
    if not branch_name or branch_name == "" or branch_name == 'main' then
      display = fldr_open .. ' ' .. vim.fn.fnamemodify(current_dir, ':t')
    else
      display = git_branch_icon .. ' ' .. branch_name
    end
    return display
  end

  tabby.setup({
    line = function(line)
      return {
        {
          { neovim_symbol .. ' ', hl = 'TabLineSel' },
          line.sep('', 'TabLineSel', 'TabLineFill'),
        },
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and 'TabLineSel' or 'TabLine'
          return {
            line.sep('', hl, 'TabLineFill'),
            tab.number(),
            ':',
            get_tab_name(tab.id),
            line.sep('', hl, 'TabLineFill'),
            hl = hl,
            margin = ' ',
          }
        end),
        line.spacer(),
        line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
          return {
            line.sep('', 'TabLine', 'TabLineFill'),
            win.is_current() and '' or '',
            win.buf_name(),
            line.sep('', 'TabLine', 'TabLineFill'),
            hl = 'TabLine',
            margin = ' ',
          }
        end),
        {
          line.sep('', 'TabLineFill', 'TabLineFill'),
          { '  ', hl = 'TabLineFill' },
        },
        hl = 'TabLineFill',
      }
    end,
    option = {
      nerdfont = true,
    },
  })
end

local mini_plugs = {
  'statusline',
  'git',
  'cursorword',
  'trailspace',
  'hipatterns',
}

for _, plugin in ipairs(mini_plugs) do
  require('mini.' .. plugin).setup()
end


local ok_misc, miniMisc = pcall(require, 'mini.misc')
if ok_misc then
  miniMisc.setup_restore_cursor()
  miniMisc.setup_auto_root({ '.git', 'Makefile' })
  miniMisc.setup_termbg_sync()
end

-- indentscope
local ok_indentscope, indentscope = pcall(require, 'mini.indentscope')
if ok_indentscope then
  indentscope.setup({
    symbol = '│', -- Character to use for indentation lines
    options = {
      try_as_border = true, -- Try to use the symbol as a border
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = {
      "help",
      "notify",
      "oil",
    },
    callback = function()
      vim.b.miniindentscope_disable = true
    end
  })
end
