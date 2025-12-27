-- -- Load opt plugins automatically
-- local data_dir = vim.fn.stdpath("data")
-- -- local data_dir = '/usr/local/share/nvim'
-- local uv = vim.uv
-- -- Get the XDG data directory for Neovim
-- -- Construct the glob pattern to find all opt plugin directories
-- local pack_glob = data_dir .. "/site/pack/*/opt"
-- -- Expand all opt plugin directories
-- for _, opt_dir in ipairs(vim.fn.glob(pack_glob, true, true)) do
--   local fd = uv.fs_scandir(opt_dir)
--   if fd then
--     while true do
--       local plug_name, plug_type = uv.fs_scandir_next(fd)
--       if not plug_name then break end
--       if plug_type == "directory" then
--         vim.print(plug_name)
--         vim.cmd.packadd(plug_name)
--         -- vim.pack.add({ plug_name }, { confirm = false })
--       end
--     end
--   end
-- end

local setup = require('setup')

setup.tinyInlineDiagnostic()
setup.tinyCodeAction()
setup.delimiters()
setup.aeriel()


-----@type rainbow_delimiters.config
vim.g.rainbow_delimiters = {
  strategy = {
    [''] = 'rainbow-delimiters.strategy.global',
    vim = 'rainbow-delimiters.strategy.local',
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  priority = {
    [''] = 110,
    lua = 210,
  },
  highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  },
}

--- Fzf-lua setup with custom window and preview options
--- @see https://github.com/ibhagwan/fzf-lua/blob/main/OPTIONS.md>
--- @see h: fzf-lua-customization
--- fzf is a terminal buffer in a floating window that allows for fuzzy finding of files, buffers, etc.
--- The keymaps are tmap modes for the fzf window

local ok_fzf, fzf = pcall(require, 'fzf-lua')
if ok_fzf then
  local oHeight = math.floor(vim.o.lines * 0.3)
  fzf.setup({
    winopts = {
      fullscreen = true,
      border = 'none',
      backdrop = 0,
      --col = 1,
      -- split = function()
      --   local show = require('show')
      --   local bufnr = show.buffer()
      --   local winID = show.window(bufnr)
      --   return winID
      -- end,
      preview = {
        default = 'bat', --
        layout = 'flex',
        horizontal = 'right:60%',
      },
    },
    -- files = { formatter = 'path.filename_first', },

    keymap = {
      builtin = true,
      fzf = {
        ['ctrl-d'] = 'half-page-down',
        ['ctrl-u'] = 'half-page-up',
      },
    },
  })
end
