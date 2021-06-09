" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time("Luarocks path setup", true)
local package_path_str = "/home/gmack/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/gmack/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/gmack/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/gmack/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/gmack/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time("Luarocks path setup", false)
time("try_loadstring definition", true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time("try_loadstring definition", false)
time("Defining packer_plugins", true)
_G.packer_plugins = {
  LuaSnip = {
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16my.snippets\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/LuaSnip"
  },
  ["TrueZen.nvim"] = {
    config = { "\27LJ\2\nw\0\0\6\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\1K\0\1\0\1\0\2\fnoremap\2\vsilent\2\28[[<Cmd>TZAtaraxis<CR>]]\n<F12>\6n\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/TrueZen.nvim"
  },
  ["architext.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/architext.nvim"
  },
  ["auto-session"] = {
    config = { "\27LJ\2\n≠\1\0\0\6\0\n\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0006\3\3\0009\3\4\0039\3\5\3'\5\6\0B\3\2\2'\4\a\0&\3\4\3=\3\t\2B\0\2\1K\0\1\0\26auto_session_root_dir\1\0\1\25auto_session_enabled\2\15/sessions/\ncache\fstdpath\afn\bvim\nsetup\17auto-session\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/auto-session"
  },
  ["focus.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/focus.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n(\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\rmy.signs\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["hop.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/hop.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  kommentary = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/kommentary"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18my.statusline\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  neogit = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vneogit\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/neogit"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/neoscroll.nvim"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\n≥\t\0\0\b\0&\0-'\0\0\0'\1\0\0006\2\1\0'\4\2\0B\2\2\0029\2\3\0025\4\a\0005\5\4\0004\6\3\0005\a\5\0>\a\1\6=\6\6\5=\5\b\0045\5\n\0005\6\t\0=\6\v\0055\6\f\0=\0\r\6=\6\14\0055\6\15\0=\1\r\6=\6\16\0055\6\17\0=\6\18\0055\6\19\0=\6\20\0055\6\21\0=\6\22\0055\6\23\0=\6\24\0055\6\25\0=\6\26\0055\6\27\0=\6\28\0055\6\29\0=\6\30\0055\6\31\0=\6 \0055\6!\0=\6\"\0055\6#\0=\6$\5=\5%\4B\2\2\1K\0\1\0\15highlights\21modified_visible\1\0\2\nguifg\f#BF616A\nguibg\f#2e3440\22modified_selected\1\0\2\nguifg\f#A3BE8C\nguibg\f#2e3440\23indicator_selected\1\0\2\nguifg\f#2e3440\nguibg\f#2e3440\22separator_visible\1\0\2\nguifg\f#2e3440\nguibg\f#2e3440\23separator_selected\1\0\2\nguifg\f#2e3440\nguibg\f#2e3440\14separator\1\0\2\nguifg\f#2e3440\nguibg\f#2e3440\14tab_close\1\0\2\nguifg\f#ECEFF4\nguibg\f#2e3440\17tab_selected\1\0\2\nguifg\f#ECEFF4\nguibg\f#2e3440\btab\1\0\2\nguifg\f#ECEFF4\nguibg\f#2e3440\19buffer_visible\1\0\2\nguifg\f#ECEFF4\nguibg\f#2e3440\20buffer_selected\1\0\2\nguibg\v3b4252\bgui\tbold\15background\nguifg\1\0\1\nguibg\f#2e3440\tfill\1\0\0\1\0\2\nguifg\f#2e3440\nguibg\f#2e3440\foptions\1\0\0\foffsets\1\0\2\ttext\rExplorer\rfiletype\rNvimTree\1\0\18\22buffer_close_icon\bÔôï\17number_style\tnone\fnumbers\fordinal\16diagnostics\rnvim_lsp\27always_show_bufferline\1\rmappings\ttrue\20separator_style\tthin\28show_buffer_close_icons\2\tview\16multiwindow\25enforce_regular_tabs\1\24show_tab_indicators\2\rtab_size\3\20\22max_prefix_length\3\r\20max_name_length\3\14\23right_trunc_marker\bÔÇ©\22left_trunc_marker\bÔÇ®\15close_icon\bÔÄç\18modified_icon\bÔëÑ\nsetup\15bufferline\frequire\f#ECEFF4\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-bufferline.lua"
  },
  ["nvim-compe"] = {
    after_files = { "/home/gmack/.local/share/nvim/site/pack/packer/opt/nvim-compe/after/plugin/compe.vim" },
    config = { "\27LJ\2\nÄ\2\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\3=\3\a\2B\0\2\1K\0\1\0\vsource\rnvim_lsp\1\0\2\rpriority\3ëN\venable\2\1\0\4\rnvim_lua\2\fluasnip\2\tpath\2\vbuffer\2\1\0\a\14preselect\fdisable\15min_length\3\2\fenabled\2\19source_timeout\3»\1\25allow_prefix_unmatch\1\21incomplete_delay\3ê\3\ndebug\1\nsetup\ncompe\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/nvim-compe"
  },
  ["nvim-lastplace"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-lastplace"
  },
  ["nvim-lightbulb"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-lightbulb"
  },
  ["nvim-lint"] = {
    config = { "\27LJ\2\n¨\2\0\0\4\0\f\0\0186\0\0\0'\2\1\0B\0\2\0025\1\4\0005\2\3\0=\2\5\1=\1\2\0006\0\6\0009\0\a\0009\0\b\0'\2\t\0+\3\1\0B\0\3\0016\0\6\0009\0\n\0'\2\v\0B\0\2\1K\0\1\0001command! Lint lua require('lint').try_lint()\bcmdn  augroup nvim_lint\n  autocmd!\n  autocmd BufWritePost * lua require('lint').try_lint()\n  augroup END\n    \14nvim_exec\bapi\bvim\ash\1\0\0\1\2\0\0\15shellcheck\18linters_by_ft\tlint\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-lint"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    config = { "\27LJ\2\n.\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\19my.lsp.servers\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-toggleterm.lua"] = {
    config = { "\27LJ\2\ny\0\1\2\0\6\1\0159\1\0\0\a\1\1\0X\1\3Ä)\1\n\0L\1\2\0X\1\bÄ9\1\0\0\a\1\2\0X\1\5Ä6\1\3\0009\1\4\0019\1\5\1\24\1\0\1L\1\2\0K\0\1\0\fcolumns\6o\bvim\rvertical\15horizontal\14directionµÊÃô\19ô≥Ê˛\3Î\1\1\0\4\0\a\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0003\3\3\0=\3\5\0024\3\0\0=\3\6\2B\0\2\1K\0\1\0\20shade_filetypes\tsize\1\0\b\14direction\15horizontal\18close_on_exit\2\17persist_size\2\20start_in_insert\2\19shading_factor\3\1\20shade_terminals\2\17hide_numbers\2\17open_mapping\n<c-\\>\0\nsetup\15toggleterm\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-toggleterm.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18my.treesitter\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["seoul256.nvim"] = {
    config = { "\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\bset\rseoul256\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/seoul256.nvim"
  },
  ["session-lens"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/session-lens"
  },
  ["suda.vim"] = {
    commands = { "SudaRead", "SudaWrite" },
    config = { "\27LJ\2\n1\0\0\2\0\3\0\0056\0\0\0009\0\1\0+\1\2\0=\1\2\0K\0\1\0\20suda_smart_edit\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/suda.vim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope-github.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/telescope-github.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\nç\a\0\0\5\0\28\0-6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0025\3\n\0005\4\v\0=\4\f\3=\3\r\0025\3\14\0=\3\15\0025\3\16\0005\4\17\0=\4\18\3=\3\19\0025\3\20\0=\3\21\0025\3\22\0=\3\23\2B\0\2\0016\0\0\0'\2\24\0B\0\2\0029\0\25\0'\2\26\0B\0\2\0016\0\0\0'\2\24\0B\0\2\0029\0\25\0'\2\23\0B\0\2\0016\0\0\0'\2\24\0B\0\2\0029\0\25\0'\2\27\0B\0\2\1K\0\1\0\17session-lens\agh\19load_extension\14telescope\bfzf\1\0\3\25override_file_sorter\2\28override_generic_sorter\1\14case_mode\15smart_case\fmatchup\1\0\1\venable\2\frainbow\16keybindings\1\0\n\14show_help\6?\14goto_node\t<cr>\21unfocus_language\6F\19focus_language\6f\28toggle_language_display\6I\27toggle_anonymous_nodes\6a\30toggle_injected_languages\6t\21toggle_hl_groups\6i\24toggle_query_editor\6o\vupdate\6R\1\0\5\venable\2\15updatetime\3\25\20persist_queries\1\19max_file_lines\3Ë\a\18extended_mode\2\15playground\1\0\2\15updatetime\3\25\venable\2\26incremental_selection\fkeymaps\1\0\3\19init_selection\f<C-A-k>\21node_decremental\f<C-A-j>\21node_incremental\f<C-A-k>\1\0\1\venable\2\vindent\1\0\1\venable\2\14highlight\1\0\1\venable\2\21ensure_installed\1\0\0\1\t\0\0\tbash\bcss\thtml\15javascript\tjson\blua\tyaml\nquery\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-dirvish"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/vim-dirvish"
  },
  ["vim-eunuch"] = {
    commands = { "Delete", "Remove", "Move", "Chmod", "Wall", "Rename" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-eunuch"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/vim-matchup"
  },
  ["vim-sayonara"] = {
    commands = { "Sayonara" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-sayonara"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\ni\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rspelling\1\0\0\1\0\2\fenabled\2\16suggestions\3\20\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time("Defining packer_plugins", false)
-- Setup for: nvim-compe
time("Setup for nvim-compe", true)
try_loadstring("\27LJ\2\nˇ\2\0\0\2\0\f\0)6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0006\0\0\0009\0\1\0)\1\1\0=\1\5\0006\0\0\0009\0\1\0)\1\1\0=\1\6\0006\0\0\0009\0\1\0)\1\1\0=\1\a\0006\0\0\0009\0\1\0)\1\1\0=\1\b\0006\0\0\0009\0\1\0)\1\1\0=\1\t\0006\0\0\0009\0\1\0)\1\1\0=\1\n\0006\0\0\0009\0\1\0)\1\1\0=\1\v\0K\0\1\0\22loaded_compe_calc\25loaded_compe_vim_lsc\27loaded_compe_ultisnips\23loaded_compe_vsnip\22loaded_compe_omni\23loaded_compe_emoji\28loaded_compe_treesitter\22loaded_compe_tags\23loaded_compe_spell\31loaded_compe_snippets_nvim\6g\bvim\0", "setup", "nvim-compe")
time("Setup for nvim-compe", false)
time("packadd for nvim-compe", true)
vim.cmd [[packadd nvim-compe]]
time("packadd for nvim-compe", false)
-- Setup for: seoul256.nvim
time("Setup for seoul256.nvim", true)
try_loadstring("\27LJ\2\nÄ\1\0\0\2\0\5\0\r6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\3\0006\0\0\0009\0\1\0+\1\2\0=\1\4\0K\0\1\0 seoul256_disable_background\21seoul256_borders\22seoul256_contrast\6g\bvim\0", "setup", "seoul256.nvim")
time("Setup for seoul256.nvim", false)
time("packadd for seoul256.nvim", true)
vim.cmd [[packadd seoul256.nvim]]
time("packadd for seoul256.nvim", false)
-- Config for: indent-blankline.nvim
time("Config for indent-blankline.nvim", true)
try_loadstring("\27LJ\2\n\v\0\0\1\0\0\0\1K\0\1\0\0", "config", "indent-blankline.nvim")
time("Config for indent-blankline.nvim", false)
-- Config for: gitsigns.nvim
time("Config for gitsigns.nvim", true)
try_loadstring("\27LJ\2\n(\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\rmy.signs\frequire\0", "config", "gitsigns.nvim")
time("Config for gitsigns.nvim", false)
-- Config for: neoscroll.nvim
time("Config for neoscroll.nvim", true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time("Config for neoscroll.nvim", false)
-- Config for: TrueZen.nvim
time("Config for TrueZen.nvim", true)
try_loadstring("\27LJ\2\nw\0\0\6\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\1K\0\1\0\1\0\2\fnoremap\2\vsilent\2\28[[<Cmd>TZAtaraxis<CR>]]\n<F12>\6n\20nvim_set_keymap\bapi\bvim\0", "config", "TrueZen.nvim")
time("Config for TrueZen.nvim", false)
-- Config for: nvim-bufferline.lua
time("Config for nvim-bufferline.lua", true)
try_loadstring("\27LJ\2\n≥\t\0\0\b\0&\0-'\0\0\0'\1\0\0006\2\1\0'\4\2\0B\2\2\0029\2\3\0025\4\a\0005\5\4\0004\6\3\0005\a\5\0>\a\1\6=\6\6\5=\5\b\0045\5\n\0005\6\t\0=\6\v\0055\6\f\0=\0\r\6=\6\14\0055\6\15\0=\1\r\6=\6\16\0055\6\17\0=\6\18\0055\6\19\0=\6\20\0055\6\21\0=\6\22\0055\6\23\0=\6\24\0055\6\25\0=\6\26\0055\6\27\0=\6\28\0055\6\29\0=\6\30\0055\6\31\0=\6 \0055\6!\0=\6\"\0055\6#\0=\6$\5=\5%\4B\2\2\1K\0\1\0\15highlights\21modified_visible\1\0\2\nguifg\f#BF616A\nguibg\f#2e3440\22modified_selected\1\0\2\nguifg\f#A3BE8C\nguibg\f#2e3440\23indicator_selected\1\0\2\nguifg\f#2e3440\nguibg\f#2e3440\22separator_visible\1\0\2\nguifg\f#2e3440\nguibg\f#2e3440\23separator_selected\1\0\2\nguifg\f#2e3440\nguibg\f#2e3440\14separator\1\0\2\nguifg\f#2e3440\nguibg\f#2e3440\14tab_close\1\0\2\nguifg\f#ECEFF4\nguibg\f#2e3440\17tab_selected\1\0\2\nguifg\f#ECEFF4\nguibg\f#2e3440\btab\1\0\2\nguifg\f#ECEFF4\nguibg\f#2e3440\19buffer_visible\1\0\2\nguifg\f#ECEFF4\nguibg\f#2e3440\20buffer_selected\1\0\2\nguibg\v3b4252\bgui\tbold\15background\nguifg\1\0\1\nguibg\f#2e3440\tfill\1\0\0\1\0\2\nguifg\f#2e3440\nguibg\f#2e3440\foptions\1\0\0\foffsets\1\0\2\ttext\rExplorer\rfiletype\rNvimTree\1\0\18\22buffer_close_icon\bÔôï\17number_style\tnone\fnumbers\fordinal\16diagnostics\rnvim_lsp\27always_show_bufferline\1\rmappings\ttrue\20separator_style\tthin\28show_buffer_close_icons\2\tview\16multiwindow\25enforce_regular_tabs\1\24show_tab_indicators\2\rtab_size\3\20\22max_prefix_length\3\r\20max_name_length\3\14\23right_trunc_marker\bÔÇ©\22left_trunc_marker\bÔÇ®\15close_icon\bÔÄç\18modified_icon\bÔëÑ\nsetup\15bufferline\frequire\f#ECEFF4\0", "config", "nvim-bufferline.lua")
time("Config for nvim-bufferline.lua", false)
-- Config for: auto-session
time("Config for auto-session", true)
try_loadstring("\27LJ\2\n≠\1\0\0\6\0\n\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\b\0006\3\3\0009\3\4\0039\3\5\3'\5\6\0B\3\2\2'\4\a\0&\3\4\3=\3\t\2B\0\2\1K\0\1\0\26auto_session_root_dir\1\0\1\25auto_session_enabled\2\15/sessions/\ncache\fstdpath\afn\bvim\nsetup\17auto-session\frequire\0", "config", "auto-session")
time("Config for auto-session", false)
-- Config for: seoul256.nvim
time("Config for seoul256.nvim", true)
try_loadstring("\27LJ\2\n4\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\bset\rseoul256\frequire\0", "config", "seoul256.nvim")
time("Config for seoul256.nvim", false)
-- Config for: which-key.nvim
time("Config for which-key.nvim", true)
try_loadstring("\27LJ\2\ni\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rspelling\1\0\0\1\0\2\fenabled\2\16suggestions\3\20\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time("Config for which-key.nvim", false)
-- Config for: nvim-toggleterm.lua
time("Config for nvim-toggleterm.lua", true)
try_loadstring("\27LJ\2\ny\0\1\2\0\6\1\0159\1\0\0\a\1\1\0X\1\3Ä)\1\n\0L\1\2\0X\1\bÄ9\1\0\0\a\1\2\0X\1\5Ä6\1\3\0009\1\4\0019\1\5\1\24\1\0\1L\1\2\0K\0\1\0\fcolumns\6o\bvim\rvertical\15horizontal\14directionµÊÃô\19ô≥Ê˛\3Î\1\1\0\4\0\a\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0003\3\3\0=\3\5\0024\3\0\0=\3\6\2B\0\2\1K\0\1\0\20shade_filetypes\tsize\1\0\b\14direction\15horizontal\18close_on_exit\2\17persist_size\2\20start_in_insert\2\19shading_factor\3\1\20shade_terminals\2\17hide_numbers\2\17open_mapping\n<c-\\>\0\nsetup\15toggleterm\frequire\0", "config", "nvim-toggleterm.lua")
time("Config for nvim-toggleterm.lua", false)
-- Config for: nvim-lspinstall
time("Config for nvim-lspinstall", true)
try_loadstring("\27LJ\2\n.\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\19my.lsp.servers\frequire\0", "config", "nvim-lspinstall")
time("Config for nvim-lspinstall", false)
-- Config for: telescope.nvim
time("Config for telescope.nvim", true)
try_loadstring("\27LJ\2\nç\a\0\0\5\0\28\0-6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0025\3\n\0005\4\v\0=\4\f\3=\3\r\0025\3\14\0=\3\15\0025\3\16\0005\4\17\0=\4\18\3=\3\19\0025\3\20\0=\3\21\0025\3\22\0=\3\23\2B\0\2\0016\0\0\0'\2\24\0B\0\2\0029\0\25\0'\2\26\0B\0\2\0016\0\0\0'\2\24\0B\0\2\0029\0\25\0'\2\23\0B\0\2\0016\0\0\0'\2\24\0B\0\2\0029\0\25\0'\2\27\0B\0\2\1K\0\1\0\17session-lens\agh\19load_extension\14telescope\bfzf\1\0\3\25override_file_sorter\2\28override_generic_sorter\1\14case_mode\15smart_case\fmatchup\1\0\1\venable\2\frainbow\16keybindings\1\0\n\14show_help\6?\14goto_node\t<cr>\21unfocus_language\6F\19focus_language\6f\28toggle_language_display\6I\27toggle_anonymous_nodes\6a\30toggle_injected_languages\6t\21toggle_hl_groups\6i\24toggle_query_editor\6o\vupdate\6R\1\0\5\venable\2\15updatetime\3\25\20persist_queries\1\19max_file_lines\3Ë\a\18extended_mode\2\15playground\1\0\2\15updatetime\3\25\venable\2\26incremental_selection\fkeymaps\1\0\3\19init_selection\f<C-A-k>\21node_decremental\f<C-A-j>\21node_incremental\f<C-A-k>\1\0\1\venable\2\vindent\1\0\1\venable\2\14highlight\1\0\1\venable\2\21ensure_installed\1\0\0\1\t\0\0\tbash\bcss\thtml\15javascript\tjson\blua\tyaml\nquery\nsetup\28nvim-treesitter.configs\frequire\0", "config", "telescope.nvim")
time("Config for telescope.nvim", false)
-- Config for: lualine.nvim
time("Config for lualine.nvim", true)
try_loadstring("\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18my.statusline\frequire\0", "config", "lualine.nvim")
time("Config for lualine.nvim", false)
-- Config for: nvim-compe
time("Config for nvim-compe", true)
try_loadstring("\27LJ\2\nÄ\2\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0005\4\5\0=\4\6\3=\3\a\2B\0\2\1K\0\1\0\vsource\rnvim_lsp\1\0\2\rpriority\3ëN\venable\2\1\0\4\rnvim_lua\2\fluasnip\2\tpath\2\vbuffer\2\1\0\a\14preselect\fdisable\15min_length\3\2\fenabled\2\19source_timeout\3»\1\25allow_prefix_unmatch\1\21incomplete_delay\3ê\3\ndebug\1\nsetup\ncompe\frequire\0", "config", "nvim-compe")
time("Config for nvim-compe", false)
-- Config for: LuaSnip
time("Config for LuaSnip", true)
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16my.snippets\frequire\0", "config", "LuaSnip")
time("Config for LuaSnip", false)
-- Config for: neogit
time("Config for neogit", true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vneogit\frequire\0", "config", "neogit")
time("Config for neogit", false)
-- Config for: nvim-lint
time("Config for nvim-lint", true)
try_loadstring("\27LJ\2\n¨\2\0\0\4\0\f\0\0186\0\0\0'\2\1\0B\0\2\0025\1\4\0005\2\3\0=\2\5\1=\1\2\0006\0\6\0009\0\a\0009\0\b\0'\2\t\0+\3\1\0B\0\3\0016\0\6\0009\0\n\0'\2\v\0B\0\2\1K\0\1\0001command! Lint lua require('lint').try_lint()\bcmdn  augroup nvim_lint\n  autocmd!\n  autocmd BufWritePost * lua require('lint').try_lint()\n  augroup END\n    \14nvim_exec\bapi\bvim\ash\1\0\0\1\2\0\0\15shellcheck\18linters_by_ft\tlint\frequire\0", "config", "nvim-lint")
time("Config for nvim-lint", false)
-- Config for: nvim-treesitter
time("Config for nvim-treesitter", true)
try_loadstring("\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18my.treesitter\frequire\0", "config", "nvim-treesitter")
time("Config for nvim-treesitter", false)

-- Command lazy-loads
time("Defining lazy-load commands", true)
vim.cmd [[command! -nargs=* -range -bang -complete=file Sayonara lua require("packer.load")({'vim-sayonara'}, { cmd = "Sayonara", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Delete lua require("packer.load")({'vim-eunuch'}, { cmd = "Delete", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Remove lua require("packer.load")({'vim-eunuch'}, { cmd = "Remove", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Move lua require("packer.load")({'vim-eunuch'}, { cmd = "Move", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Chmod lua require("packer.load")({'vim-eunuch'}, { cmd = "Chmod", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Wall lua require("packer.load")({'vim-eunuch'}, { cmd = "Wall", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Rename lua require("packer.load")({'vim-eunuch'}, { cmd = "Rename", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file SudaRead lua require("packer.load")({'suda.vim'}, { cmd = "SudaRead", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file SudaWrite lua require("packer.load")({'suda.vim'}, { cmd = "SudaWrite", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
time("Defining lazy-load commands", false)

if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
