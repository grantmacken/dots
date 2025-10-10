--[[ markdown
set the compiler for the dots project
assume that make is installed and available in the PATH
see :h compiler
]] --

vim.bo.makeprg = "make default"
vim.bo.errorformat = "%f:%l:%c: %m"
