if vim.fn.executable('gleam') ~= 1 then return end
-- by default disables regex parsing
vim.treesitter.start()
-- local to window
vim.wo.foldlevel = 99
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldtext = "v:lua.vim.treesitter.foldtext()"
-- Use treesitter for indentation
-- local to buffer
-- vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"


-- vim.bo.omnifunc = 'v:lua.vim.treesitter.query.omnifunc'
--
-- TODO
vim.treesitter.inspect_tree()
-- vim.treesitter.query.lint()
-- vim.treesitter.query.edit()
--vim.treesitter.language.inspect()
