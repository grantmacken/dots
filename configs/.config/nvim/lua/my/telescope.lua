M = {}

-- before plugin enabled
--local setup = function() end

-- after plugin enabled
local config = function()
  local actions = require('telescope.actions')
  local trouble = require("trouble.providers.telescope")
  require('telescope').setup({
    defaults = {
      find_command = {'rg', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'},
      prompt_position = "bottom",
      -- prompt_prefix = " ",
      prompt_prefix = " ",
      selection_caret = " ",
      entry_prefix = "  ",
      initial_mode = "insert",
      -- initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "descending",
      layout_strategy = "horizontal",
      layout_defaults = {horizontal = {mirror = false}, vertical = {mirror = false}},
      file_sorter = require'telescope.sorters'.get_fzy_sorter,
      file_ignore_patterns = {},
      generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
      shorten_path = true,
      winblend = 0,
      width = 0.75,
      preview_cutoff = 120,
      results_height = 1,
      results_width = 0.8,
      border = {},
      borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
      color_devicons = true,
      use_less = true,
      set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,
      file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
      grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
      qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
      mappings = {
        i = {
          ["<C-c>"] = actions.close,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<c-t>"] = trouble.open_with_trouble,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          -- To disable a keymap, put [map] = false
          -- So, to not map "<C-n>", just put
          -- ["<c-x>"] = false,
          -- ["<esc>"] = actions.close,

          -- Otherwise, just set the mapping to the function that you want it to be.
          -- ["<C-i>"] = actions.select_horizontal,

          -- Add up multiple actions
          ["<CR>"] = actions.select_default + actions.center

          -- You can perform as many actions in a row as you like
          -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<c-t>"] = trouble.open_with_trouble,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
          -- ["<C-i>"] = my_cool_custom_action,
        }
      }
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false, 
        override_file_sorter = true,
        case_mode = "smart_case"
      }
    }
  })


--[[ extensions =    fzf = {
override_generic_sorter = false; -- override the generic sorter
override_file_sorter = true;     -- override the file sorter
case_mode = "smart_case";        -- or "ignore_case" or "respect_case"
  } ]]


  -- load extensions
  require('telescope').load_extension('gh')
  require('telescope').load_extension('fzf')
end

M.config = config
--M.setup = setup

return M
