--[[
 This file can be loaded by calling `lua require('plugins')` from your init.vim
 https://github.com/wbthomason/packer.nvim
--]]
local cmd = vim.api.nvim_command
cmd('packadd packer.nvim')
vim._update_package_paths()
local packer = require('packer')
local use = packer.use
return packer.startup( function()
use {'wbthomason/packer.nvim', opt = true}
-- COLOR SCHEMES
use {'arcticicestudio/nord-vim', opt = true}
use {'arzg/vim-substrata', opt = true}
use {'junegunn/seoul256.vim', opt = true}
-- BUFFER MANAGEMENT
use {'mhinz/vim-sayonara', cmd = 'Sayonara'}
use {
  'tpope/vim-eunuch',
  opt = true,
  cmd = {
    'Delete',
    'Move',
    'Chmod',
    'Wall',
    'Rename',
    'SudoWrite',
    'SudoEdit',
    'Cfind' }
  }

-- FILE MANAGEMENT
-------------------
-- Sessions
--use {'mhinz/vim-startify', opt = false}
-- Navigation
-- use 'tpope/vim-projectionist'
use {'justinmk/vim-dirvish', opt = true}
--@ https://github.com/kyazdani42/nvim-tree.lua
-- try
use {'kyazdani42/nvim-web-devicons', opt = true} --" for file icons
use {'kyazdani42/nvim-tree.lua', opt = true}

use {'mhinz/vim-startify', opt = true}
-- -- use 'kristijanhusak/vim-dirvish-git'
-- Fuzzy Search For Files
use {'junegunn/fzf.vim', run = './install --all --xdg', opt = true }
--use {'yuki-ycino/fzf-preview.vim', run = 'pwd && npm install', opt = true}
-- Grepped Files
-- use {'mhinz/vim-grepper', cmd = 'Grepper'}
-- Quickfix files
-- use 'romainl/vim-qf'
-- use {'Olical/vim-enmasse', cmd = 'EnMasse'}
-- File icons
-- use 'ryanoasis/vim-devicons'
-- use 'tweekmonster/startuptime.vim'
-- use 'google/vim-searchindex
--  use {'mhinz/vim-startify', opt = true}
use {'airblade/vim-gitgutter', opt = true}

-- TASKS JOBS
use {'tjdevries/luvjob.nvim', opt = true }
use {'~/projects/grantmacken/express_line', opt = true}
use { 'nvim-lua/plenary.nvim', opt = true  }
--TERMINAL JOBS
-- use {'voldikss/vim-floaterm', cmd = {'FloatermNew'}}
use {'norcalli/nvim-popterm.lua', opt = true}
-- TREE-SITTER and LANGUAGE SERVERS
use {'nvim-treesitter/nvim-treesitter', opt = true}
use  {'neovim/nvim-lsp',opt = true}
use {'nvim-lua/lsp-status.nvim',opt = true }
-- completion
use {'nvim-lua/completion-nvim',opt = true,
  requires = {
    {'hrsh7th/vim-vsnip',opt = true},
    {'hrsh7th/vim-vsnip-integ',opt = true}
  }
}
-- extra sources
use    {'steelsojka/completion-buffers', opt = true}
use    {'nvim-treesitter/completion-treesitter', opt = true}
-- use {'aca/completion-tabnine', opt = true, run = "./install.sh"}
use {'nvim-lua/diagnostic-nvim',opt = true }
use {'liuchengxu/vista.vim', cmd = 'Vista'}

--  Plug 'bfredl/nvim-luadev',{ 'for': ['vim', 'lua'] }
--  Plug 'rafcamlet/nvim-luapad'
--  Plug 'norcalli/nvim-colorizer.lua'

-- TEXT EDITING
use {'psliwka/vim-smoothie', opt = true} -- smooth scrolling
-- remember key bindings
use {'liuchengxu/vim-which-key', opt = false}
-- Wrapping/delimiters
-- use 'machakann/vim-sandwich'
use {'andymass/vim-matchup', event = 'VimEnter *'}
-- use '9mm/vim-closer'
-- use 'tpope/vim-endwise'
use {'tpope/vim-surround', opt = true }
use {'tpope/vim-repeat', opt = true}
--use {'justinmk/vim-sneak'}
use {'tpope/vim-commentary', cmd = { 'Commentary', 'CommentaryLine' }}
use {'junegunn/vim-easy-align', opt = true }
use {'tpope/vim-scriptease', opt = true}
-- use 'chaoren/vim-wordmotion'
-- Markdown
use {'junegunn/goyo.vim' , opt = true}
use {'junegunn/limelight.vim', opt = true}
use {
  'iamcco/markdown-preview.nvim',
  config = 'vim.api.nvim_command("doautocmd BufEnter")',
  run = 'cd app && yarn install',
  cmd = 'MarkdownPreview'
}


end)

