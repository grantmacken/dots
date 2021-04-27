" Automatically generated packer.nvim plugin loader code

lua << END
local plugins = {
  ["completion-buffers"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/completion-buffers"
  },
  ["completion-nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/completion-nvim"
  },
  ["completion-treesitter"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/completion-treesitter"
  },
  ["diagnostic-nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/diagnostic-nvim"
  },
  ["express_line.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/express_line.nvim"
  },
  ["goyo.vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/goyo.vim"
  },
  ["limelight.vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/limelight.vim"
  },
  ["lsp-status.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/lsp-status.nvim"
  },
  ["nord-vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/nord-vim"
  },
  ["nvim-lsp"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/nvim-lsp"
  },
  ["nvim-popterm.lua"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/nvim-popterm.lua"
  },
  ["nvim-treesitter"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/plenary.nvim"
  },
  ["seoul256.vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/seoul256.vim"
  },
  ["suda.vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/suda.vim"
  },
  ["telescope.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/telescope.nvim"
  },
  ["vim-clap"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-clap"
  },
  ["vim-commentary"] = {
    commands = { "Commentary", "CommentaryLine" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-commentary"
  },
  ["vim-dirvish"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-dirvish"
  },
  ["vim-dirvish-git"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-dirvish-git"
  },
  ["vim-easy-align"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-easy-align"
  },
  ["vim-eunuch"] = {
    commands = { "Delete", "Remove", "Move", "Chmod", "Wall", "Rename" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-eunuch"
  },
  ["vim-gitgutter"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-gitgutter"
  },
  ["vim-matchup"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-matchup"
  },
  ["vim-qf"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-qf"
  },
  ["vim-repeat"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-repeat"
  },
  ["vim-sayonara"] = {
    commands = { "Sayonara" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-sayonara"
  },
  ["vim-smoothie"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-smoothie"
  },
  ["vim-startify"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-startify"
  },
  ["vim-substrata"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-substrata"
  },
  ["vim-surround"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-surround"
  },
  ["vim-vsnip"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ"
  },
  ["vista.vim"] = {
    commands = { "Vista" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/grantmacken/.local/share/nvim/site/pack/packer/opt/vista.vim"
  }
}

local function handle_bufread(names)
  for _, name in ipairs(names) do
    local path = plugins[name].path
    for _, dir in ipairs({ 'ftdetect', 'ftplugin', 'after/ftdetect', 'after/ftplugin' }) do
      if #vim.fn.finddir(dir, path) > 0 then
        vim.cmd('doautocmd BufRead')
        return
      end
    end
  end
end

_packer_load = nil

local function handle_after(name, before)
  local plugin = plugins[name]
  plugin.load_after[before] = nil
  if next(plugin.load_after) == nil then
    _packer_load({name}, {})
  end
end

_packer_load = function(names, cause)
  local some_unloaded = false
  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      some_unloaded = true
      break
    end
  end

  if not some_unloaded then return end

  local fmt = string.format
  local del_cmds = {}
  local del_maps = {}
  for _, name in ipairs(names) do
    if plugins[name].commands then
      for _, cmd in ipairs(plugins[name].commands) do
        del_cmds[cmd] = true
      end
    end

    if plugins[name].keys then
      for _, key in ipairs(plugins[name].keys) do
        del_maps[key] = true
      end
    end
  end

  for cmd, _ in pairs(del_cmds) do
    vim.cmd('silent! delcommand ' .. cmd)
  end

  for key, _ in pairs(del_maps) do
    vim.cmd(fmt('silent! %sunmap %s', key[1], key[2]))
  end

  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      vim.cmd('packadd ' .. name)
      if plugins[name].config then
        for _i, config_line in ipairs(plugins[name].config) do
          loadstring(config_line)()
        end
      end

      if plugins[name].after then
        for _, after_name in ipairs(plugins[name].after) do
          handle_after(after_name, name)
          vim.cmd('redraw')
        end
      end

      plugins[name].loaded = true
    end
  end

  handle_bufread(names)

  if cause.cmd then
    local lines = cause.l1 == cause.l2 and '' or (cause.l1 .. ',' .. cause.l2)
    vim.cmd(fmt('%s%s%s %s', lines, cause.cmd, cause.bang, cause.args))
  elseif cause.keys then
    local keys = cause.keys
    local extra = ''
    while true do
      local c = vim.fn.getchar(0)
      if c == 0 then break end
      extra = extra .. vim.fn.nr2char(c)
    end

    if cause.prefix then
      local prefix = vim.v.count and vim.v.count or ''
      prefix = prefix .. '"' .. vim.v.register .. cause.prefix
      if vim.fn.mode('full') == 'no' then
        if vim.v.operator == 'c' then
          prefix = '' .. prefix
        end

        prefix = prefix .. vim.v.operator
      end

      vim.fn.feedkeys(prefix, 'n')
    end

    -- NOTE: I'm not sure if the below substitution is correct; it might correspond to the literal
    -- characters \<Plug> rather than the special <Plug> key.
    vim.fn.feedkeys(string.gsub(string.gsub(cause.keys, '^<Plug>', '\\<Plug>') .. extra, '<[cC][rR]>', '\r'))
  elseif cause.event then
    vim.cmd(fmt('doautocmd <nomodeline> %s', cause.event))
  elseif cause.ft then
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeplugin', cause.ft))
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeindent', cause.ft))
  end
end

-- Pre-load configuration
-- Post-load configuration
-- Conditional loads
END

function! s:load(names, cause) abort
call luaeval('_packer_load(_A[1], _A[2])', [a:names, a:cause])
endfunction

" Runtimepath customization

" Load plugins in order defined by `after`

" Command lazy-loads
command! -nargs=* -range -bang -complete=file CommentaryLine call s:load(['vim-commentary'], { "cmd": "CommentaryLine", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Commentary call s:load(['vim-commentary'], { "cmd": "Commentary", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Rename call s:load(['vim-eunuch'], { "cmd": "Rename", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Delete call s:load(['vim-eunuch'], { "cmd": "Delete", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Remove call s:load(['vim-eunuch'], { "cmd": "Remove", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Vista call s:load(['vista.vim'], { "cmd": "Vista", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Wall call s:load(['vim-eunuch'], { "cmd": "Wall", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Chmod call s:load(['vim-eunuch'], { "cmd": "Chmod", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Sayonara call s:load(['vim-sayonara'], { "cmd": "Sayonara", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Move call s:load(['vim-eunuch'], { "cmd": "Move", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })

" Keymap lazy-loads

augroup packer_load_aucmds
  au!
  " Filetype lazy-loads
  " Event lazy-loads
  au VimEnter * ++once call s:load(['vim-matchup'], { "event": "VimEnter *" })
augroup END
