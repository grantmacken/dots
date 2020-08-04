-- https://github.com/norcalli/nvim-popterm.lua/blob/master/lua/popterm.lua
local api = vim.api
local terminals = {}
local s_popwin = -1
local p = function( obj )
 print(vim.inspect( obj ))
end

local M = {}



local config = {
	label_timeout = 5e2;
	label_colors = { ctermfg = White; ctermbg = Red; guifg = "#eee"; guibg = "#a00000" };
	label_format = "POPTERM %d";
	window_width = 0.9;
	window_height = 0.5;
}
M.config = config




-- Namespaces are used for buffer highlights and virtual text
local namespace = api.nvim_create_namespace('')



local function buf_is_popterm(bufnr)
  for i, term in pairs(terminals) do
    if term.bufnr == bufnr then return i end
  end
end

local function create_popwin(bufnr)
	local uis = api.nvim_list_uis()

	local opts = {
		relative = 'editor';
		width = config.window_width;
		height = config.window_height;
		anchor = 'NW';
		style = 'minimal';
		focusable = false;
	}
	if 0 < opts.width and opts.width <= 1 then
		opts.width = math.floor(uis[1].width * opts.width)
	end
	if 0 < opts.height and opts.height <= 1 then
		opts.height = math.floor(uis[1].height * opts.height)
	end
	opts.col = (uis[1].width - opts.width) / 2
	opts.row = (uis[1].height - opts.height) / 2
	-- api.nvim_win_set_option(win, 'winfixheight', true)
	s_popwin = api.nvim_open_win(bufnr, true, opts)
	return s_popwin
end

p(api.nvim_list_uis())
