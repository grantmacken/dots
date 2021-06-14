
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

local tLeader = {
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
  }
}

local buffers = {

}

local keys = function()
 wk.register( tLeader )
end

--------------------------------
M.tab_complete = tab_complete
M.s_tab_complete = s_tab_complete

M.keys = keys
--return M.keys()
return M
