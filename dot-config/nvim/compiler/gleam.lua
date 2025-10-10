--[[ markdown
set the compiler for gleam files
assume that gleam is installed and available in the PATH
see :h compiler
]] --

vim.bo.makeprg = "gleam build"

-- Gleam error format:
-- error: Error message
--   ┌─ src/file.gleam:10:5
vim.bo.errorformat = table.concat({
  "%Eerror: %m", -- Error message
  "%Wwarning: %m", -- Warning message
  "%Z  ┌─ %f:%l:%c", -- File location line
  "%-G%.%#", -- Ignore other lines
}, ",")
