local configs = require('nvim_lsp/configs')
local util = require('nvim_lsp/util')
local server_name = "erlang_ls"

-- local function make_installer()
--   local P = util.path.join
--   local install_dir = P{util.base_install_dir,server_name}
--   local bin_dir = P{install_dir,'_build/default/bin'}
--   local els_bin = P{bin_dir,server_name}
--   local os
--   if vim.fn.has('osx') == 1 then
--     os = 'macOS'
--   elseif vim.fn.has('unix') == 1 then
--     os = 'Linux'
--   end
--   local X = {}
--   function X.install()
--     if os == nil then
--       error("This installer supports Linux and macOS only")
--       return
--     end
--     local install_info = X.info()
--     if install_info.is_installed then
--       print(server_name, "is already installed")
--       return
--     end

--     local script = [=[
-- set -e
-- # clone project
-- cd ]=] ..util.base_install_dir .. '\n' ..[=[
-- git clone https://github.com/erlang-ls/erlang_ls.git
-- cd ]=] .. server_name .. '\n' ..[=[
-- # build
-- make
--     ]=]

-- -- git clone into base dir 
--   util.sh(script, util.base_install_dir)
--   end

--   function X.info()
--     return {
--       is_installed = util.path.exists(els_bin);
--       install_dir = install_dir;
--       cmd = {"/home/gmack/.cache/nvim/nvim_lsp/erlang_ls/_build/default/bin/erlang_ls"};
--     }
--   end

--   -- els_bin,"--transport","stdio"
--   function X.configure(config)
--     local install_info = X.info()
--     if install_info.is_installed then
--       config.cmd = {"/home/gmack/.cache/nvim/nvim_lsp/erlang_ls/_build/default/bin/erlang_ls"};
--     end
--   end
--   return X
-- end

-- local installer = make_installer()
   -- default settings https://github.com/neovim/nvim-lsp/blob/master/lua/nvim_lsp/util.lua
   --  settings = {};
   -- init_options = {};
   --  callbacks = {};

configs[server_name] = {
  default_config = {
    cmd = {"erlang-language-server"};
    filetypes = {"erlang"};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
    };
  docs = {
    description = [[
     TODO!
    ]];
  };
}

-- configs[server_name].install = installer.install
-- configs[server_name].install_info = installer.info
