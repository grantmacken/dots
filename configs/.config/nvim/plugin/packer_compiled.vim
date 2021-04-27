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
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

time("try_loadstring definition", false)
time("Defining packer_plugins", true)
_G.packer_plugins = {
  Zenburn = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/Zenburn"
  },
  ["completion-buffers"] = {
    after_files = { "/home/gmack/.local/share/nvim/site/pack/packer/opt/completion-buffers/after/plugin/completion_buffers.vim" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/completion-buffers"
  },
  ["completion-nvim"] = {
    after = { "vim-vsnip", "vim-vsnip-integ" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/completion-nvim"
  },
  ["completion-treesitter"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/completion-treesitter"
  },
  edge = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/edge"
  },
  ["express_line.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/express_line.nvim"
  },
  ["forest-night"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/forest-night"
  },
  ["formatter.nvim"] = {
    config = { "\27LJ\2\nŠ\1\0\0\5\0\6\0\n5\0\0\0005\1\1\0006\2\2\0009\2\3\0029\2\4\2)\4\0\0B\2\2\2>\2\2\1=\1\5\0L\0\2\0\targs\22nvim_buf_get_name\bapi\bvim\1\4\0\0\21--stdin-filepath\0\19--single-quote\1\0\2\bexe\rprettier\nstdin\2f\1\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0003\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\15javascript\1\0\0\rprettier\1\0\0\0\nsetup\14formatter\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/formatter.nvim"
  },
  git_fastfix = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/git_fastfix"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nœ\n\0\0\5\0\24\0\0276\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0025\3\16\0005\4\17\0=\4\18\0035\4\19\0=\4\20\3=\3\21\0025\3\22\0=\3\23\2B\0\2\1K\0\1\0\16watch_index\1\0\1\rinterval\3è\a\fkeymaps\tn [c\1\2\1\0@&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'\texpr\2\tn ]c\1\2\1\0@&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'\texpr\2\1\0\n\17n <leader>hp2<cmd>lua require\"gitsigns\".preview_hunk()<CR>\17n <leader>hb0<cmd>lua require\"gitsigns\".blame_line()<CR>\17n <leader>hR2<cmd>lua require\"gitsigns\".reset_buffer()<CR>\vbuffer\2\17n <leader>hr0<cmd>lua require\"gitsigns\".reset_hunk()<CR>\tx ih2:<C-U>lua require\"gitsigns\".text_object()<CR>\17n <leader>hu5<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>\17n <leader>hs0<cmd>lua require\"gitsigns\".stage_hunk()<CR>\to ih2:<C-U>lua require\"gitsigns\".text_object()<CR>\fnoremap\2\nsigns\1\0\6\22use_internal_diff\2\23use_decoration_api\2\20update_debounce\3d\18sign_priority\3\6\vlinehl\1\nnumhl\1\16changdelete\1\0\4\nnumhl\21GitSignsChangeNr\ttext\6~\vlinehl\21GitSignsChangeLn\ahl\19GitSignsChange\14topdelete\1\0\4\nnumhl\21GitSignsDeleteNr\ttext\bâ€¾\vlinehl\21GitSignsDeleteLn\ahl\19GitSignsDelete\vdelete\1\0\4\nnumhl\21GitSignsDeleteNr\ttext\6_\vlinehl\21GitSignsDeleteLn\ahl\19GitSignsDelete\vchange\1\0\4\nnumhl\21GitSignsChangeNr\ttext\bâ”‚\vlinehl\21GitSignsChangeLn\ahl\19GitSignsChange\badd\1\0\0\1\0\4\nnumhl\18GitSignsAddNr\ttext\bâ”‚\vlinehl\18GitSignsAddLn\ahl\16GitSignsAdd\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["goyo.vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/goyo.vim"
  },
  ["gruvbox-material"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/gruvbox-material"
  },
  ["limelight.vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/limelight.vim"
  },
  ["lsp-status.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/lsp-status.nvim"
  },
  ["nlua.nvim"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/nlua.nvim"
  },
  ["nord-vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/nord-vim"
  },
  nordisk = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/nordisk"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-lspconfig"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig"
  },
  ["nvim-luadev"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/nvim-luadev"
  },
  ["nvim-treesitter"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["photon.vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/photon.vim"
  },
  ["plastic.vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/plastic.vim"
  },
  playground = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["seoul256.vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/seoul256.vim"
  },
  ["spellsitter.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\16spellsitter\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/spellsitter.nvim"
  },
  ["suda.vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/suda.vim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-color-spring-night"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-color-spring-night"
  },
  ["vim-commentary"] = {
    commands = { "Commentary", "CommentaryLine" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-commentary"
  },
  ["vim-cool"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/vim-cool"
  },
  ["vim-dirvish"] = {
    after = { "vim-dirvish-git" },
    loaded = false,
    needs_bufread = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-dirvish"
  },
  ["vim-dirvish-git"] = {
    load_after = {
      ["vim-dirvish"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-dirvish-git"
  },
  ["vim-easy-align"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-easy-align"
  },
  ["vim-eunuch"] = {
    commands = { "Delete", "Remove", "Move", "Chmod", "Wall", "Rename" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-eunuch"
  },
  ["vim-matchup"] = {
    after_files = { "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-matchup/after/plugin/matchit.vim" },
    loaded = false,
    needs_bufread = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-matchup"
  },
  ["vim-moonfly-colors"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-moonfly-colors"
  },
  ["vim-nightfly-guicolors"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-nightfly-guicolors"
  },
  ["vim-qf"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-qf"
  },
  ["vim-repeat"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-repeat"
  },
  ["vim-sayonara"] = {
    commands = { "Sayonara" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-sayonara"
  },
  ["vim-smoothie"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-smoothie"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-substrata"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-substrata"
  },
  ["vim-surround"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-surround"
  },
  ["vim-vsnip"] = {
    load_after = {
      ["completion-nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    after_files = { "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ/after/plugin/vsnip_integ.vim" },
    load_after = {
      ["completion-nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ"
  },
  ["vim-which-key"] = {
    loaded = true,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/start/vim-which-key"
  },
  ["vista.vim"] = {
    commands = { "Vista" },
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/vista.vim"
  },
  ["zephyr-nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/gmack/.local/share/nvim/site/pack/packer/opt/zephyr-nvim"
  }
}

time("Defining packer_plugins", false)
-- Config for: gitsigns.nvim
time("Config for gitsigns.nvim", true)
try_loadstring("\27LJ\2\nœ\n\0\0\5\0\24\0\0276\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0025\3\16\0005\4\17\0=\4\18\0035\4\19\0=\4\20\3=\3\21\0025\3\22\0=\3\23\2B\0\2\1K\0\1\0\16watch_index\1\0\1\rinterval\3è\a\fkeymaps\tn [c\1\2\1\0@&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'\texpr\2\tn ]c\1\2\1\0@&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'\texpr\2\1\0\n\17n <leader>hp2<cmd>lua require\"gitsigns\".preview_hunk()<CR>\17n <leader>hb0<cmd>lua require\"gitsigns\".blame_line()<CR>\17n <leader>hR2<cmd>lua require\"gitsigns\".reset_buffer()<CR>\vbuffer\2\17n <leader>hr0<cmd>lua require\"gitsigns\".reset_hunk()<CR>\tx ih2:<C-U>lua require\"gitsigns\".text_object()<CR>\17n <leader>hu5<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>\17n <leader>hs0<cmd>lua require\"gitsigns\".stage_hunk()<CR>\to ih2:<C-U>lua require\"gitsigns\".text_object()<CR>\fnoremap\2\nsigns\1\0\6\22use_internal_diff\2\23use_decoration_api\2\20update_debounce\3d\18sign_priority\3\6\vlinehl\1\nnumhl\1\16changdelete\1\0\4\nnumhl\21GitSignsChangeNr\ttext\6~\vlinehl\21GitSignsChangeLn\ahl\19GitSignsChange\14topdelete\1\0\4\nnumhl\21GitSignsDeleteNr\ttext\bâ€¾\vlinehl\21GitSignsDeleteLn\ahl\19GitSignsDelete\vdelete\1\0\4\nnumhl\21GitSignsDeleteNr\ttext\6_\vlinehl\21GitSignsDeleteLn\ahl\19GitSignsDelete\vchange\1\0\4\nnumhl\21GitSignsChangeNr\ttext\bâ”‚\vlinehl\21GitSignsChangeLn\ahl\19GitSignsChange\badd\1\0\0\1\0\4\nnumhl\18GitSignsAddNr\ttext\bâ”‚\vlinehl\18GitSignsAddLn\ahl\16GitSignsAdd\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time("Config for gitsigns.nvim", false)

-- Command lazy-loads
time("Defining lazy-load commands", true)
vim.cmd [[command! -nargs=* -range -bang -complete=file Delete lua require("packer.load")({'vim-eunuch'}, { cmd = "Delete", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Remove lua require("packer.load")({'vim-eunuch'}, { cmd = "Remove", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Move lua require("packer.load")({'vim-eunuch'}, { cmd = "Move", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Chmod lua require("packer.load")({'vim-eunuch'}, { cmd = "Chmod", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Wall lua require("packer.load")({'vim-eunuch'}, { cmd = "Wall", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Rename lua require("packer.load")({'vim-eunuch'}, { cmd = "Rename", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Commentary lua require("packer.load")({'vim-commentary'}, { cmd = "Commentary", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Sayonara lua require("packer.load")({'vim-sayonara'}, { cmd = "Sayonara", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Vista lua require("packer.load")({'vista.vim'}, { cmd = "Vista", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file CommentaryLine lua require("packer.load")({'vim-commentary'}, { cmd = "CommentaryLine", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
time("Defining lazy-load commands", false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time("Defining lazy-load event autocommands", true)
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'vim-matchup'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time("Defining lazy-load event autocommands", false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
