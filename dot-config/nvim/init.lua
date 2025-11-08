-- Initialization =============================================================
pcall(function()
  vim.loader.enable()
  -- vim.deprecate = function() end
end)
-- disable built-in providers

local providers = { "node", "perl", "ruby", "python", "python3" }
for _, provider in ipairs(providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- disable built-in plugins
local plugins = { 'gzip', 'netrwPlugin', 'rplugin', 'tarPlugin', 'tohtml', 'tutor', 'zipPlugin', }
for _, plugin in ipairs(plugins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Load opt plugins automatically
local uv = vim.uv or vim.loop
-- Get the XDG data directory for Neovim
local data_dir = vim.fn.stdpath("data")
local pack_glob = data_dir .. "/site/pack/*/opt"
-- Expand all opt plugin directories
for _, opt_dir in ipairs(vim.fn.glob(pack_glob, true, true)) do
  local fd = uv.fs_scandir(opt_dir)
  if fd then
    while true do
      local plug_name, plug_type = uv.fs_scandir_next(fd)
      if not plug_name then break end
      if plug_type == "directory" then
        vim.pack.add({ plug_name }, { confirm = false })
      end
    end
  end
end


-- Globals -- Set leader key
vim.g.mapleader = vim.keycode("<space>")      -- Set leader key to space
vim.g.maplocalleader = vim.keycode("<space>") -- Set local leader key to space\
vim.g.projects_dir = vim.fn.expand("~") .. "/Projects"

vim.cmd.colorscheme('kanagawa-wave')

-- Enable all LSP servers in the 'lsp' config directory

local uv = vim.uv or vim.loop
local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
local fd = uv.fs_scandir(lsp_dir)
if fd then
  while true do
    local server_name, server_type = uv.fs_scandir_next(fd)
    if not server_name then break end
    local name = server_name:match("(.+)%..+$")
    -- vim.notify( 'enabled LSP server:'  .. name)
    vim.lsp.enable(name)
  end
end


-- --[[ markdown


-- mode = { "n", "v" },
-- { "<leader>m", group = "[P]markdown" },
-- { "<leader>mf", group = "[P]fold" },
-- { "<leader>mh", group = "[P]headings increase/decrease" },
-- { "<leader>ml", group = "[P]links" },
-- { "<leader>ms", group = "[P]spell" },
-- { "<leader>msl", group = "[P]language" },
--
-- -- MARKDOWN
-- keymap(
--   "<Leader>mj",
--   ":g/^\\s*$/d<CR>:nohlsearch<CR>",
--   "Delete newlines in selected text (join)",
--   "v"
-- )
--
-- keymap("<leader>mss", function()
--   -- Simulate reusing "z=" with "m" option using feed keys
--   -- vim.api.nvim_replace_term codes ensures "z=" is correctly interpreted
--   -- 'm' is the {mode}, which in this case is 'Remap keys'. This is default.
--   -- If {mode} is absent, keys are remapped.
--   --
--   -- I tried this keymap as usually with
--   vim.cmd("normal! 1z=")
--   -- But didn't work, only with nvim_feedkeys
--   -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("z=", true, false, true), "m", true)
-- end, "Spelling suggestions")
--
-- -- Undo zw, remove the word from the entry in 'spellfile'.
-- keymap("<leader>msu", function()
--   vim.cmd("normal! zug")
-- end, "Spelling undo, remove word from list")
-- -- Repeat the replacement done by |z=| for all matches with the replaced word
-- -- in the current window.
-- keymap("<leader>msr", function()
--   -- vim.cmd(":spellr")
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":spellr\n", true, false, true), "m", true)
-- end, "[P]Spelling repeat")
--
-- -- This surrounds CURRENT WORD with inline code in NORMAL MODE lamw25wmal
-- -- keymap( "gss", function()
-- --   -- Use nvim_replace_termcodes to handle special characters like backticks
-- --   local keys = vim.api.nvim_replace_termcodes("gsaiw`", true, false, true)
-- --   -- Feed the keys in visual mode ('x' for visual mode)
-- --   vim.api.nvim_feedkeys(keys, "x", false)
-- --   -- I tried these 3, but they didn't work, I assume because of the backtick character
-- --   -- vim.cmd("normal! gsa`")
-- --   -- vim.cmd([[normal! gsa`]])
-- --   -- vim.cmd("normal! gsa\\`")
-- -- end, "Surround selection with backticks (inline code)")
--
-- -- keymap('<esc>',
-- --  function()
-- --   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true), 'n', true)
-- --   vim.cmd('bd!')
-- -- end,
-- -- 'Close [t]erminal','t')
-- vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
--
-- keymap('<Leader>r', ':restart<CR>', '[r]estart nvim')
-- -- In your Neovim config (Lua)
-- keymap('gF', '<C-w>gf', 'Go to file in vertical split')
-- -- keymap('<Leader>ll', function() vim.cmd.edit( vim.lsp.log.get_filename() ) end, '[L]sp [l]og')')
-- keymap('<leader>q', '<cmd>lua vim.diagnostic.setqflist()<CR>', 'set [q]uickfix list')
--


--- Highlight on yank

-- local start_terminal_insert = vim.schedule_wrap(function(data)
--   -- Try to start terminal mode only if target terminal is current
--   if not (vim.api.nvim_get_current_buf() == data.buf and vim.bo.buftype == 'terminal') then return end
--   vim.cmd('startinsert')
-- end)
-- au('TermOpen', 'term://*', start_terminal_insert, 'Start builtin terminal in Insert mode')

-- close windows like 'help' with 'q'
-- au(
--   'FileType',
--   { 'help', 'oil' },
--   function()
--     keymap('q', '<cmd>close<cr>', 'close window')
--   end, 'Close help and oil with q'
-- )
--
-- if vim.fn.has('termguicolors') == 1 then
--   vim.g.termguicolors = true -- This is actually a global option
-- end
