return function()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.expandtab = true
  vim.bo.textwidth = 120
  vim.wo.signcolumn = 'yes:4'
  --api.nvim_buf_set_keymap(0, "n", " cr", ":call completion_treesitter#smart_rename()<CR>", { noremap = true })
end
