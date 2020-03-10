local nvim_lsp = require('nvim_lsp')
local configs = require('nvim_lsp/configs')
-- Check if it's already defined for when I reload this file.
if not nvim_lsp.erlang_ls then
  nvim_lsp.erlang_ls.setup {
    configs.erlang_ls == {
      default_config = {
      name = 'erlang_ls';
      cmd = { "rebar3", "shell"};
      filetypes = {'erlang'};
      cmd_cwd = "/home/gmack/projects/erlang-ls/erlang";
      root_dir = nvim_lsp.util.find_git_root();
      log_level = 2;
      settings = {};
      };
    }
  }
end

