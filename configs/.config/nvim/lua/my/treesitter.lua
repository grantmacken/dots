M = {}

-- before plugin enabled
--local setup = function() end

-- after plugin enabled
local config = function()
  require "nvim-treesitter.configs".setup({
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
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      }
    },
    matchup = {
      enable = true, -- mandatory
    },
    fzf = {
      override_generic_sorter = false; -- override the generic sorter
      override_file_sorter = true;     -- override the file sorter
      case_mode = "smart_case";        -- or "ignore_case" or "respect_case"
    }
  })
  -- load extensions
  require('telescope').load_extension('gh')
  require('telescope').load_extension('fzf')
  require("telescope").load_extension("session-lens")
end

M.config = config
--M.setup = setup

return M
