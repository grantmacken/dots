require('my.settings')
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end
vim.cmd [[packadd packer.nvim]]
local ok, packer = pcall(require, "packer")
if not ok then
return print( 'Err: failed to load packer' )
end
local use = packer.use
local use_rocks = packer.use_rocks

local plugins = function()
  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}
 -- Plugins can also depend on rocks from luarocks.org:
  use_rocks {'lua-resty-http'}
  use_rocks {'lua-cjson'}
  -- APPEARANCE
  -- colors
  use {
    'shaunsingh/nord.nvim',
    config = function() require('my.colors') end
  }
-- icons
  use {
    "kyazdani42/nvim-web-devicons",
    --[[ requires = {
      "yamatsum/nvim-nonicons"
    } ]]
  }
-- statusline
  use { --TODO
    'hoob3rt/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          -- ... your lualine config
          theme = 'nord'
          -- ... your lualine config
        }
      }
      --require("my.statusline")
    end
}
-- bufferline
-- @see https://github.com/akinsho/nvim-bufferline.lua
  use {
    'akinsho/nvim-bufferline.lua',
    config = function()
      require("bufferline").setup({})
    end
  }
--signs
use {
  'lewis6991/gitsigns.nvim',
  requires = { 'nvim-lua/plenary.nvim'},
  config = function() require('my.signs') end
}
-- indentation
  use {
    'lukas-reineke/indent-blankline.nvim',
    branch = "lua",
    config = function()
    end
  }
-- BUFFER MANAGEMENT
  use {'mhinz/vim-sayonara',
    opt = true,
    cmd = 'Sayonara'
  }
  use {
    'tpope/vim-eunuch',
    opt = true,
    cmd = { 'Delete', 'Remove', 'Move','Chmod', 'Wall', 'Rename'}
  }

-- FILE MANAGEMENT
  use { 'lambdalisue/suda.vim',
    opt = true,
    cmd = { 'SudaRead', 'SudaWrite'},
    config = function() vim.g.suda_smart_edit = true end
}
-- sessions --
use {
  'rmagatti/auto-session',
  config = function()
    require('auto-session').setup({
      auto_session_root_dir = vim.fn.stdpath('cache')..'/sessions/';
      -- Enables/disables auto save/restore
      auto_session_enabled = true
    })
  end
}
use {
  'rmagatti/session-lens',
  requires = {'rmagatti/auto-session'}
}

-- navigation
  -- A file explorer tree for neovim written in lua.
 --  use {"kyazdani42/nvim-tree.lua",config = function() require("my.plugins.nvimtree") end,}
  use {'justinmk/vim-dirvish'}

  use { 'nvim-lua/telescope.nvim',
  requires = {
    {'nvim-lua/popup.nvim'},
    {'nvim-lua/plenary.nvim'},
    {'nvim-telescope/telescope-github.nvim'},
    {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  },
  -- the following code configures telescope.nvim to its default settings.
  config = function()
    require('telescope').setup{
      fzf = {
        override_generic_sorter = false; -- override the generic sorter
        override_file_sorter = true;     -- override the file sorter
        case_mode = "smart_case";        -- or "ignore_case" or "respect_case"
      }
    }
    require('telescope').load_extension('gh')
    require('telescope').load_extension('fzf')
    require("telescope").load_extension("session-lens")
  end
}
--TEXT EDITING
  -- commenting
use { "b3nj5m1n/kommentary" }
  -- remember key bindings
-- @see https://github.com/folke/which-key.nvim
  -- @ ./my/which-key.lua
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
      }
    end
}

-- https://github.com/karb94/neoscroll.nvim
-- smooth scrolling
-- using defaults
use {
    'karb94/neoscroll.nvim',
    config = function() require('neoscroll').setup() end
  }

-- https://github.com/Pocco81/TrueZen.nvim#configuration
-- TODO try as replacement for goyo
  -- WIP not restoring to previous setting
  use {
    'Pocco81/TrueZen.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<F12>', '[[<Cmd>TZAtaraxis<CR>]]',{noremap = true, silent = true})
    end
  }

--TERMINAL JOBS
  use { --TODO
    'akinsho/nvim-toggleterm.lua',
    config = require('my.toggleterm').setup
  }
  -- TREESITTER
  use {
    'nvim-treesitter/nvim-treesitter',
    opt = false,
    config = function() require("my.treesitter") end,
        requires = {
      {'nvim-treesitter/playground'},
      {'nvim-treesitter/nvim-treesitter-textobjects'},
      {'vigoux/architext.nvim'},
      {'p00f/nvim-ts-rainbow'},
      {'andymass/vim-matchup'}
    }
  }

-- LANGUAGE SERVER PROTOCOL
  use {
    'neovim/nvim-lspconfig',
     -- config = function() require("my.lsp").setup() end,
    requires = {
     -- { 'glepnir/lspsaga.nvim'},
      { 'onsails/lspkind-nvim'}, -- OK
   --   { 'simrat39/symbols-outline.nvim', config = function() require('my.symbols-outline') end }, -- TODO add mapping
   --   { 'folke/trouble.nvim', config = function() require('my.trouble') end },
   --   { 'ray-x/lsp_signature.nvim', config = function() require('my.signatures') end },
   --   { 'jose-elias-alvarez/nvim-lsp-ts-utils', branch = 'develop'}, -- TODO
   --   { 'jose-elias-alvarez/null-ls.nvim' } --TODO
    }
  }
    -- Auto completion plugin for nvim written in Lua.
  use {
    "hrsh7th/nvim-compe",
    config = function() require("my.completions") end,
    requires = {
      {
        "L3MON4D3/LuaSnip",
        config = function() require("my.snippets") end,
      },
    },
  }
end

packer.startup(plugins)
-- LSP
require('my.lsp.lua')
require('lspconfig').erlangls.setup({
  filetypes = { "erlang", 'escript' }
})

require('lspconfig').bashls.setup({})

require('lspconfig').jsonls.setup({
  capabilities = require('my.lsp').custom_capabilities(),
  on_attach = require('my.lsp').on_attach,
  on_init = require('my.lsp').on_init,
  root_dir = vim.loop.cwd,
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
      end
    }
  }
})
require('lspconfig').bashls.setup({})
-- setup handlers
--require('my.lsp').handlers()
vim.lsp.set_log_level("debug")
vim.cmd [[command! LSPLog  lua vim.cmd('e'..vim.lsp.get_log_path())]]
vim.cmd [[command! LSPListWorkspaces lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))]]
vim.cmd [[command! -count=1 TermGitPush  lua require'toggleterm'.exec("git push",    <count>, 12)]]

-- KEY BIND MAPPINGS
local remap = require( 'my.remaps' )
-- greate global funcs
tab_complete = remap.tab_complete
s_tab_complete = remap.s_tab_complete
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#confirm()", {expr = true})
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", {expr = true})
vim.api.nvim_set_keymap("i", "<C-f>", "compe#scroll({ 'delta': +4 }", {expr = true})
vim.api.nvim_set_keymap("i", "<C-d>", "compe#scroll({ 'delta': -4 }", {expr = true})
vim.api.nvim_set_keymap("n","<C-n>","<Cmd>NvimTreeToggle<CR>",{noremap = true,silent = true})
--vim.api.nvim_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', {noremap = true,silent = true})
--vim.api.nvim_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', {noremap = true,silent = true})
--vim.api.nvim_set_keymap('n', '<leader>wl', '<cmd><CR>', {noremap = true,silent = true})
-- use which keys
remap.keys()




