local M = {}
M.version = 'v0.0.1'

local init = function()
  local cmd = vim.api.nvim_command
  cmd [[packadd! fzf.vim]]
  vim._update_package_paths()
  -- globals
  require('my.globals').set(
	{
	  fzf_buffers_jump = 1,
          --fzf_commits_log_options = [[--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"]],
          fzf_tags_command = [[ctags -R]],
          fzf_commands_expect = [[alt-enter,ctrl-x]],
	  fzf_action = {
               ['ctrl-t'] = 'tab split',
               ['ctrl-x'] = 'split',
              ['ctrl-v'] = 'vsplit'
          },
         --fzf_files_options = [[--bind 'ctrl-l:execute(bat --paging=always {} > /dev/tty)']] -- https://github.com/steelsojka/dotfiles2/blob/c1c176bf3fd117f8d5d60092accb8d16dc52a1ac/.vim/lua/steelvim/init/globals.lua
	})
end

M.init = init
return init()
