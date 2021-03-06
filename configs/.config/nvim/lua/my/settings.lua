



local global_opt = vim.opt_global
-- global
global_opt.path:append("**")
global_opt.termguicolors = true
global_opt.hidden = true
global_opt.showtabline = 1
global_opt.updatetime = 300
global_opt.showmatch = true
global_opt.laststatus = 2
global_opt.wildignore = { ".git", "*/node_modules/*"}
global_opt.ignorecase = true
global_opt.smartcase = true
global_opt.clipboard = "unnamed"

--[[ set in compe
-- global_opt.shortmess:remove("F"):append("c")
-- global_opt.completeopt = { "menu", "menuone", "noselect" }
--]]

local opt = vim.opt
opt.mouse = "a"           -- enable mouse
opt.errorbells = false
opt.visualbell = true
opt.guifont     = 'BlexMono Nerd Font'
opt.number = true        -- set numbered lines
opt.relativenumber  = true   --
opt.title = false        -- Nope to setting the terminal title
opt.showmode = false
opt.background = "dark"
-- file management
opt.autoread = true
opt.backup = false       -- nope
opt.writebackup = false  -- nope
opt.swapfile = false     -- nope
opt.undofile    = true  -- ok use undo
opt.undolevels  = 5000     --  with lots of undolevels
opt.undoreload  = 10000     -- and reloads
-- windows
opt.cursorline = true    -- Enable highlighting of the current line
opt.wrap = false
opt.signcolumn = "yes"
-- buffers
opt.expandtab = true     -- Insert 2 spaces for a tab
opt.tabstop = 2          -- Change the number of space characters inserted for indentation
opt.shiftwidth = 2       -- Converts tabs to spaces
opt.shiftround  = true; -- Round indent to multiple of 'shiftwidth'.
opt.smartindent = true   -- Makes indenting smart
opt.textwidth = 120;
-- splits
opt.splitbelow = true
opt.splitright = true
--  search behaviour
opt.incsearch   = true
opt.inccommand  = 'nosplit'

opt.timeout     = true;
opt.ttimeout    = true;
opt.timeoutlen  = 500;
opt.ttimeoutlen = 10;
opt.updatetime  = 100;
opt.redrawtime  = 1500;
opt.grepformat  = "%f:%l:%c:%m";
opt.grepprg     = 'rg --hidden --vimgrep --smart-case --';
