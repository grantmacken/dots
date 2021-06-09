M = {}

-- before plugin enabled
-- local setup = function() end

-- after plugin enabled
local config = function()
  local bar_fg = "#ECEFF4"
  local activeBuffer_fg = "#ECEFF4"
  require("bufferline").setup {
    options = {
        numbers = "ordinal",
        number_style = "none",
        offsets = {{filetype = "NvimTree", text = "Explorer"}},
        buffer_close_icon = "",
        modified_icon = "",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 14,
        max_prefix_length = 13,
        tab_size = 20,
        show_tab_indicators = true,
        enforce_regular_tabs = false,
        view = "multiwindow",
        show_buffer_close_icons = true,
        separator_style = "thin",
        mappings = "true",
        always_show_bufferline = false,
        diagnostics = "nvim_lsp",
    },
    -- bar colors!!
    highlights = {
        fill = {
            guifg = "#2e3440",
            guibg = "#2e3440"
        },
        background = {
            guifg = bar_fg,
            guibg = "#2e3440"
        },
        -- buffer
        buffer_selected = {
            guifg = activeBuffer_fg,
            guibg = "3b4252",
            gui = "bold"
        },
        buffer_visible = {
            guifg = "#ECEFF4",
            guibg = "#2e3440"
        },
        -- tabs over right
        tab = {
            guifg = "#ECEFF4",
            guibg = "#2e3440"
        },
        tab_selected = {
            guifg = "#ECEFF4",
            guibg = "#2e3440"
        },
        tab_close = {
            guifg = "#ECEFF4",
            guibg = "#2e3440"
        },
        -- buffer separators
        separator = {
            guifg = "#2e3440",
            guibg = "#2e3440"
        },
        separator_selected = {
            guifg = "#2e3440",
            guibg = "#2e3440"
        },
        separator_visible = {
            guifg = "#2e3440",
            guibg = "#2e3440"
        },
        indicator_selected = {
            guifg = "#2e3440",
            guibg = "#2e3440"
        },
        -- modified files (but not saved)
        modified_selected = {
            guifg = "#A3BE8C",
            guibg = "#2e3440"
        },
        modified_visible = {
            guifg = "#BF616A",
            guibg = "#2e3440"
        }
    }
}
end

M.config = config
--M.setup = setup

return M



