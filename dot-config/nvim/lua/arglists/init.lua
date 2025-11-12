M = {}
M.version = '0.1.0'
--[[ markdown
## Arglist Setup
  - clear existing arglist for the tabpage to create a fresh arglist
  - read the .arglist file in the project root
  - prepend the cwd to each file in the arglist
  - set the arglist to the project specific files
--]]
---@see url  gx https://jkrl.me/vim/2025/05/28/nvim-arglist.html or ctrl-shift enter
M.setup = function()
  vim.cmd('arglocal|%argdelete') -- clear arglist for new tabpage
  local ok, arglist = M.arglist_load()
  if not ok then
    vim.notify('Error loading arglist: ' .. arglist, vim.log.levels.WARN)
    return
  end
  M.arglist_user_commands()
  M.arglist_keymaps(arglist)
end

M.arglist_load = function()
  local arglist = vim.fn.readfile(vim.fn.getcwd() .. '/.arglist')
  for _, file in ipairs(arglist) do
    local ok, err = pcall(vim.cmd.argadd, file)
    if not ok then
      return false, err
    end
  end
  return true, arglist
end

---@param path string
---@return string relative path from cwd
M.relative_path = function(path)
  local cwd = vim.fn.getcwd()
  local res = path:gsub(cwd .. '/', '')
  return res
end

M.arglist_save = function()
  local filepath = vim.fn.getcwd() .. '/.arglist'
  local tbl = vim.fn.argv()
  vim.notify('Saving arglist to ' .. filepath, vim.log.levels.INFO)
  vim.notify(vim.inspect(tbl), vim.log.levels.DEBUG)
  vim.fn.writefile(tbl, filepath, 'b')
end

M.arglist_user_commands = function()
  vim.api.nvim_create_user_command(
    'ArgLoad', M.arglist_load,
    { desc = 'arglist: load arglist from .arglist file' })

  vim.api.nvim_create_user_command(
    'ArgSave', M.arglist_save,
    { desc = 'arglist: write current arglist to a file' })
end

M.arglist_keymaps = function(arglist)
  local keymap = require('util').keymap
  -- assign arg to each number
  for i = 1, #arglist do
    -- Get the full path of the item at index 'i' in the arglist
    local path = vim.fn.argv(i - 1)
    if type(path) == 'string' then
      local name = M.relative_path(path)
      keymap('<leader>a' .. i, "<CMD>argu " .. i .. "<CR>", "Go to arg " .. name)
    end
  end

  keymap('<leader>aa', function()
    local arg = require('arglists').relative_path(vim.fn.expand('%'))
    vim.cmd.argadd(arg)  -- add current file to arglist
    vim.cmd('argdedupe') -- remove duplicates
  end, 'add to arglist: ')
  keymap('<leader>ad', function()
    local arg = require('arglists').relative_path(vim.fn.expand('%'))
    vim.cmd.argdelete(arg) -- delete current file from arglist
  end, 'delete from arglist: ')
  keymap('<leader>al', '<CMD>Args<CR>', 'open arglist with fzf')
  keymap('<leader>as', '<CMD>ArgSave<CR>', 'save arglist to .arglist file')
  keymap('<leader>aq', function()
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
  end, "Show args in qf")
end
--tabpage user commands for arglist management

return M
