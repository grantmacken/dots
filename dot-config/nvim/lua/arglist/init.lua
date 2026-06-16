M = {}
M.version = '0.1.0'
M.description = [[ module: arglist - management for project specific arglists
  - Each project has its own arglist, stored in a .arglist file in the project root
  - A existing arglist is cleared when loaded when a new tabpage is opened,
    and the saved arglist is loaded for the tab tabpage
  - The arglist is managed with user commands and keymaps for adding, deleting, and navigating the arglist
  - The arglist can be saved to the .arglist file with a user command
## Arglist Setup
  - clear existing arglist for the tabpage to create a fresh arglist
  - read the .arglist file in the project root
  - prepend the cwd to each file in the arglist
  - set the arglist to the project specific files
  - create user commands for loading and saving the arglist
  - create keymaps for navigating the arglist and managing it
]]

--[[ local list of commands, keymaps, and autocmds to setup for the arglist module
  - commands are defined as strings in the `commands` table, with the format "ArgCommandName"
  - keymaps are defined as tables in the `keymaps` table, with the format { mode, lhs, rhs, desc }
  - autocmds are defined as tables in the `autocmds` table, with the format { event, pattern, group, callback, desc }
]]

local commands = {
  'ArglistClear',
  'ArglistLoad',
  'ArglistSave',
  'ArglistList',
  'ArglistEdit',
  --'ArglistAddCurrent',
  -- 'ArglistDeleteCurrent',
}

local keymaps = {
  { 'n', '<leader>ac', '<CMD>ArglistClear<CR>',         '[a]rglist [c]lear' },
  { 'n', '<leader>al', '<CMD>ArglistList<CR>',          '[a]rglist [l]ist' },
  { 'n', '<leader>ae', '<CMD>ArglistEdit<CR>',          '[a]rglist [e]edit' },
  { 'n', '<leader>as', '<CMD>ArglistSave<CR>',          '[a]rglist [s]ave' },
  { 'n', '<leader>aa', '<CMD>ArglistAddCurrent<CR>',    '[a]rglist add [a]rg' },
  { 'n', '<leader>ad', '<CMD>ArglistDeleteCurrent<CR>', '[a]rglist [d]elete current arg' },
}

local autocmds = {
  -- {
  --   event = 'TabNew',
  --   pattern = '*',
  --   group = 'arglist',
  --   callback = function() M.setup() end,
  --   desc = 'Setup arglist for new tabpage',
  -- },
}

--[[ section: local functions for arglist management
  - these functions are used in the user commands and keymaps defined above
  - they are not exposed as part of the module's public API, but can be used internally
]]

---@param path string
---@return string relative path from cwd
M.relative_path = function(path)
  local cwd = vim.fn.getcwd()
  local res = path:gsub(cwd .. '/', '')
  return res
end

M.load = function()
  local arglist = vim.fn.readfile(vim.fn.getcwd() .. '/.arglist')
  for _, file in ipairs(arglist) do
    local ok, err = pcall(vim.cmd.argadd, file)
    if not ok then
      return false, err
    end
  end
  return true, arglist
end

M.save = function()
  local filepath = vim.fn.getcwd() .. '/.arglist'
  local tbl = vim.fn.argv()
  vim.notify('Saving arglist to ' .. filepath, vim.log.levels.INFO)
  vim.notify(vim.inspect(tbl), vim.log.levels.DEBUG)
  vim.fn.writefile(tbl, filepath, 'b')
end

M.list = function()
  local list = vim.fn.argv()
  if type(list) ~= 'table' then
    vim.notify('Arglist is empty', vim.log.levels.WARN)
    return
  end
  if #list > 0 then
    local qf_items = {}
    for _, filename in ipairs(list) do
      table.insert(qf_items, {
        filename = filename,
        lnum = 1,
        text = filename
      })
    end
    vim.fn.setqflist(qf_items, 'r')
    vim.cmd.copen()
  end
end
-- open arglist file for this tabpage
M.edit = function()
  local filepath = vim.fn.getcwd() .. '/.arglist'
  -- create the file if it doesn't exist
  if vim.fn.filereadable(filepath) == 0 then
    vim.fn.writefile({}, filepath)
  end
  vim.cmd('edit ' .. filepath)
end

--[[ section: public API for arglist management
  - these functions are exposed as part of the module's public API and can be called from user commands and keymaps
  - they are also used internally in the setup function to initialize the arglist for each tabpage
]]

M.clear = function()
  vim.cmd('arglocal|%argdelete')
end



M.setup = function()
  for _, cmd in ipairs(commands) do
    -- convert "ArglistClear" to "clear", "ArglistLoad" to "load", etc. by taking the substring after "Arglist" and converting it to lowercase
    local func        = cmd:sub(8):lower()
    local description = cmd:gsub("%u", " %0"):gsub("^%s+", "") or ""
    vim.api.nvim_create_user_command(cmd, M[func], { desc = description })
  end
  for _, keymap in ipairs(keymaps) do
    vim.keymap.set(keymap[1], keymap[2], keymap[3], { desc = keymap[4] })
  end
  for _, autocmd in ipairs(autocmds) do
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = autocmd.group,
      pattern = autocmd.pattern,
      callback = autocmd.callback,
      desc = autocmd.desc,
    })
  end
end




---@see url  gx https://jkrl.me/vim/2025/05/28/nvim-arglist.html or ctrl-shift enter
-- M.setup = function()
--   vim.cmd('arglocal|%argdelete') -- clear arglist for new tabpage
--   local ok, arglist = M.arglist_load()
--   if not ok then
--     vim.notify('Error loading arglist: ' .. arglist, vim.log.levels.WARN)
--     return
--   end
--   M.arglist_user_commands()
--   M.arglist_keymaps(arglist)
-- end

-- M.arglist_load = function()
--   local arglist = vim.fn.readfile(vim.fn.getcwd() .. '/.arglist')
--   for _, file in ipairs(arglist) do
--     local ok, err = pcall(vim.cmd.argadd, file)
--     if not ok then
--       return false, err
--     end
--   end
--   return true, arglist
-- end
--
--
-- M.arglist_save = function()
--   local filepath = vim.fn.getcwd() .. '/.arglist'
--   local tbl = vim.fn.argv()
--   vim.notify('Saving arglist to ' .. filepath, vim.log.levels.INFO)
--   vim.notify(vim.inspect(tbl), vim.log.levels.DEBUG)
--   vim.fn.writefile(tbl, filepath, 'b')
-- end
--

--
--   vim.api.nvim_create_user_command(
--     'ArgSave', M.arglist_save,
--     { desc = 'arglist: write current arglist to a file' })
-- end
--
-- M.arglist_keymaps = function(arglist)
--   local keymap = require('util').keymap
--   -- assign arg to each number
--   for i = 1, #arglist do
--     -- Get the full path of the item at index 'i' in the arglist
--     local path = vim.fn.argv(i - 1)
--     if type(path) == 'string' then
--       local name = M.relative_path(path)
--       keymap('<leader>a' .. i, "<CMD>argu " .. i .. "<CR>", "Go to arg " .. name)
--     end
--   end
--
--   keymap('<leader>aa', function()
--     local arg = require('arglists').relative_path(vim.fn.expand('%'))
--     vim.cmd.argadd(arg)  -- add current file to arglist
--     vim.cmd('argdedupe') -- remove duplicates
--   end, 'add to arglist: ')
--   keymap('<leader>ad', function()
--     local arg = require('arglists').relative_path(vim.fn.expand('%'))
--     vim.cmd.argdelete(arg) -- delete current file from arglist
--   end, 'delete from arglist: ')
--   keymap('<leader>al', '<CMD>Args<CR>', 'open arglist with fzf')
--   keymap('<leader>as', '<CMD>ArgSave<CR>', 'save arglist to .arglist file')
--   keymap('<leader>aq', function()
--     local list = vim.fn.argv()
--     if type(list) ~= 'table' then
--       vim.notify('Arglist is empty', vim.log.levels.WARN)
--       return
--     end
--     if #list > 0 then
--       local qf_items = {}
--       for _, filename in ipairs(list) do
--         table.insert(qf_items, {
--           filename = filename,
--           lnum = 1,
--           text = filename
--         })
--       end
--       vim.fn.setqflist(qf_items, 'r')
--       vim.cmd.copen()
--     end
--   end, "Show args in qf")
-- end
--tabpage user commands for arglist management



---@see url  gx https://jkrl.me/vim/2025/05/28/nvim-arglist.html or ctrl-shift enter
-- M.setup = function()
--   vim.cmd('arglocal|%argdelete') -- clear arglist for new tabpage
--   local ok, arglist = M.arglist_load()
--   if not ok then
--     vim.notify('Error loading arglist: ' .. arglist, vim.log.levels.WARN)
--     return
--   end
--   M.arglist_user_commands()
--   M.arglist_keymaps(arglist)
-- end

-- M.arglist_load = function()
--   local arglist = vim.fn.readfile(vim.fn.getcwd() .. '/.arglist')
--   for _, file in ipairs(arglist) do
--     local ok, err = pcall(vim.cmd.argadd, file)
--     if not ok then
--       return false, err
--     end
--   end
--   return true, arglist
-- end
--
--
-- M.arglist_save = function()
--   local filepath = vim.fn.getcwd() .. '/.arglist'
--   local tbl = vim.fn.argv()
--   vim.notify('Saving arglist to ' .. filepath, vim.log.levels.INFO)
--   vim.notify(vim.inspect(tbl), vim.log.levels.DEBUG)
--   vim.fn.writefile(tbl, filepath, 'b')
-- end
--

--
--   vim.api.nvim_create_user_command(
--     'ArgSave', M.arglist_save,
--     { desc = 'arglist: write current arglist to a file' })
-- end
--
-- M.arglist_keymaps = function(arglist)
--   local keymap = require('util').keymap
--   -- assign arg to each number
--   for i = 1, #arglist do
--     -- Get the full path of the item at index 'i' in the arglist
--     local path = vim.fn.argv(i - 1)
--     if type(path) == 'string' then
--       local name = M.relative_path(path)
--       keymap('<leader>a' .. i, "<CMD>argu " .. i .. "<CR>", "Go to arg " .. name)
--     end
--   end
--
--   keymap('<leader>aa', function()
--     local arg = require('arglists').relative_path(vim.fn.expand('%'))
--     vim.cmd.argadd(arg)  -- add current file to arglist
--     vim.cmd('argdedupe') -- remove duplicates
--   end, 'add to arglist: ')
--   keymap('<leader>ad', function()
--     local arg = require('arglists').relative_path(vim.fn.expand('%'))
--     vim.cmd.argdelete(arg) -- delete current file from arglist
--   end, 'delete from arglist: ')
--   keymap('<leader>al', '<CMD>Args<CR>', 'open arglist with fzf')
--   keymap('<leader>as', '<CMD>ArgSave<CR>', 'save arglist to .arglist file')
--   keymap('<leader>aq', function()
--     local list = vim.fn.argv()
--     if type(list) ~= 'table' then
--       vim.notify('Arglist is empty', vim.log.levels.WARN)
--       return
--     end
--     if #list > 0 then
--       local qf_items = {}
--       for _, filename in ipairs(list) do
--         table.insert(qf_items, {
--           filename = filename,
--           lnum = 1,
--           text = filename
--         })
--       end
--       vim.fn.setqflist(qf_items, 'r')
--       vim.cmd.copen()
--     end
--   end, "Show args in qf")
-- end
--tabpage user commands for arglist management









return M
