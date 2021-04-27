local M = {}
M.version = 'v0.0.1'

local init = function()
  local cmd = vim.api.nvim_command
  cmd [[packadd! vim-clap]]
  vim._update_package_paths()
  -- :help clap-keybindings
  -- :help clap-options
  require('my.globals').set(
	{
          --clap_layout {},
	  -- clap_cache_directory = vim.fn('cache') .. '/clap', default
	  clap_theme = 'material_design_dark',
	  clap_open_action = {
              ['ctrl-t'] = 'tab split',
              ['ctrl-x'] = 'split',
              ['ctrl-v'] = 'vsplit'
          },
         --fzf_files_options = [[--bind 'ctrl-l:execute(bat --paging=always {} > /dev/tty)']] -- https://github.com/steelsojka/dotfiles2/blob/c1c176bf3fd117f8d5d60092accb8d16dc52a1ac/.vim/lua/steelvim/init/globals.lua
	})

  --[[
  local sMode = 'n'
  local tOpts  = {noremap = true, silent = true}
  require('my.mappings')({
   { sMode, 'gc', '<Cmd>Commentary<CR>', tOpts };
  })
  ]]--
end

M.init = init
return M
