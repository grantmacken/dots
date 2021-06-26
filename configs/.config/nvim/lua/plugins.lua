local packer = nil
local function init()
  if packer == nil then
    packer = require('packer')
    packer.init({disable_commands = true})
  end

  local use = packer.use
  local use_rocks = packer.use_rocks
  packer.reset()
  use {'wbthomason/packer.nvim', opt = true}
 -- {{{ - [[ luarocks ]]
  use_rocks {'lua-resty-http'}
  use_rocks {'lua-cjson'}
  -- }}}
  -- APPEARANCE
  --{{{ colors and  icons
 -- use { 'rktjmp/lush.nvim' }
  use {'briones-gabriel/darcula-solid.nvim', requires = 'rktjmp/lush.nvim' }
  use {'MordechaiHadad/nvim-papadark', requires = {'rktjmp/lush.nvim'}}
  use {'npxbr/gruvbox.nvim', requires = {'rktjmp/lush.nvim' }}
  use {'Iron-E/nvim-highlite' }
  use {'shaunsingh/seoul256.nvim',
    --opt = false,
    --setup = require('my.seoul256').setup,
    --config = require('my.seoul256').config
  }
  use {'folke/tokyonight.nvim'}
  use {'Th3Whit3Wolf/one-nvim'}
  use {'savq/melange'}
  use { 'lourenci/github-colors' }
  use {'sainnhe/everforest'}
  use {'sainnhe/edge'}
  use{ 'sainnhe/gruvbox-material' }
  use {'marko-cerovac/material.nvim'--,
    --[[ opt = false,
    setup = require('my.material').setup,
    config = require('my.material').config ]]
  }

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
--}}}
--{{{ - [[ statusline bufferline ]]
  --
  --[[ use {'tjdevries/express_line.nvim',
    --config = require('my.express_line').config
  } ]]

  --[[ use { --TODO
    'hoob3rt/lualine.nvim',
   config = require('my.lualine').config
} ]]
-- bufferline
-- @see https://github.com/akinsho/nvim-bufferline.lua
-- [[
--use { -- TODO
 --   'akinsho/nvim-bufferline.lua',
 --   config = require('my.bufferline').config
 -- }
--]]




-- }}}

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
  'tamago324/lir.nvim',
  requires = {
    {'nvim-lua/popup.nvim'},
    {'kyazdani42/nvim-web-devicons'}
  },
  config = require('my.lir').config
}
  use {
    'tpope/vim-eunuch',
    cmd = { 'Delete', 'Remove', 'Move','Chmod', 'Wall', 'Rename'}
  }
-- {{{ - [[ file management and navigation ]]
  use { 'lambdalisue/suda.vim',
    cmd = { 'SudaRead', 'SudaWrite'},
    startup = function() vim.g.suda_smart_edit = true end
}

-- navigation
 -- A file explorer tree for neovim written in lua.
--  use {"kyazdani42/nvim-tree.lua",config = function() require("my.plugins.nvimtree") end,}
-- use {'justinmk/vim-dirvish'}

  use {
    'nvim-lua/telescope.nvim',
    config = require([[my.telescope]]).config,
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-github.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      {'rmagatti/session-lens',
        requires = {'rmagatti/auto-session'},
        config = function()
          require('session-lens').setup({})
        end
      }
    }
  }
-- }}}
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
    -- run = ':TSUpdate',
    config = require('my.treesitter').config,
    requires = {
      {'nvim-treesitter/playground'},
      {'nvim-treesitter/nvim-treesitter-textobjects'},
      {'vigoux/architext.nvim'},
      {'p00f/nvim-ts-rainbow'},
      {'andymass/vim-matchup'},
      {
        'lewis6991/spellsitter.nvim',
        config = require('my.spellsitter').config,
      }
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
      use {
       "ahmedkhalf/lsp-rooter.nvim",
       config = function() require("lsp-rooter").setup({}) end
      }
   --   { 'jose-elias-alvarez/nvim-lsp-ts-utils', branch = 'develop'}, -- TODO
   --   { 'jose-elias-alvarez/null-ls.nvim' } --TODO
    }
  }

  use {'mfussenegger/nvim-lint', config = require('my.lint').config }
    -- Auto completion plugin for nvim written in Lua.
  --
  -- {{{ - [[ completions ]]
  --[[ use {
    "hrsh7th/nvim-compe",
    setup =  require("my.compe").setup,
    config = require("my.compe").config,
    requires = {
      {
        "L3MON4D3/LuaSnip",
        config = function() require("my.snippets") end,
      },
    },
  } ]]
-- }}}
  -- TODO trying ...
-- use {'beauwilliams/focus.nvim'}
use {'phaazon/hop.nvim'}
-- use {'ethanholz/nvim-lastplace'}

use { -- TODOp
   'romgrk/barbar.nvim',
   requires = { 'kyazdani42/nvim-web-devicons'}
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

end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end
})

return plugins


