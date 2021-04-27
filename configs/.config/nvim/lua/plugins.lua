--[[
 This file can be loaded by calling `lua require('plugins')` from your init.vim
 https://github.com/wbthomason/packer.nvim
--]]
--
--
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
execute 'packadd packer.nvim'
return require('packer').startup( function()
  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}
  -- Plugins can also depend on rocks from luarocks.org:
  use_rocks {'lua-resty-http'}
  use_rocks {'lua-cjson'}
  use_rocks {'luaformatter', server = 'https://luarocks.org/dev'}
-- COLOR SCHEMES
  use {'arcticicestudio/nord-vim', opt = true}
  use {'arzg/vim-substrata', opt = true}
  use {'junegunn/seoul256.vim', opt = true}
  -- use {'kyazdani42/blue-moon', opt = true}
  use {'bluz71/vim-nightfly-guicolors', opt = true}
  use {'bluz71/vim-moonfly-colors', opt = true}
  use {'axvr/photon.vim',  opt = true}
  use {'jnurmine/Zenburn', opt = true}
  use {'rhysd/vim-color-spring-night', opt = true}
  use {'flrnd/plastic.vim', opt = true}
  use {'sainnhe/forest-night', opt = true}
  use {'sainnhe/edge', opt = true}
  use {'sainnhe/gruvbox-material', opt = true}
  use {'kamwitsta/nordisk', opt = true}
  use {'glepnir/zephyr-nvim', branch = 'main',opt = true}
--  STATUSLINE - BUFFERLINE
  use {'kyazdani42/nvim-web-devicons', opt = true} -- color icons
  -- use {'akinsho/nvim-bufferline.lua', opt = true}
  use {'tjdevries/express_line.nvim', opt = true  }
-- BUFFER MANAGEMENT
use {'mhinz/vim-sayonara', 
  opt = true,
  cmd = 'Sayonara'
  }
use { 'mhartington/formatter.nvim', 
  opt = true,
  config = function()
    require('formatter').setup({
      javascript = {
        prettier = function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
            stdin = true
          }
        end
      }
    })
  end
}

use {
  'tpope/vim-eunuch',
  opt = true,
  cmd = {
    'Delete',
    'Remove',
    'Move',
    'Chmod',
    'Wall',
    'Rename'}
  }
use { 'lambdalisue/suda.vim', opt = true }
-- FILE MANAGEMENT
-- Sessions
use {'mhinz/vim-startify', opt = false}
-- Navigation
-- use 'tpope/vim-projectionist'
use {'justinmk/vim-dirvish', opt = true,
  requires = {
    {'kristijanhusak/vim-dirvish-git',opt = true}
  }
}
--use {'kyazdani42/nvim-tree.lua', opt = true}
-- use {'kristijanhusak/vim-dirvish-git',opt = true }
use { 'nvim-lua/telescope.nvim', 
  requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

use {'dm1try/git_fastfix', opt = true}
-- Quickfix files
 use {'romainl/vim-qf', opt = true}
-- use {'Olical/vim-enmasse', cmd = 'EnMasse'}
-- File icons
-- use 'ryanoasis/vim-devicons'
-- use 'tweekmonster/startuptime.vim'
-- use 'google/vim-searchindex
--  use {'mhinz/vim-startify', opt = true}
use {
  'lewis6991/gitsigns.nvim',
  requires = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
   require('gitsigns').setup {
      signs = {
        add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changdelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      },
      numhl = false,
      linehl = false,
      keymaps = {
        -- Default keymap options
        noremap = true,
        buffer = true,
        ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'"},
        ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'"},

        ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
        ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',
        -- Text objects
        ['o ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
        ['x ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>'
      },
      watch_index = {
        interval = 1000
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      use_decoration_api = true,
      use_internal_diff = true,  -- If luajit is present
    }
  end
}
-- use {'airblade/vim-gitgutter', opt = true}
-- use {'lambdalisue/gina.vim', opt = true}
--[[

use { 'kdheepak/lazygit.nvim',
       opt = true,
       cmd = {
         'LazyGit',
	 'LazyGitConfig'
	}
}
]]--
-- TASKS JOBS

--TERMINAL JOBS
-- use {'nikvdp/neomux', opt = true }  -- TODO
-- use {'voldikss/vim-floaterm', cmd = {'FloatermNew'}}
-- use {'norcalli/nvim-popterm.lua', opt = true}
-- TREE-SITTER and LANGUAGE SERVERS
use {'bfredl/nvim-luadev', opt = true }  -- TODO
use {'tjdevries/nlua.nvim', opt = true } -- TODO
use {'nvim-treesitter/nvim-treesitter',opt = true}
use {'nvim-treesitter/playground', opt = true}
use {'nvim-treesitter/nvim-treesitter-textobjects', opt = true}
use {'nvim-treesitter/nvim-treesitter-refactor', opt = true}
use {'neovim/nvim-lspconfig',opt = true}
  -- use { 'nvim-lua/lsp_extensions.nvim', opt = true} -- TODO
  -- use {'RishabhRD/popfix',opt = true}
  -- use {'RishabhRD/nvim-lsputils',opt = true}
-- completion
--
use {'nvim-lua/completion-nvim',opt = true,
  requires = {
    {'hrsh7th/vim-vsnip',opt = true},
    {'hrsh7th/vim-vsnip-integ',opt = true}
  }
}
-- extra sources
use {'lewis6991/spellsitter.nvim',
  opt = true,
  config = function()
    require('spellsitter').setup()
  end
}
use {'steelsojka/completion-buffers', opt = true}
use {'nvim-treesitter/completion-treesitter', opt = true}
-- use {'aca/completion-tabnine', opt = true, run = "./install.sh"}
-- use {'nvim-lua/diagnostic-nvim',opt = true }
use {'liuchengxu/vista.vim', cmd = 'Vista'}
-- STATUS LINE
use {'nvim-lua/lsp-status.nvim',opt = true }

--  Plug 'bfredl/nvim-luadev',{ 'for': ['vim', 'lua'] }
--  Plug 'rafcamlet/nvim-luapad'
use {'norcalli/nvim-colorizer.lua', opt = false }
use {'psliwka/vim-smoothie', opt = true} -- smooth scrollino


-- SEARCH:
use {'romainl/vim-cool', opt = false}
-- TODO setup like https://jesseleite.com/posts/4/project-search-your-feelings

-- TEXT EDITING
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
-- use {'tpope/vim-scriptease', opt = true}
-- use 'chaoren/vim-wordmotion'
-- Markdown
use {'junegunn/goyo.vim' , opt = true}
use {'junegunn/limelight.vim', opt = true}
-- use  {'reedes/vim-pencil' , opt = true}     --  TODO Auto hard breaks for text files
-- use  {'reedes/vim-wordy'  , opt = true}     --  TODO Identify poor language use
-- use  {'sedm0784/vim-you-autocorrect', opt = true} -- TODO
--[[
use {
  'iamcco/markdown-preview.nvim',
  config = 'vim.api.nvim_command("doautocmd BufEnter")',
  run = 'cd app && yarn install',
  cmd = 'MarkdownPreview'
}
--]]

end
)




