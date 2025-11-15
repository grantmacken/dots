--[[ markdown
Nvim provides several *lists types* that can be accessed via the cmdline:
 - list subtypes include: *navigation*, *misc*

 *navigation* lists:  moving between locations in a file or between files
  - the jump list `:jumps`
  - the marks list `:marks`
  - the buffer list `:buffers`
  - the file history `:oldfiles`
 - the quickfix list `:copen`
 - the location list `:lopen`

 *misc* lists: tracking changes and commands
 - the undo list `:undolist`
 - the message history `:messages`
 - the argument list `:args`
 - the register list `:registers`
 - the command history `:history`
 - the search history `:/` and `:?`


--]]
--[[ markdown
# Check list to *navigation* type lists
 - [ ] Use [fuzzy finder](https://github.com/ibhagwan/fzf-lua) for *navigation* list item selection
 - [ ] Provide a preview window when selecting items from *navigation* lists
 - [ ] Open location Keybind: fzy selected item opens in the corresponding location in the editor
 - [ ] Navigation lists keybind prefix: `leader + n`
 --]]

--
-- FZF LUA SETUP FOR LISTS
local ok_fzf, fzf = pcall(require, 'fzf-lua')
if ok_fzf then
  vim.api.nvim_create_user_command('Args', fzf.args, { desc = '[FZF] Jumps' })
  vim.api.nvim_create_user_command('Buffers', fzf.buffers, { desc = '[FZF] Marks' })
  vim.api.nvim_create_user_command('Jumps', fzf.jumps, { desc = '[FZF] Jumps' })
  vim.api.nvim_create_user_command('Marks', fzf.marks, { desc = '[FZF] Marks' })
  vim.api.nvim_create_user_command('OldFiles', fzf.oldfiles, { desc = '[FZF] Old Files' })
  --
  -- KEYMAPS FOR LISTS
  local keymap = require('util').keymap

  -- ARGUMENTS LIST
  --
  --- @see https://jkrl.me/vim/2025/05/28/nvim-arglist.html
  --- @see help:arglist
  --
  --[[ markdown
  ## Argument List

  The argument list is a list of files that you can navigate between.
  You can add files to the argument list using the :argadd command,
  remove files using :argdelete, and view the list using :args.
  Use `[a` and `]a` to navigate between files in the argument list.
  --]]
  --- list args with fzf

  -- JUMPS MARKS BUFFERS
  keymap('<leader>nj', '<cmd>Jumps<cr>', 'FZF Jump List')
  keymap('<leader>no', '<cmd>OldFiles<cr>', 'FZF Old Files List')
  keymap('<leader>nm', fzf.marks, 'FZF Marks List')
  keymap('<leader>nb', fzf.buffers, 'FZF Buffer List')
end
