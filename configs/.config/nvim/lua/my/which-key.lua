M = {}
-- before plugin enabled
--local setup = function() end

-- after plugin enabled
local config = function()
  local wk = require("which-key")
  wk.setup({
    plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      spelling = {
        enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
        motions = true, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gc = "Comments" },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    window = {
      border = "none", -- none, single, double, shadow
      position = "bottom", -- bottom, top
      margin = { 0, 1, 0, 1 }, -- extra window margin [top, right, bottom, left]
      padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
    },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specifiy a list manually
  })
end

M.config = config
-- M.setup = setup
return M


--[[
local wk = require("which-key")
-- local opts = { silent = true }
--[[ Default options for opts
{
  mode = "n", -- NORMAL mode
  -- prefix: use "<leader>f" for example for mapping everything related to finding files
  -- the prefix is prepended to every mapping part of `mappings`
  prefix = "",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
} ]]

--[[

wk.register({
  ["<leader>"] = {
    f = {
      name = "+file",
      f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find File" },
      g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Live Grep"},
      b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers"},
      n = { "<cmd>enew<cr>", "New File" },
    },
    b = {
      name = "+buffer",
      cn = { "<cmd>BufferLineCycleNext<CR>", "Buffer Line Cycle Next" },
      cp = { "<cmd>BufferLineCyclePrevious<CR>", "Buffer Line Cycle Previous" },
      mn = { "<cmd>BufferLineMoveNext<CR>", "Buffer Line Move Next" },
      mp = { "<cmd>BufferLineMovePrev<CR>", "Buffer Line Move Previous" },
      p = { "<cmd>BufferLinePick<CR>", "Pick Buffer" },
      d = { "<cmd>Sayonara<CR>","Delete Buffer Close Window" },
      s = { "<cmd>Sayonara!<CR>","Delete Buffer Preserve Window" },
    },
    ["c"] = {
      name = "+code",
      a = { "<cmd>lua require('lspsaga.codeaction').code_action()<cr>", "LSP Code Action" },
      d = { "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>", "LSP Line Diagnostics" },
      c = { "<cmd>lua require('lspsaga.diagnostic').show_cursor_diagnostics()<CR>", "LSP Cursor Diagnostic" },
    }
  },
  ["g"] = {
    name = "+goto",
    h = {
      "<cmd>lua require('lspsaga.provider').lsp_finder()<CR>",
      "Async LSP Finder"
    },
    s = {
      "<cmd>lua require('lspsaga.signaturehesignature_help()<CR>",
      "LSP Signature Help"
    },
      r = {
      "<cmd>lua require('lspsaga.rename').rename()<CR>",
      "LSP Rename" },
      d = {
      "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>",
      "LSP Preview Definition" },
      f = { "<cmd>Format<CR>", "Format File" },
  },
  ["K"] = { "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", "LSP Hover Doc" },
  ["["] = {
    name = "+jump_next",
    h = { "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>", "LSP Jump Diagnostic Next" },
  },
  ["]"] = {
    name = "+jump_previous",
    h = {
      "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>",
      "LSP Jump Diagnostic Prev" },
  },
  ["<A-d>"] =  { "<cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>", "Open Float Terminal)" },
})

return M
--]]
