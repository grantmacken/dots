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

time([[Luarocks path setup]], true)
local package_path_str = "/home/gmack/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/gmack/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/gmack/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/gmack/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/gmack/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["TrueZen.nvim"] = {
    config = { "\27LJ\2\2w\0\0\5\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\4\0'\3\5\0005\4\6\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\28[[<Cmd>TZAtaraxis<CR>]]\n<F12>\6n\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/TrueZen.nvim"
  },
  ["architext.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/architext.nvim"
  },
  ["auto-session"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/auto-session"
  },
  ["barbar.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/barbar.nvim"
  },
  ["darcula-solid.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/darcula-solid.nvim"
  },
  edge = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/edge"
  },
  everforest = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/everforest"
  },
  ["github-colors"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/github-colors"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\2(\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\rmy.signs\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["gruvbox-material"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/gruvbox-material"
  },
  ["gruvbox.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/gruvbox.nvim"
  },
  ["hop.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/hop.nvim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  kommentary = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/kommentary"
  },
  ["lir.nvim"] = {
    config = { "\27LJ\2\2G\0\0\2\1\4\0\b-\0\0\0009\0\0\0B\0\1\0016\0\1\0009\0\2\0'\1\3\0B\0\2\1K\0\1\0\1¿\14normal! j\bcmd\bvim\16toggle_markı\5\1\0\a\0005\0C6\0\0\0'\1\1\0B\0\2\0026\1\0\0'\2\2\0B\1\2\0026\2\0\0'\3\3\0B\2\2\0026\3\0\0'\4\4\0B\3\2\0029\3\5\0035\4\6\0005\5\b\0009\6\a\0=\6\t\0059\6\n\0=\6\v\0059\6\f\0=\6\r\0059\6\14\0=\6\15\0059\6\16\0=\6\17\0059\6\18\0=\6\19\0059\6\20\0=\6\21\0059\6\22\0=\6\23\0059\6\24\0=\6\25\0059\6\26\0=\6\27\0059\6\28\0=\6\29\0059\6\30\0=\6\31\0059\6 \0=\6!\0053\6\"\0=\6#\0059\6$\2=\6%\0059\6&\2=\6'\0059\6(\2=\6)\5=\5*\0045\5+\0005\6,\0=\6-\5=\5.\4B\3\2\0016\3\0\0'\4/\0B\3\2\0029\3\5\0035\0043\0005\0051\0005\0060\0=\0062\5=\0054\4B\3\2\0012\0\0ÄK\0\1\0\roverride\1\0\0\20lir_folder_icon\1\0\0\1\0\3\ticon\bÓóø\ncolor\f#7ebae4\tname\18LirFolderNode\22nvim-web-devicons\nfloat\16borderchars\1\t\0\0\b‚ïî\b‚ïê\b‚ïó\b‚ïë\b‚ïù\b‚ïê\b‚ïö\b‚ïë\1\0\3\rwinblend\3\15\20size_percentage\4\0ÄÄÄˇ\3\vborder\2\rmappings\6P\npaste\6X\bcut\6C\tcopy\6J\0\6D\vdelete\6.\23toggle_show_hidden\6Y\14yank_path\6@\acd\6R\vrename\6N\fnewfile\6K\nmkdir\6q\tquit\6h\aup\n<C-t>\ftabedit\n<C-v>\vvsplit\n<C-s>\nsplit\6l\1\0\0\tedit\1\0\3\16hide_cursor\2\22show_hidden_files\1\20devicons_enable\2\nsetup\blir\26lir.clipboard.actions\21lir.mark.actions\16lir.actions\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/lir.nvim"
  },
  ["lsp-rooter.nvim"] = {
    config = { "\27LJ\2\2<\0\0\2\0\3\0\a6\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\1K\0\1\0\nsetup\15lsp-rooter\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/lsp-rooter.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/lush.nvim"
  },
  ["material.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/material.nvim"
  },
  melange = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/melange"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\0027\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/neoscroll.nvim"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\2;\0\0\2\0\3\0\a6\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\1K\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-highlite"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-highlite"
  },
  ["nvim-lightbulb"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-lightbulb"
  },
  ["nvim-lint"] = {
    config = { "\27LJ\2\2¨\2\0\0\3\0\f\0\0186\0\0\0'\1\1\0B\0\2\0025\1\4\0005\2\3\0=\2\5\1=\1\2\0006\0\6\0009\0\a\0009\0\b\0'\1\t\0+\2\1\0B\0\3\0016\0\6\0009\0\n\0'\1\v\0B\0\2\1K\0\1\0001command! Lint lua require('lint').try_lint()\bcmdn  augroup nvim_lint\n  autocmd!\n  autocmd BufWritePost * lua require('lint').try_lint()\n  augroup END\n    \14nvim_exec\bapi\bvim\ash\1\0\0\1\2\0\0\15shellcheck\18linters_by_ft\tlint\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-lint"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    config = { "\27LJ\2\2.\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\19my.lsp.servers\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-papadark"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-papadark"
  },
  ["nvim-toggleterm.lua"] = {
    config = { "\27LJ\2\2y\0\1\2\0\6\1\0159\1\0\0\a\1\1\0X\1\3Ä)\1\n\0L\1\2\0X\1\bÄ9\1\0\0\a\1\2\0X\1\5Ä6\1\3\0009\1\4\0019\1\5\1\24\1\0\1L\1\2\0K\0\1\0\fcolumns\6o\bvim\rvertical\15horizontal\14directionµÊÃô\19ô≥Ê˛\3Î\1\1\0\3\0\a\0\v6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\4\0003\2\3\0=\2\5\0014\2\0\0=\2\6\1B\0\2\1K\0\1\0\20shade_filetypes\tsize\1\0\b\19shading_factor\3\1\14direction\15horizontal\20start_in_insert\2\17open_mapping\n<c-\\>\17hide_numbers\2\18close_on_exit\2\20shade_terminals\2\17persist_size\2\0\nsetup\15toggleterm\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-toggleterm.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\2ˇ\6\0\0\5\0\30\0$6\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\0025\1\a\0005\2\4\0005\3\5\0=\3\6\2=\2\b\1=\1\3\0006\1\0\0'\2\t\0B\1\2\0029\1\n\0015\2\f\0005\3\v\0=\3\r\0025\3\14\0=\3\15\0025\3\16\0=\3\17\0025\3\18\0005\4\19\0=\4\20\3=\3\21\0025\3\22\0=\3\23\0025\3\24\0005\4\25\0=\4\26\3=\3\27\0025\3\28\0=\3\29\2B\1\2\1K\0\1\0\fmatchup\1\0\1\venable\2\frainbow\16keybindings\1\0\n\vupdate\6R\14show_help\6?\14goto_node\t<cr>\30toggle_injected_languages\6t\28toggle_language_display\6I\21unfocus_language\6F\19focus_language\6f\21toggle_hl_groups\6i\27toggle_anonymous_nodes\6a\24toggle_query_editor\6o\1\0\5\15updatetime\3\25\20persist_queries\1\venable\2\18extended_mode\2\19max_file_lines\3Ë\a\15playground\1\0\2\venable\2\15updatetime\3\25\26incremental_selection\fkeymaps\1\0\3\21node_decremental\f<C-A-j>\21node_incremental\f<C-A-k>\19init_selection\f<C-A-k>\1\0\1\venable\2\vindent\1\0\1\venable\2\14highlight\1\0\1\venable\2\21ensure_installed\1\0\0\1\t\0\0\tbash\bcss\thtml\15javascript\tjson\blua\tyaml\nquery\nsetup\28nvim-treesitter.configs\17install_info\1\0\0\nfiles\1\2\0\0\17src/parser.c\1\0\1\burl.~/projects/grantmacken/tree-sitter-xquery\vxquery\23get_parser_configs\28nvim-treesitter.parsers\frequire\0" },
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
  ["one-nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/one-nvim"
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
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/seoul256.nvim"
  },
  ["session-lens"] = {
    config = { "\27LJ\2\2>\0\0\2\0\3\0\a6\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\1K\0\1\0\nsetup\17session-lens\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/session-lens"
  },
  ["spellsitter.nvim"] = {
    config = { "\27LJ\2\2i\0\0\3\0\6\0\t6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\3\0005\2\4\0=\2\5\1B\0\2\1K\0\1\0\rcaptures\1\2\0\0\fcomment\1\0\1\ahl\rSpellBad\nsetup\16spellsitter\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/spellsitter.nvim"
  },
  ["suda.vim"] = {
    commands = { "SudaRead", "SudaWrite" },
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
    config = { "\27LJ\2\2˛\f\0\0\t\0@\0v6\0\0\0'\1\1\0B\0\2\0026\1\0\0'\2\2\0B\1\2\0026\2\0\0'\3\3\0B\2\2\0029\2\4\0025\0036\0005\4\6\0005\5\5\0=\5\a\0045\5\t\0005\6\b\0=\6\n\0055\6\v\0=\6\f\5=\5\r\0046\5\0\0'\6\14\0B\5\2\0029\5\15\5=\5\16\0044\5\0\0=\5\17\0046\5\0\0'\6\14\0B\5\2\0029\5\18\5=\5\19\0044\5\0\0=\5\20\0045\5\21\0=\5\22\0045\5\23\0=\5\24\0046\5\0\0'\6\25\0B\5\2\0029\5\26\0059\5\27\5=\5\28\0046\5\0\0'\6\25\0B\5\2\0029\5\29\0059\5\27\5=\5\30\0046\5\0\0'\6\25\0B\5\2\0029\5\31\0059\5\27\5=\5 \0046\5\0\0'\6\25\0B\5\2\0029\5!\5=\5!\0045\0051\0005\6#\0009\a\"\0=\a$\0069\a%\0=\a&\0069\a'\0=\a(\0069\a)\1=\a*\0069\a+\0009\b,\0 \a\b\a=\a-\0069\a.\0009\b/\0 \a\b\a=\a0\6=\0062\0055\0063\0009\a%\0=\a&\0069\a'\0=\a(\0069\a)\1=\a*\0069\a+\0009\b,\0 \a\b\a=\a-\6=\0064\5=\0055\4=\0047\0035\0049\0005\0058\0=\5:\4=\4;\3B\2\2\0016\2\0\0'\3\3\0B\2\2\0029\2<\2'\3=\0B\2\2\0016\2\0\0'\3\3\0B\2\2\0029\2<\2'\3>\0B\2\2\0016\2\0\0'\3\3\0B\2\2\0029\2<\2'\3?\0B\2\2\1K\0\1\0\17session-lens\bfzf\agh\19load_extension\15extensions\15fzy_native\1\0\0\1\0\3\25override_file_sorter\2\28override_generic_sorter\1\14case_mode\15smart_case\rdefaults\1\0\0\rmappings\6n\1\0\0\6i\1\0\0\t<CR>\vcenter\19select_default\n<C-q>\16open_qflist\25smart_send_to_qflist\n<c-t>\22open_with_trouble\n<C-k>\28move_selection_previous\n<C-j>\24move_selection_next\n<C-c>\1\0\0\nclose\27buffer_previewer_maker\21qflist_previewer\22vim_buffer_qflist\19grep_previewer\23vim_buffer_vimgrep\19file_previewer\bnew\19vim_buffer_cat\25telescope.previewers\fset_env\1\0\1\14COLORTERM\14truecolor\16borderchars\1\t\0\0\b‚îÄ\b‚îÇ\b‚îÄ\b‚îÇ\b‚ï≠\b‚ïÆ\b‚ïØ\b‚ï∞\vborder\19generic_sorter\29get_generic_fuzzy_sorter\25file_ignore_patterns\16file_sorter\19get_fzy_sorter\22telescope.sorters\20layout_defaults\rvertical\1\0\1\vmirror\1\15horizontal\1\0\0\1\0\1\vmirror\1\17find_command\1\0\16\19results_height\3\1\21sorting_strategy\15descending\19preview_cutoff\3x\20selection_caret\tÔÅ§ \18results_width\4ö≥ÊÃ\tô≥¶ˇ\3\ruse_less\2\20layout_strategy\15horizontal\17shorten_path\2\20prompt_position\vbottom\nwidth\4\0ÄÄ†ˇ\3\17entry_prefix\a  \18prompt_prefix\tÔë´ \19color_devicons\2\23selection_strategy\nreset\rwinblend\3\0\17initial_mode\vinsert\1\a\0\0\arg\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\nsetup\14telescope trouble.providers.telescope\22telescope.actions\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/tokyonight.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\2ö\t\0\0\5\0(\0E6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\3\0005\2\4\0005\3\5\0=\3\6\0025\3\a\0=\3\b\0025\3\t\0=\3\n\0025\3\v\0=\3\f\0025\3\r\0=\3\14\2=\2\15\0015\2\16\0=\2\17\1B\0\2\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2\22\0'\3\23\0005\4\24\0B\0\5\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2\25\0'\3\26\0005\4\27\0B\0\5\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2\28\0'\3\29\0005\4\30\0B\0\5\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2\31\0'\3 \0005\4!\0B\0\5\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2\"\0'\3#\0005\4$\0B\0\5\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2%\0'\3&\0005\4'\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2*<cmd>TroubleToggle lsp_references<cr>\agR\1\0\2\vsilent\2\fnoremap\2$<cmd>TroubleToggle quickfix<cr>\15<leader>gq\1\0\2\vsilent\2\fnoremap\2#<cmd>TroubleToggle loclist<cr>\15<leader>gl\1\0\2\vsilent\2\fnoremap\0024<cmd>TroubleToggle lsp_document_diagnostics<cr>\15<leader>gd\1\0\2\vsilent\2\fnoremap\0025<cmd>TroubleToggle lsp_workspace_diagnostics<cr>\15<leader>gw\1\0\2\vsilent\2\fnoremap\2\27<cmd>TroubleToggle<cr>\15<leader>gx\6n\20nvim_set_keymap\bapi\bvim\nsigns\1\0\5\nerror\bÔôô\16information\bÔëâ\fwarning\bÔî©\thint\bÔ†µ\nother\bÔ´†\16action_keys\16toggle_fold\1\3\0\0\azA\aza\15open_folds\1\3\0\0\azR\azr\16close_folds\1\3\0\0\azM\azm\15jump_close\1\2\0\0\6o\tjump\1\3\0\0\t<cr>\n<tab>\1\0\t\nhover\6K\16toggle_mode\6m\nclose\6q\frefresh\6r\vcancel\n<esc>\fpreview\6p\rprevious\6k\19toggle_preview\6P\tnext\6j\1\0\v\16ident_lines\2\nicons\2\16fold_closed\bÔë†\14auto_open\1\vheight\3\a\14fold_open\bÔëº\15auto_close\1\14auto_fold\1\tmode\30lsp_workspace_diagnostics\29use_lsp_diagnostic_signs\1\17auto_preview\2\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/trouble.nvim"
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
    config = { "\27LJ\2\2Œ\4\0\0\5\0\28\0\0316\0\0\0'\1\1\0B\0\2\0029\1\2\0005\2\b\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0=\4\a\3=\3\t\0025\3\n\0=\3\v\0025\3\f\0=\3\r\0025\3\14\0005\4\15\0=\4\16\0035\4\17\0=\4\18\3=\3\19\0025\3\21\0005\4\20\0=\4\22\0035\4\23\0=\4\24\3=\3\25\0025\3\26\0=\3\27\2B\1\2\1K\0\1\0\vhidden\1\t\0\0\r<silent>\n<cmd>\n<Cmd>\t<CR>\tcall\blua\a^:\a^ \vlayout\nwidth\1\0\2\bmax\0032\bmin\3\20\vheight\1\0\1\fspacing\3\3\1\0\2\bmax\3\25\bmin\3\4\vwindow\fpadding\1\5\0\0\3\2\3\2\3\2\3\2\vmargin\1\5\0\0\3\0\3\1\3\0\3\1\1\0\2\rposition\vbottom\vborder\tnone\nicons\1\0\3\15breadcrumb\a¬ª\14separator\b‚ûú\ngroup\6+\14operators\1\0\1\agc\rComments\fplugins\1\0\3\14show_help\2\rtriggers\tauto\19ignore_missing\1\fpresets\1\0\a\fwindows\2\fmotions\2\14operators\2\6z\2\bnav\2\6g\2\17text_objects\2\rspelling\1\0\2\fenabled\2\16suggestions\3\20\1\0\2\nmarks\2\14registers\2\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\2\2;\0\0\2\0\3\0\a6\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\1K\0\1\0\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\0027\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\2(\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\rmy.signs\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: session-lens
time([[Config for session-lens]], true)
try_loadstring("\27LJ\2\2>\0\0\2\0\3\0\a6\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\1K\0\1\0\nsetup\17session-lens\frequire\0", "config", "session-lens")
time([[Config for session-lens]], false)
-- Config for: lir.nvim
time([[Config for lir.nvim]], true)
try_loadstring("\27LJ\2\2G\0\0\2\1\4\0\b-\0\0\0009\0\0\0B\0\1\0016\0\1\0009\0\2\0'\1\3\0B\0\2\1K\0\1\0\1¿\14normal! j\bcmd\bvim\16toggle_markı\5\1\0\a\0005\0C6\0\0\0'\1\1\0B\0\2\0026\1\0\0'\2\2\0B\1\2\0026\2\0\0'\3\3\0B\2\2\0026\3\0\0'\4\4\0B\3\2\0029\3\5\0035\4\6\0005\5\b\0009\6\a\0=\6\t\0059\6\n\0=\6\v\0059\6\f\0=\6\r\0059\6\14\0=\6\15\0059\6\16\0=\6\17\0059\6\18\0=\6\19\0059\6\20\0=\6\21\0059\6\22\0=\6\23\0059\6\24\0=\6\25\0059\6\26\0=\6\27\0059\6\28\0=\6\29\0059\6\30\0=\6\31\0059\6 \0=\6!\0053\6\"\0=\6#\0059\6$\2=\6%\0059\6&\2=\6'\0059\6(\2=\6)\5=\5*\0045\5+\0005\6,\0=\6-\5=\5.\4B\3\2\0016\3\0\0'\4/\0B\3\2\0029\3\5\0035\0043\0005\0051\0005\0060\0=\0062\5=\0054\4B\3\2\0012\0\0ÄK\0\1\0\roverride\1\0\0\20lir_folder_icon\1\0\0\1\0\3\ticon\bÓóø\ncolor\f#7ebae4\tname\18LirFolderNode\22nvim-web-devicons\nfloat\16borderchars\1\t\0\0\b‚ïî\b‚ïê\b‚ïó\b‚ïë\b‚ïù\b‚ïê\b‚ïö\b‚ïë\1\0\3\rwinblend\3\15\20size_percentage\4\0ÄÄÄˇ\3\vborder\2\rmappings\6P\npaste\6X\bcut\6C\tcopy\6J\0\6D\vdelete\6.\23toggle_show_hidden\6Y\14yank_path\6@\acd\6R\vrename\6N\fnewfile\6K\nmkdir\6q\tquit\6h\aup\n<C-t>\ftabedit\n<C-v>\vvsplit\n<C-s>\nsplit\6l\1\0\0\tedit\1\0\3\16hide_cursor\2\22show_hidden_files\1\20devicons_enable\2\nsetup\blir\26lir.clipboard.actions\21lir.mark.actions\16lir.actions\frequire\0", "config", "lir.nvim")
time([[Config for lir.nvim]], false)
-- Config for: nvim-toggleterm.lua
time([[Config for nvim-toggleterm.lua]], true)
try_loadstring("\27LJ\2\2y\0\1\2\0\6\1\0159\1\0\0\a\1\1\0X\1\3Ä)\1\n\0L\1\2\0X\1\bÄ9\1\0\0\a\1\2\0X\1\5Ä6\1\3\0009\1\4\0019\1\5\1\24\1\0\1L\1\2\0K\0\1\0\fcolumns\6o\bvim\rvertical\15horizontal\14directionµÊÃô\19ô≥Ê˛\3Î\1\1\0\3\0\a\0\v6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\4\0003\2\3\0=\2\5\0014\2\0\0=\2\6\1B\0\2\1K\0\1\0\20shade_filetypes\tsize\1\0\b\19shading_factor\3\1\14direction\15horizontal\20start_in_insert\2\17open_mapping\n<c-\\>\17hide_numbers\2\18close_on_exit\2\20shade_terminals\2\17persist_size\2\0\nsetup\15toggleterm\frequire\0", "config", "nvim-toggleterm.lua")
time([[Config for nvim-toggleterm.lua]], false)
-- Config for: nvim-lspinstall
time([[Config for nvim-lspinstall]], true)
try_loadstring("\27LJ\2\2.\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\19my.lsp.servers\frequire\0", "config", "nvim-lspinstall")
time([[Config for nvim-lspinstall]], false)
-- Config for: spellsitter.nvim
time([[Config for spellsitter.nvim]], true)
try_loadstring("\27LJ\2\2i\0\0\3\0\6\0\t6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\3\0005\2\4\0=\2\5\1B\0\2\1K\0\1\0\rcaptures\1\2\0\0\fcomment\1\0\1\ahl\rSpellBad\nsetup\16spellsitter\frequire\0", "config", "spellsitter.nvim")
time([[Config for spellsitter.nvim]], false)
-- Config for: TrueZen.nvim
time([[Config for TrueZen.nvim]], true)
try_loadstring("\27LJ\2\2w\0\0\5\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\4\0'\3\5\0005\4\6\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\28[[<Cmd>TZAtaraxis<CR>]]\n<F12>\6n\20nvim_set_keymap\bapi\bvim\0", "config", "TrueZen.nvim")
time([[Config for TrueZen.nvim]], false)
-- Config for: nvim-lint
time([[Config for nvim-lint]], true)
try_loadstring("\27LJ\2\2¨\2\0\0\3\0\f\0\0186\0\0\0'\1\1\0B\0\2\0025\1\4\0005\2\3\0=\2\5\1=\1\2\0006\0\6\0009\0\a\0009\0\b\0'\1\t\0+\2\1\0B\0\3\0016\0\6\0009\0\n\0'\1\v\0B\0\2\1K\0\1\0001command! Lint lua require('lint').try_lint()\bcmdn  augroup nvim_lint\n  autocmd!\n  autocmd BufWritePost * lua require('lint').try_lint()\n  augroup END\n    \14nvim_exec\bapi\bvim\ash\1\0\0\1\2\0\0\15shellcheck\18linters_by_ft\tlint\frequire\0", "config", "nvim-lint")
time([[Config for nvim-lint]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\2Œ\4\0\0\5\0\28\0\0316\0\0\0'\1\1\0B\0\2\0029\1\2\0005\2\b\0005\3\3\0005\4\4\0=\4\5\0035\4\6\0=\4\a\3=\3\t\0025\3\n\0=\3\v\0025\3\f\0=\3\r\0025\3\14\0005\4\15\0=\4\16\0035\4\17\0=\4\18\3=\3\19\0025\3\21\0005\4\20\0=\4\22\0035\4\23\0=\4\24\3=\3\25\0025\3\26\0=\3\27\2B\1\2\1K\0\1\0\vhidden\1\t\0\0\r<silent>\n<cmd>\n<Cmd>\t<CR>\tcall\blua\a^:\a^ \vlayout\nwidth\1\0\2\bmax\0032\bmin\3\20\vheight\1\0\1\fspacing\3\3\1\0\2\bmax\3\25\bmin\3\4\vwindow\fpadding\1\5\0\0\3\2\3\2\3\2\3\2\vmargin\1\5\0\0\3\0\3\1\3\0\3\1\1\0\2\rposition\vbottom\vborder\tnone\nicons\1\0\3\15breadcrumb\a¬ª\14separator\b‚ûú\ngroup\6+\14operators\1\0\1\agc\rComments\fplugins\1\0\3\14show_help\2\rtriggers\tauto\19ignore_missing\1\fpresets\1\0\a\fwindows\2\fmotions\2\14operators\2\6z\2\bnav\2\6g\2\17text_objects\2\rspelling\1\0\2\fenabled\2\16suggestions\3\20\1\0\2\nmarks\2\14registers\2\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: lsp-rooter.nvim
time([[Config for lsp-rooter.nvim]], true)
try_loadstring("\27LJ\2\2<\0\0\2\0\3\0\a6\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\1K\0\1\0\nsetup\15lsp-rooter\frequire\0", "config", "lsp-rooter.nvim")
time([[Config for lsp-rooter.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\2˛\f\0\0\t\0@\0v6\0\0\0'\1\1\0B\0\2\0026\1\0\0'\2\2\0B\1\2\0026\2\0\0'\3\3\0B\2\2\0029\2\4\0025\0036\0005\4\6\0005\5\5\0=\5\a\0045\5\t\0005\6\b\0=\6\n\0055\6\v\0=\6\f\5=\5\r\0046\5\0\0'\6\14\0B\5\2\0029\5\15\5=\5\16\0044\5\0\0=\5\17\0046\5\0\0'\6\14\0B\5\2\0029\5\18\5=\5\19\0044\5\0\0=\5\20\0045\5\21\0=\5\22\0045\5\23\0=\5\24\0046\5\0\0'\6\25\0B\5\2\0029\5\26\0059\5\27\5=\5\28\0046\5\0\0'\6\25\0B\5\2\0029\5\29\0059\5\27\5=\5\30\0046\5\0\0'\6\25\0B\5\2\0029\5\31\0059\5\27\5=\5 \0046\5\0\0'\6\25\0B\5\2\0029\5!\5=\5!\0045\0051\0005\6#\0009\a\"\0=\a$\0069\a%\0=\a&\0069\a'\0=\a(\0069\a)\1=\a*\0069\a+\0009\b,\0 \a\b\a=\a-\0069\a.\0009\b/\0 \a\b\a=\a0\6=\0062\0055\0063\0009\a%\0=\a&\0069\a'\0=\a(\0069\a)\1=\a*\0069\a+\0009\b,\0 \a\b\a=\a-\6=\0064\5=\0055\4=\0047\0035\0049\0005\0058\0=\5:\4=\4;\3B\2\2\0016\2\0\0'\3\3\0B\2\2\0029\2<\2'\3=\0B\2\2\0016\2\0\0'\3\3\0B\2\2\0029\2<\2'\3>\0B\2\2\0016\2\0\0'\3\3\0B\2\2\0029\2<\2'\3?\0B\2\2\1K\0\1\0\17session-lens\bfzf\agh\19load_extension\15extensions\15fzy_native\1\0\0\1\0\3\25override_file_sorter\2\28override_generic_sorter\1\14case_mode\15smart_case\rdefaults\1\0\0\rmappings\6n\1\0\0\6i\1\0\0\t<CR>\vcenter\19select_default\n<C-q>\16open_qflist\25smart_send_to_qflist\n<c-t>\22open_with_trouble\n<C-k>\28move_selection_previous\n<C-j>\24move_selection_next\n<C-c>\1\0\0\nclose\27buffer_previewer_maker\21qflist_previewer\22vim_buffer_qflist\19grep_previewer\23vim_buffer_vimgrep\19file_previewer\bnew\19vim_buffer_cat\25telescope.previewers\fset_env\1\0\1\14COLORTERM\14truecolor\16borderchars\1\t\0\0\b‚îÄ\b‚îÇ\b‚îÄ\b‚îÇ\b‚ï≠\b‚ïÆ\b‚ïØ\b‚ï∞\vborder\19generic_sorter\29get_generic_fuzzy_sorter\25file_ignore_patterns\16file_sorter\19get_fzy_sorter\22telescope.sorters\20layout_defaults\rvertical\1\0\1\vmirror\1\15horizontal\1\0\0\1\0\1\vmirror\1\17find_command\1\0\16\19results_height\3\1\21sorting_strategy\15descending\19preview_cutoff\3x\20selection_caret\tÔÅ§ \18results_width\4ö≥ÊÃ\tô≥¶ˇ\3\ruse_less\2\20layout_strategy\15horizontal\17shorten_path\2\20prompt_position\vbottom\nwidth\4\0ÄÄ†ˇ\3\17entry_prefix\a  \18prompt_prefix\tÔë´ \19color_devicons\2\23selection_strategy\nreset\rwinblend\3\0\17initial_mode\vinsert\1\a\0\0\arg\17--no-heading\20--with-filename\18--line-number\r--column\17--smart-case\nsetup\14telescope trouble.providers.telescope\22telescope.actions\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\2ˇ\6\0\0\5\0\30\0$6\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\0025\1\a\0005\2\4\0005\3\5\0=\3\6\2=\2\b\1=\1\3\0006\1\0\0'\2\t\0B\1\2\0029\1\n\0015\2\f\0005\3\v\0=\3\r\0025\3\14\0=\3\15\0025\3\16\0=\3\17\0025\3\18\0005\4\19\0=\4\20\3=\3\21\0025\3\22\0=\3\23\0025\3\24\0005\4\25\0=\4\26\3=\3\27\0025\3\28\0=\3\29\2B\1\2\1K\0\1\0\fmatchup\1\0\1\venable\2\frainbow\16keybindings\1\0\n\vupdate\6R\14show_help\6?\14goto_node\t<cr>\30toggle_injected_languages\6t\28toggle_language_display\6I\21unfocus_language\6F\19focus_language\6f\21toggle_hl_groups\6i\27toggle_anonymous_nodes\6a\24toggle_query_editor\6o\1\0\5\15updatetime\3\25\20persist_queries\1\venable\2\18extended_mode\2\19max_file_lines\3Ë\a\15playground\1\0\2\venable\2\15updatetime\3\25\26incremental_selection\fkeymaps\1\0\3\21node_decremental\f<C-A-j>\21node_incremental\f<C-A-k>\19init_selection\f<C-A-k>\1\0\1\venable\2\vindent\1\0\1\venable\2\14highlight\1\0\1\venable\2\21ensure_installed\1\0\0\1\t\0\0\tbash\bcss\thtml\15javascript\tjson\blua\tyaml\nquery\nsetup\28nvim-treesitter.configs\17install_info\1\0\0\nfiles\1\2\0\0\17src/parser.c\1\0\1\burl.~/projects/grantmacken/tree-sitter-xquery\vxquery\23get_parser_configs\28nvim-treesitter.parsers\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\2ö\t\0\0\5\0(\0E6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\3\0005\2\4\0005\3\5\0=\3\6\0025\3\a\0=\3\b\0025\3\t\0=\3\n\0025\3\v\0=\3\f\0025\3\r\0=\3\14\2=\2\15\0015\2\16\0=\2\17\1B\0\2\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2\22\0'\3\23\0005\4\24\0B\0\5\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2\25\0'\3\26\0005\4\27\0B\0\5\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2\28\0'\3\29\0005\4\30\0B\0\5\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2\31\0'\3 \0005\4!\0B\0\5\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2\"\0'\3#\0005\4$\0B\0\5\0016\0\18\0009\0\19\0009\0\20\0'\1\21\0'\2%\0'\3&\0005\4'\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2*<cmd>TroubleToggle lsp_references<cr>\agR\1\0\2\vsilent\2\fnoremap\2$<cmd>TroubleToggle quickfix<cr>\15<leader>gq\1\0\2\vsilent\2\fnoremap\2#<cmd>TroubleToggle loclist<cr>\15<leader>gl\1\0\2\vsilent\2\fnoremap\0024<cmd>TroubleToggle lsp_document_diagnostics<cr>\15<leader>gd\1\0\2\vsilent\2\fnoremap\0025<cmd>TroubleToggle lsp_workspace_diagnostics<cr>\15<leader>gw\1\0\2\vsilent\2\fnoremap\2\27<cmd>TroubleToggle<cr>\15<leader>gx\6n\20nvim_set_keymap\bapi\bvim\nsigns\1\0\5\nerror\bÔôô\16information\bÔëâ\fwarning\bÔî©\thint\bÔ†µ\nother\bÔ´†\16action_keys\16toggle_fold\1\3\0\0\azA\aza\15open_folds\1\3\0\0\azR\azr\16close_folds\1\3\0\0\azM\azm\15jump_close\1\2\0\0\6o\tjump\1\3\0\0\t<cr>\n<tab>\1\0\t\nhover\6K\16toggle_mode\6m\nclose\6q\frefresh\6r\vcancel\n<esc>\fpreview\6p\rprevious\6k\19toggle_preview\6P\tnext\6j\1\0\v\16ident_lines\2\nicons\2\16fold_closed\bÔë†\14auto_open\1\vheight\3\a\14fold_open\bÔëº\15auto_close\1\14auto_fold\1\tmode\30lsp_workspace_diagnostics\29use_lsp_diagnostic_signs\1\17auto_preview\2\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
vim.cmd [[command! -nargs=* -range -bang -complete=file Sayonara lua require("packer.load")({'vim-sayonara'}, { cmd = "Sayonara", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file SudaWrite lua require("packer.load")({'suda.vim'}, { cmd = "SudaWrite", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Wall lua require("packer.load")({'vim-eunuch'}, { cmd = "Wall", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Remove lua require("packer.load")({'vim-eunuch'}, { cmd = "Remove", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Rename lua require("packer.load")({'vim-eunuch'}, { cmd = "Rename", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file SudaRead lua require("packer.load")({'suda.vim'}, { cmd = "SudaRead", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Chmod lua require("packer.load")({'vim-eunuch'}, { cmd = "Chmod", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Move lua require("packer.load")({'vim-eunuch'}, { cmd = "Move", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Delete lua require("packer.load")({'vim-eunuch'}, { cmd = "Delete", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
time([[Defining lazy-load commands]], false)

if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
