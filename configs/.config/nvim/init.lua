require('my.settings')
vim.g.mapleader = ' '

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

packer.startup( function()
  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}
 -- Plugins can also depend on rocks from luarocks.org:
  use_rocks {'lua-resty-http'}
  use_rocks {'lua-cjson'}
  -- APPEARANCE
  -- colors
  use { 'shaunsingh/seoul256.nvim',
    setup = require('my.seoul256').setup,
    config = require('my.seoul256').config
}  -- icons

  use {
    'norcalli/nvim-colorizer.lua',
    config = require('my.colorizer').config
  }

  use {
    "kyazdani42/nvim-web-devicons",
    --[[ requires = {
      "yamatsum/nvim-nonicons"
  } ]]
  }


-- statusline
  use { --TODO
    'hoob3rt/lualine.nvim',
    config = function() require('my.lualine') end
}
-- bufferline
-- @see https://github.com/akinsho/nvim-bufferline.lua
  use { -- TODO
    'akinsho/nvim-bufferline.lua',
    config = require('my.bufferline').config
  }

  -- git

  use { -- TODO trying
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
      config = function() require('neogit').setup({}) end
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
    branch = "lua"
  }
-- BUFFER MANAGEMENT
  use {'mhinz/vim-sayonara',
    cmd = 'Sayonara'
  }
  use {
    'tpope/vim-eunuch',
    cmd = { 'Delete', 'Remove', 'Move','Chmod', 'Wall', 'Rename'}
  }

-- FILE MANAGEMENT
  use { 'lambdalisue/suda.vim',
    cmd = { 'SudaRead', 'SudaWrite'},
    config = function() vim.g.suda_smart_edit = true end
}
-- sessions --
--[[ use {
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
} ]]



-- navigation
  -- A file explorer tree for neovim written in lua.
 --  use {"kyazdani42/nvim-tree.lua",config = function() require("my.plugins.nvimtree") end,}
  use {'justinmk/vim-dirvish'}
  use {
    'nvim-lua/telescope.nvim',
    config = require([[my.telescope]]).config,
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-github.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    }
}
--TEXT EDITING
  -- commenting
use { "b3nj5m1n/kommentary" }
  -- remember key bindings
-- @see https://github.com/folke/which-key.nvim
  -- @ ./my/which-key.lua
use {
  "folke/which-key.nvim",
  config = require([[my.which-key]]).config
}

-- https://github.com/karb94/neoscroll.nvim
-- smooth scrolling
-- using defaults
use {
    'karb94/neoscroll.nvim',
    config = function() require('neoscroll').setup() end
  }

--TERMINAL JOBS
  use { --TODO
    'akinsho/nvim-toggleterm.lua',
    config = require('my.toggleterm').setup
  }
  -- TREESITTER
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = require('my.treesitter').config,
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
      {'kabouzeid/nvim-lspinstall', config = function() require("my.lsp.servers") end },
      -- { 'glepnir/lspsaga.nvim'},
      {'kosayoda/nvim-lightbulb'},
      { 'onsails/lspkind-nvim'}, -- OK
      --{ 'simrat39/symbols-outline.nvim', config = function() require('my.lsp.symbols-outline') end }, -- TODO add mapping
      { 'folke/trouble.nvim', config = require('my.trouble').config },
      { 'ray-x/lsp_signature.nvim'} , --OK
     -- use {
      --  "ahmedkhalf/lsp-rooter.nvim",
      --  config = function() require("lsp-rooter").setup { ignore_lsp = {'efm'}} end
      --}
   --   { 'jose-elias-alvarez/nvim-lsp-ts-utils', branch = 'develop'}, -- TODO
   --   { 'jose-elias-alvarez/null-ls.nvim' } --TODO
    }
  }
  use {'mfussenegger/nvim-lint', config = require('my.linters') }
    -- Auto completion plugin for nvim written in Lua.
  use {
    "hrsh7th/nvim-compe",
    setup =  require("my.completions").setup,
    config = require("my.completions").config,
    requires = {
      {
        "L3MON4D3/LuaSnip",
        config = function() require("my.snippets") end,
      },
    },
  }

  -- TODO trying ...
use {'beauwilliams/focus.nvim'}
use {'phaazon/hop.nvim'}
use {'ethanholz/nvim-lastplace'}

-- https://github.com/Pocco81/TrueZen.nvim#configuration
-- TODO try as replacement for goyo
  -- WIP not restoring to previous setting
  use {
    'Pocco81/TrueZen.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<F12>', '[[<Cmd>TZAtaraxis<CR>]]',{noremap = true, silent = true})
    end
  }
  use {
    'glepnir/dashboard-nvim',
    -- config = require('my.dashboard').config,
    setup = require('my.dashboard').setup
  }
end)




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
--vim.api.nvim_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', {noremap = true,silent = true})
--vim.api.nvim_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', {noremap = true,silent = true})
--vim.api.nvim_set_keymap('n', '<leader>wl', '<cmd><CR>', {noremap = true,silent = true})
-- use which keys
remap.keys()


require('my.autocmds')({
    lint = {
      {"BufWritePost", [[<buffer> lua require('lint').try_lint()]]};
    };
    lightbulb = {
      {"CursorHold,CursorHoldI", [[* silent! lua require'nvim-lightbulb'.update_lightbulb()]]};
    };
    yank = {
      {"TextYankPost", [[* silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=400})]]};
    };
})
