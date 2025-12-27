local M = {}

---@param lhs string
---@param rhs string|function
---@param desc string
---@param mode? string|string[]
M.map = function(lhs, rhs, desc, mode)
  mode = mode or 'n'
  local opt = { desc = desc }
  vim.keymap.set(mode, lhs, rhs, opt)
end

M.leader = function(lhs, rhs, desc, mode)
  mode = mode or 'n'
  local opt = { desc = desc }
  vim.keymap.set(mode, '<leader>' .. lhs, rhs, opt)
end

---@param lhs string
---@param rhs string|function
---@param desc string
---@param bufnr? number
---@param mode? string|string[]
M.buf = function(lhs, rhs, desc, bufnr, mode)
  bufnr = bufnr or 0
  mode = mode or 'n'
  local opt = { buffer = bufnr, desc = desc }
  vim.keymap.set(mode, lhs, rhs, opt)
end

---@param lhs string
---@param rhs string|function
---@param desc string
---@param bufnr? number
---@param mode? string|string[]
M.buf_leader = function(lhs, rhs, desc, bufnr, mode)
  bufnr = bufnr or 0
  mode = mode or 'n'
  local opt = { buffer = bufnr, desc = desc }
  vim.keymap.set(mode, '<leader>' .. lhs, rhs, opt)
end

---@param lhs string
---@param rhs string|function
---@param desc string
---@param bufnr? number
---@param mode? string|string[]
M.buf_dynamic = function(lhs, rhs, desc, bufnr, mode)
  bufnr = bufnr or 0
  mode = mode or 'n'
  local opt = { buffer = bufnr, desc = desc, expr = true, replace_keycodes = true }
  vim.keymap.set(mode, lhs, rhs, opt)
end






return M
