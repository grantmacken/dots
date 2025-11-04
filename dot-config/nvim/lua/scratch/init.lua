--[[
  A simple module to manage scratch buffers in Neovim.
  This module provides functionality to create or retrieve a scratch buffer
  specific to the current tabpage. Scratch buffers are temporary buffers that
  do not correspond to any file on disk and are often used for quick notes or
  testing code snippets.
--]]
local M = {}
M.version = "0.1.0"
-- Create or get a scratch buffer for the current project in the current tabpage
M.buffer = function()
  local tabID       = vim.api.nvim_get_current_tabpage()
  local ok, scratch = pcall(vim.api.nvim_tabpage_get_var, tabID, 'scratch')
  if ok then
    vim.notify('Reusing existing scratch buffer' .. vim.inspect(scratch), vim.log.levels.INFO)
  else
    -- Create a new scratch buffer
    local oListed  = false
    local oScratch = true
    vim.t.scratch  = vim.api.nvim_create_buf(oListed, oScratch)
    local msg      = 'Scratch buffer created' .. ' with bufnr: ' .. vim.inspect(vim.t.scratch)
    vim.notify(msg, vim.log.levels.INFO)
  end
  --vim.bo[bufnr].bufhidden = 'hide'   -- not in the buffer list and hide when abandoned
  --vim.bo[bufnr].buftype   = 'nofile' -- Scratch buffers typically use 'nofile'
  -- vim.api.nvim_buf_set_name(bufnr, 'scratch_my_itch') -- set a name for the buffer for winbar
end



return M
