-- package.loaded['my.repl'] = nil
local M = {}
local term_id = {}
-- buffers to corresponding repls
local create_terminal = function()
  if not M.term_id then
    vim.cmd [[:botright sp ]]
    M.term_id = vim.fn.termopen("/bin/bash")
    -- vim.wait(100, function() return false end)
    vim.api.nvim_buf_set_option(vim.fn.bufnr(), 'bufhidden', 'hide')
    -- reset to,current
  end
    vim.api.nvim_set_current_buf(current_id)
end

M.send_line = function()
  local current_id = vim.fn.bufnr()
  create_terminal()
    vim.api.nvim_set_current_buf(current_id)
  -- vim.fn.chansend(M.term_handle.term_id , vim.fn.getline('.') .. "\n")
end

return M.send_line()
