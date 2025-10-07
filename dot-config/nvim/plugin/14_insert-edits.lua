-- Insert mode key mappings completions
local ok_fzf, fzf = pcall(require, 'fzf-lua')
if ok_fzf then
  vim.api.nvim_create_user_command('Registers', fzf.registers, { desc = '[FZF] Marks' })
  vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", fzf.complete_path,
    { silent = true, desc = "Fuzzy complete path" })
  vim.keymap.set({ "n", "v", "i" }, "<C-x><C-p>", fzf.complete_file,
    { silent = true, desc = "Fuzzy complete file" })
  vim.keymap.set({ "n", "v", "i" }, "<C-x><C-l>", fzf.complete_line,
    { silent = true, desc = "Fuzzy complete line" })
  vim.keymap.set({ "n", "v", "i" }, "<C-x><C-b>", fzf.complete_bline,
    { silent = true, desc = "Fuzzy complete buffer line" })
  -- spelling suggestions
  vim.keymap.set({ "n", "v", "i" }, "<C-x><C-s>", fzf.spell_suggest,
    { silent = true, desc = "Fuzzy complete spelling suggestions" })
end
