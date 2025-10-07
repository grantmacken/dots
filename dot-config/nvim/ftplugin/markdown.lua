vim.cmd "setlocal spell spelllang=en_us"
vim.cmd "setlocal expandtab shiftwidth=4 softtabstop=4 autoindent"
vim.treesitter.start()

-- Registers copilot-chat filetype for markdown rendering
-- TODO disable
-- local ok, render_markdown = pcall(require,'render-markdown')
-- if not ok then return end
-- render_markdown.setup({
--   file_types = { 'markdown', 'copilot-chat' },
-- })
