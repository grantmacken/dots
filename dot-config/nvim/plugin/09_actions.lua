--[[ markdown block

Commands for actions like opening terminal, running make, etc.
These commands are defined here to keep the configuration modular and organized.

Action defined here are to do with the `build |> test |> review` cycle of a project

The results of an actions can be of 4 types:
 1. display in **interactive** terminal window
 2. display in **non-interactive** terminal window TODO explain
 3. display in scratch buffer TODO explain
 4. display in **quickfix** window TODO explain

@see dot-config/nvim/lua/term/init.lua
@see dot-config/nvim/lua/scratch/init.lua

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
--
vim.api.nvim_create_user_command(
  'Make',
  function()
    local show = require('show')
    show.interactive_term({ 'clear && make\r\n' }, 'Make')
  end
  , {
    desc = 'open terminal window and run make'
  })


-- local keymap = require('util').keymap
-- keymap('<leader>to', require('term').open, 'open [t]erminal window')
-- keymap('<leader>tc', require('term').close, 'close [t]erminal window')
-- keymap('<leader>tm', ':Make<CR>', '[t]erminal run [m]ake')
