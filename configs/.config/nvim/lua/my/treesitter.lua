
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "bash",
    "css",
    "html",
    "javascript",
    "json",
    "lua",
    "yaml",
    "query",
  },   
  highlight = {
    enable = true
    --custom_captures = {}
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-A-k>',
      node_incremental = '<C-A-k>',
      node_decremental = '<C-A-j>',
    }
  },
  playground = {
    enable = true,
    updatetime = 25
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
  },
  matchup = {
    enable = true, -- mandatory
  }
})
