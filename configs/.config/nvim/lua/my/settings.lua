local setGlobalVars = function( tbl )
  for key,value in pairs( tbl ) do
    vim.g[key] = value
  end
end

local setGlobalOptions = function( tbl )
  for key,value in pairs( tbl ) do
    vim.o[key] = value
  end
end

local setBufferOptions = function( tbl )
  for key,value in pairs( tbl ) do
    vim.bo[key] = value
  end
end

local setWindowOptions = function( tbl )
  for key,value in pairs( tbl ) do
    vim.wo[key] = value
  end
end

setGlobalVars({
  loaded_2html_plugin = 1,
  loaded_getscript = 1,
  loaded_getscriptPlugin = 1,
  loaded_gzip = 1,
  loaded_gzipPlugin = 1,
  loaded_logiPat = 1,
  loaded_matchit = 1,
  loaded_matchparen = 1,
  loaded_netrw = 1,
  loaded_netrwFileHandlers  = 1,
  loaded_netrwPlugin  = 1,
  loaded_netrwSettings  = 1,
  loaded_python_provider = 1,
  loaded_rrhelper = 1,
  loaded_tar  = 1,
  loaded_tarPlugin = 1,
  loaded_tutor_mode_plugin = 1,
  loaded_vimball = 1,
  loaded_vimballPlugin = 1,
  loaded_zip = 1,
  loaded_zipPlugin = 1,
  did_install_default_menus = 1,
  did_install_syntax_menu = 1,
})

setGlobalOptions({
 -- COLORS
 termguicolors = true;
 background = 'dark';
 t_Co = '256';
  -- indentation also specified in buffer opts
  shiftwidth = 2;
  tabstop = 2;
  expandtab = true;
  textwidth = 120;
  shiftround  = true; -- round indent to multiple of 'shiftwidth'.
  -- splits
  splitbelow = true;
  splitright = true;
  --  search behaviour
  ignorecase  = true;
  incsearch   = true;
  inccommand  = 'split'; -- incrementally show result of command
  laststatus  = 2;
  -- file management
  autoread    = true;
  backup      = false;
  swapfile    = false;
  undofile    = true;
  undolevels  = 5000;
  undoreload  = 10000;
  -- chrome
  number        =  true;
  relativenumber  = true;
  helpheight    = 10;
  modeline      = false;
  equalalways   = false;  -- Don't resize windows on split or close
  title         = false;  -- No need for a title
  scrolloff     = 2;      -- Keep at least 2 lines above/below
  sidescrolloff = 3;    -- Keep at least 2 lines left/right
  showmode    = false;  --global: default on TODO turn off
  pumblend = 10;
  pumheight = 25;
 --  TEXT EDITING
  encoding  = 'UTF-8';  
  wrap     = false;
 --  cursor
  mouse       = 'a';
  mousetime = 0;
  -- whichwrap = 'b,h,l,s,<,>,[,],~';
  -- guicursor = table.concat( tGuicursor, ',');
  virtualedit = 'block';
  clipboard   = 'unnamedplus';         -- global
  guifont     = 'BlexMono Nerd Font';
  listchars = table.concat({'tab:»·',
                            'eol:¬',
                            'nbsp:␣',
                            'extends:→',
                            'precedes:←',
                            'trail:•',},',');
  fillchars = table.concat({'eob: ',
                            'stlnc:─',
                            'diff:─'}, ',');
  completeopt = table.concat({'menuone','noselect', 'noselect', 'noinsert'},',');
  joinspaces = false;
  shada = "!,'100,<50,s10,h,:1000,/1000";
  timeout     = true;
  ttimeout    = true;
  timeoutlen  = 500;
  ttimeoutlen = 10;
  updatetime  = 100;
  redrawtime  = 1500;
  grepformat  = "%f:%l:%c:%m";
  grepprg     = 'rg --hidden --vimgrep --smart-case --';
  hidden      = true
})
 -- maybe set formatprg and grepprg

setWindowOptions({
  linebreak = true;
  breakindent = true;
  cursorline = true;
  signcolumn = 'yes:2';
  number        =  true;
  relativenumber  = true;
  list = true;
})

setBufferOptions({
 undofile = true;
 shiftwidth = 2;
 tabstop = 2;
 expandtab = true;
})
