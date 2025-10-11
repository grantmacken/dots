--- @see dot-config/nvim/plugin/09_actions.lua for commands that use the show module
--- @see dot-config/nvim/lua/show/init.lua     for the show module
---
--[[ markdown block

Commands for actions like opening terminal, running make, etc.
These commands are defined here to keep the configuration modular and organized.

Action defined here are to do with the `build |> test |> review` cycle of a project

The results of an actions can be of 4 types:
 1. display in **interactive** terminal window
 2. display in **non-interactive** terminal window TODO explain
 3. display in scratch buffer TODO explain
 4. display in **quickfix** window TODO explain



## Out of scope
 - LSP diagnostics - these are handled by the LSP client
    - currently open buffer diagnostics results are displayed in the location list window
    - workplace diagnostics results are displayed in the quickfix window TODO explain not implemented yet
 - fzf pickers - these are defined in the relevant modules

]] --

--[[ markdown block
# requirements checklist
 - [ ] open terminal should open in the project root directory
 - [ ] toggle terminal - one and only one terminal per tab. i.e. a terminal id handle from the a project tab
 - [ ] open and close terminal for tab. This should hide/open an existing terminal session
 - [ ] terminal always opens in bottom right split window occupying the full window width.
 ]] --

--
-- vim.api.nvim_create_user_command('TermOpen', require('term').open, {
--   desc = 'open terminal window'
-- })
--
--
-- vim.api.nvim_create_user_command('TermClose', require('term').close, {
--   desc = 'close terminal window'
-- })

-- show results in a noninteractive terminal window
-- here we use vim.system() to run a shell command asynchronously
-- and show the output in a noninteractive terminal window
-- @see dot-config/nvim/lua/show/init.lua
vim.api.nvim_create_user_command(
  'ActionExampleNonInteractive',
  function()
    local show = require('show')
    show.noninteractive_term('ls -al .')
  end,
  { desc = 'An example action that shows output in a noninteractive terminal' }
)

-- send bash commands to interactive terminal window
-- This action opens an interactive terminal window (if not already open)
-- and sends the bash commands to the terminal window
-- The terminal window remains open for further interaction
--- @see dot-config/nvim/lua/show/init.lua
vim.api.nvim_create_user_command(
  'ActionExampleInteractiveTerminal',
  function()
    vim.schedule(function()
      local show = require('show')
      show.interactive_term('echo "Hello from ActionExampleInteractiveTerminal"')
    end)
  end,
  { desc = 'An example action that shows output in a Interactive Terminal' }
)
-- send bash commands to scratch buffer
-- @see dot-config/nvim/lua/show/init.lua
-- This action opens a scratch buffer (if not already open)
-- and sends the bash commands to the scratch buffer
-- The scratch buffer remains open for further interaction
vim.api.nvim_create_user_command(
  'ActionExampleScratch',
  function()
    local show = require('show')
    show.scratch('ls -al .')
  end,
  { desc = 'An example action that shows output in a Interactive Terminal' }
)

vim.api.nvim_create_user_command(
  'Make',
  function()
    local show = require('show')
    show.scratch('make')
  end
  , {
    desc = 'open terminal window and run make'
  })

vim.api.nvim_create_user_command(
  'GitStatus',
  function()
    local show = require('show')
    show.scratch('git status --short --branch --porcelain')
  end
  , {
    desc = 'show git status in scratch buffer'
  })

vim.api.nvim_create_user_command(
  'GitLog',
  function()
    local show = require('show')
    show.scratch('git log --oneline --graph --decorate')
  end
  , {
    desc = 'show git log in scratch buffer'
  })


vim.api.nvim_create_user_command(
  'GitCommit',
  function()
    local show = require('show')
    show.scratch('copilot -p "add commit message since last commit" --allow-all-tools --add-dir' .. vim.fn.getcwd())
  end,
  { desc = 'Use Copilot to generate a git commit message' }
)

vim.api.nvim_create_user_command(
  'GitPush',
  function()
    local show = require('show')
    show.scratch('git push')
  end,
  { desc = 'Use Copilot to generate a git commit message' }
)

-- local keymap = require('util').keymap
-- keymap('<leader>to', require('term').open, 'open [t]erminal window')
-- keymap('<leader>tc', require('term').close, 'close [t]erminal window')
-- keymap('<leader>tm', ':Make<CR>', '[t]erminal run [m]ake')
