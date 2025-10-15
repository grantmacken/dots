local M = {
  VERSION = '0.1.0',
}
---@module util
--[[
  This module provides utility functions for key mappings and other common tasks in Neovim.
  It includes functions for setting keymaps and buffer-specific keymaps with descriptions.
]]

---@param lhs string
---@param rhs string|function
---@param desc string
---@param mode? string|string[]
local keymap = function(lhs, rhs, desc, mode)
  mode = mode or 'n'
  local opt = { desc = desc }
  vim.keymap.set(mode, lhs, rhs, opt)
end
---@param lhs string
---@param rhs string|function
---@param desc string
---@param bufnr? number
---@param mode? string|string[]
keymap_buf = function(lhs, rhs, desc, bufnr, mode)
  bufnr = bufnr or 0
  mode = mode or 'n'
  local opt = { buffer = 0, desc = desc }
  vim.keymap.set(mode, lhs, rhs, opt)
end

---@param lhs string
---@param rhs string|function
---@param desc string
---@param bufnr? number
---@param mode? string|string[]
keymap_dynamic = function(lhs, rhs, desc, bufnr, mode)
  bufnr = bufnr or 0
  mode = mode or 'n'
  local opt = { buffer = bufnr, desc = desc, expr = true, replace_keycodes = true }
  vim.keymap.set(mode, lhs, rhs, opt)
end


--- UTF-8 aware word splitting. See |keyword|
---@see https://github.com/folke/sidekick.nvim/blob/main/lua/sidekick/util.lua
---@param str string
---@return string[] table list of words
function M.split_words(str)
  if str == "" then
    return {}
  end

  local ret = {} ---@type string[]
  local word = {} ---@type string[]
  local starts = vim.str_utf_pos(str)

  local function flush()
    if #word > 0 then
      ret[#ret + 1] = table.concat(word)
      word = {}
    end
  end

  for idx, start in ipairs(starts) do
    local stop = (starts[idx + 1] or (#str + 1)) - 1
    local ch = str:sub(start, stop)
    if vim.fn.charclass(ch) == 2 then -- iskeyword
      word[#word + 1] = ch
    else
      flush()
      ret[#ret + 1] = ch
    end
  end

  flush()
  return ret
end

M.keymap = keymap
M.keymap_buf = keymap_buf
M.keymap_dynamic = keymap_dynamic

return M
