require('my.globals').doNotLoad()
require('my.globals').gVars()
require('my.options').setGlobalOptions({
 -- COLORS
 termguicolors = true;
 background = 'dark';
 t_Co = '256';
  -- BUFFER
  shiftwidth = 2;
  tabstop = 2;
  expandtab = true;
  textwidth = 120;
  shiftround  = true; -- round indent to multiple of 'shiftwidth'.
  splitbelow = true;
  splitright = true;
  --  SEARCH
  incsearch   = true;
  -- inccommand  = 'nosplit';
  laststatus  = 2;
  ignorecase  = true;
  -- FILE MANAGEMENT
  autoread    = true;
  backup      = false;
  swapfile    = false;
  undofile    = true;
  undolevels  = 5000;
  undoreload  = 10000;
  -- CHROME
  number        =  true;
  relativenumber  = true;
  helpheight    = 10;
  modeline      = false;
  equalalways   = false;  -- Don't resize windows on split or close
  title         = false;  -- No need for a title
  scrolloff     = 2;      -- Keep at least 2 lines above/below
  sidescrolloff = 30;     -- Keep at least 2 lines left/right
  showmode    = false;  --global: default on TODO turn off
 --  TEXT EDITING
  mouse       = 'a'; -- global   try nv somtime
  clipboard   = 'unnamedplus';         -- global
  guifont     = 'BlexMono Nerd Font';
})

require('my.options').setWindowOptions({
  signcolumn = 'yes:2';
})

require('plugins')

require('my.colors').setup({scheme = 'gruvbox-material', packname = 'gruvbox-material' })
--require('my.colors').setup({scheme = 'forest-night', packname = 'forzephyr-nvimest-night' })
require('plugs.statusline').init()
-- require('plugs.bufferline').init()

--require('my.autocmds').set()
-- plugins

require('plugs.dirvish').init()
-- require('plugs.gitgutter').init()

--  utility
require('plugs.commentary').init()
require('plugs.suda').init()
require('plugs.telescope') --TODO keep track use when usable
--require('treesitter_config').init()
--require('lang_server').init() -- TODO
require('my.autocmds')({
 startup = {
    {'TextYankPost', '*', "silent!", [[:lua require('vim.highlight').on_yank()]]};
    -- {'BufEnter', '*', [[:lua require('ft').init()]] };
    -- {'BufEnter', '*', [[:lua require('ft').init()]] };
    --{'InsertEnter', '*', '++once', [[:lua require('colorizer').setup { 'vim', 'json', 'css', 'javascript', 'html' }]]};
  };
})

