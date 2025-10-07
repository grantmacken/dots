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




M.keymap = keymap
M.keymap_buf = keymap_buf
M.keymap_dynamic = keymap_dynamic

return M
