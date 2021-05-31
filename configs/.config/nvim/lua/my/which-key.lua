
local M = {}
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
