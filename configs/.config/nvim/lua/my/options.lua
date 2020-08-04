local M = {}
M.version = 'v0.0.1'

local tChrome = {
  -- colorcolumn   = 120;   -- Highlight the 120 th character limit
  helpheight    = 10;
  modeline      = false;
  equalalways   = false; -- Don't resize windows on split or close
  title         = false; -- No need for a title
  scrolloff     = 2;      -- Keep at least 2 lines above/below
  sidescrolloff = 30;     -- Keep at least 2 lines left/right
  -- keep signcolumn open 
  -- splitbelow = true; splitright = true; 
  -- synmaxcol  =500; 
  -- winheight = 10; ruler = true; 
}

  local tCompleteEditing = {
    pumwidth    = 30;
    pumblend    = 15;
    -- complete (default: ".,w,b,u,t")
    -- we don't have a tag file so we don't want to search for tags
    complete    = '.,w,b,u';
    shortmess   = 'filnxtToOFc';
  -- completeopt (default: "menu,preview")
    completeopt = 'menuone,noinsert,noselect';
    updatetime = 100;
    -- TODO try whichkey 500
    -- default updatetime 4000ms is not good for async update
  }


  local tTextEditing = {
    mouse       = 'a';                   -- global   try nv somtime
    clipboard   = 'unnamedplus';         -- global
    guifont     = 'BlexMono Nerd Font';
    -- listchar   = yes; 
    -- listchars   = [[eol:$,tab:>-,trail:~,extends:>,precedes:<]]; -- global or local to window
    shiftround  = true;  --global: Round indent to multiple of 'shiftwidth'. 
    showbreak   = '↪';   --global:
    showmode    = true;  --global: default on TODO turn off 
    -- startofline = false;
  }

--[[ local to window
  breakindent   = true;
  wrap
--]]

--[[
 defaults
 smarttab on
--]]

local tFileManagement = {
  autoread    = true;
  backup      = false;
  swapfile    = false;
  -- stdpath('cache'). '/undo') nvim set by default
  undofile    = true;
  undolevels  = 5000;
  undoreload  = 10000;
}

local tSearch = {
  incsearch   = true;
  inccommand  = 'nosplit';
  laststatus  = 2;
  ignorecase  = true;
}

-- WINDOW OPTIONS
--
local tWindowOptions = {
  signcolumn = 'yes:3';
}


-- BUFFER OPTIONS
--
local tBufferOptions = {
  --omnifunc = vim.lsp.omnifunc,
  shiftwidth = 2,
  tabstop = 2,
  expandtab = true,
  textwidth = 120
}
local tLSPBufferOptions = {
  --omnifunc = vim.lsp.omnifunc,
  shiftwidth = 2,
}


local setGlobalOptions = function( tbl )
  for key,value in pairs( tbl ) do
    -- print( key .. ': ' .. tostring(vim.o[key]) )
    vim.o[key] = value
  end
end

local setBufferOptions = function( tbl )
  for key,value in pairs( tbl ) do
    -- print( key .. ': ' .. tostring(vim.o[key]) )
    vim.bo[key] = value
  end
end

local setCommonBufferOptions = function()
  setBufferOptions( tBufferOptions )
end

local setWindowOptions = function( tbl ) 
  for key,value in pairs( tbl ) do
    --print( key .. ': ' .. tostring(vim.o[key]) )
    vim.wo[key] = value
  end
end

local oAll = function()
	--print( ' setting global options ' )
	setGlobalOptions( tSearch )
	setGlobalOptions( tChrome )
	setGlobalOptions( tCompleteEditing )
	setGlobalOptions( tTextEditing )
	setGlobalOptions( tFileManagement )
	setWindowOptions( tWindowOptions )
end

M.oAll = oAll
M.setBufferOptions = setBufferOptions
M.setWindowOptions = setWindowOptions
M.setCommonBufferOptions = setCommonBufferOptions
-- return M.setWindowOptions( tWindows )
return M
