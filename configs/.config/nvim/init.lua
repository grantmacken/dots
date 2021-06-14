--- vim:sw=2 fdm=marker
--- {{{ [[ local functions ]]
local fn = vim.fn
local exec = vim.api.nvim_exec
local km =   vim.api.nvim_set_keymap
local vars = require('my.globals').set_vars
local options = require('my.globals').set_options
local global_options = require('my.globals').set_global_options
-- }}}
-- {{{ - [[ disable builtin plugins ]]
vars({
  loaded_gzip         = 1;
  loaded_tar          = 1;
  loaded_tarPlugin    = 1;
  loaded_zipPlugin    = 1;
  loaded_2html_plugin = 1;
  loaded_netrw        = 1;
  loaded_netrwPlugin  = 1;
  loaded_matchit      = 1;
  loaded_matchparen   = 1;
  loaded_spec         = 1;
})
-- }}}
-- {{{ - [[ create globally scoped functions ]]
tab_complete =  require('my.globals').tab_complete
s_tab_complete = require('my.globals').s_tab_complete
-- }}}
-- {{{ - [[ options - with global scope and set default colorscheme ]]
global_options({
  guifont     = 'BlexMono Nerd Font';
  encoding = "UTF-8";
  termguicolors = true;
  hidden = true; -- I think this is default
  showtabline = 1;
  updatetime = 300;
  showmatch = true;
  laststatus = 2;
  wildignore = { ".git", "*/node_modules/*"};
  ignorecase = true;
  smartcase = true;
  clipboard = "unnamed";
})
 vim.cmd('colorscheme everforest')

--- }}}
--- {{{ [[ options - file management ]]
options({ -- file management
  autoread = true;
  backup = false;       -- nope
  writebackup = false;  -- nope
  swapfile = false;     -- nope
  undofile    = true;  -- ok use undo
  undolevels  = 5000;    --  with lots of undolevels
  undoreload  = 10000;     -- and reloads
})
--- }}}
--- {{{ [[ options - chrome ]]
options({ 
  number = true;
  signcolumn = 'number'; -- Display signs in the number column
  showmode = false;
  pumblend = 10;
  -- splits
  splitbelow = true;
  splitright = true;
  shortmess  = vim.o.shortmess .. 'cI'; -- No startup screen, no ins-completion-menu messages
})
--- }}}
--- {{{ [[ options - editing ]]
options({
  mouse = 'nv';
  cursorline = true;
  wrap = false;
  expandtab = true;     -- Insert 2 spaces for a tab
  tabstop = 2;          -- Change the number of space characters inserted for indentation
  shiftwidth = 2;       -- Converts tabs to spaces
  --  search behaviour
  incsearch   = true;
  inccommand  = 'split'; -- default is nosplit
  updatetime  = 100;
  list = true;
  linebreak = true;
  breakindent = true;
})
--- }}}
--- {{{ [[ options - external programs ]]
options({ -- can be overidden with buffer-local options
  grepformat  = "%f:%l:%c:%m";
  grepprg     = 'rg --hidden --vimgrep --smart-case --';
  -- formatprg = 'prettier --stdin-filepath=%'
})
--- }}}
--{{{ - [[ initial key bind mappings ]]
--- {{{ space as leader key
km('', '<Space>', '<Nop>', { noremap = true, silent=true})
vars({
  mapleader = " ";
  maplocalleader = " ";
})
--}}}
km('', 'Y', 'y$', {}) -- consistency.
km('', 'Q', '', {})   -- nope - use gQ
-- }}}
--- {{{ [[ load packer ]]
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
--}}}
-- {{{ - [[ packer configuration startup ]]
require('packer').startup( function()
  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}
 -- {{{ - [[ luarocks ]]
  use_rocks {'lua-resty-http'}
  use_rocks {'lua-cjson'}
  -- }}}
  -- APPEARANCE
  --{{{ colors and  icons
 -- use { 'rktjmp/lush.nvim' }
  use { "briones-gabriel/darcula-solid.nvim", requires = "rktjmp/lush.nvim" }
  use {'MordechaiHadad/nvim-papadark', requires = {'rktjmp/lush.nvim'}}
  use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
  use { 'Iron-E/nvim-highlite' }
  use { 'shaunsingh/seoul256.nvim',
    --opt = false,
    --setup = require('my.seoul256').setup,
    --config = require('my.seoul256').config
  }
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
  use { --TODO
    'hoob3rt/lualine.nvim',
    config = require('my.lualine').config
}
-- bufferline
-- @see https://github.com/akinsho/nvim-bufferline.lua
  use { -- TODO
    'akinsho/nvim-bufferline.lua',
    config = require('my.bufferline').config
  }
-- }}}
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

-- }}}
-- {{{ - [[ commands ]]
-- use vim.lsp.buf.formatting()
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
-- LspLog: take a quick peek at the latest LSP log messages. Useful for debugging
-- LspStop: stop all active clients
-- Redirect: show the results of an ex command in a buffer rather than the built-in pager
exec([[
command! LspLog execute '<mods> pedit +$' v:lua.vim.lsp.get_log_path()
command! LspStop lua vim.lsp.stop_client(vim.lsp.get_active_clients())
command! -nargs=* -complete=command Redirect <mods> new | setl nonu nolist noswf bh=wipe bt=nofile | call append(0, split(execute(<q-args>), "\n"))
]], false)

--}}}
-- {{{ - [[ key bind mappings
-- Window navigation
km('n', '<M-j>', '<C-w>j', { silent = true })
km('n', '<M-k>', '<C-w>k', { silent = true })
km('n', '<M-h>', '<C-w>h', { silent = true })
km('n', '<M-l>', '<C-w>l', { silent = true })

-- Indent selected lines
km('v', '<', '<gv', { noremap = true, silent = true })
km('v', '>', '>gv', { noremap = true, silent = true })
--[[ km("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
km("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
km("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
km("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
km("i", "<C-Space>", "compe#confirm()", {expr = true})
km("i", "<C-e>", "compe#close('<C-e>')", {expr = true})

km("i", "<C-f>", "compe#scroll({ 'delta': +4 }", {expr = true})
km("i", "<C-d>", "compe#scroll({ 'delta': -4 }", {expr = true}) ]]
--vim.api.nvim_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', {noremap = true,silent = true})
--vim.api.nvim_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', {noremap = true,silent = true})
--vim.api.nvim_set_keymap('n', '<leader>wl', '<cmd><CR>', {noremap = true,silent = true})
-- use which keys
-- remap.keys()
--}}}
-- {{{ - [[ auto commands ]]
local augroups = require('my.globals').create_augroups
augroups({
    Lint = {
      {"BufWritePost", [[<buffer> lua require('lint').try_lint()]]};
    };
    Lightbulb = {
      {"CursorHold,CursorHoldI", [[* silent! lua require'nvim-lightbulb'.update_lightbulb()]]};
    };
    Yank = {
      {"TextYankPost", [[* silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=400})]]};
    };
    Terminal = {
      {"TermOpen", [[* tnoremap <buffer> <Esc> <c-\><c-n>]]};
      {"TermOpen", [[* set nonu]]};
    };
})
 -- }}}
