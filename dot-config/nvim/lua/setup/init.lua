--[[-
plugins that require setup calls

INITIAL UI SETUP
 - colorscheme
 - icons
 - notify
 - statusline
 - oil (file explorer)
 - delimiters (rainbow parentheses)
 - tiny-inline-diagnostic
 - tiny-code-action
--]]

M = {}
local keymap = require('keymap')

M.colorscheme = function()
  require('kanagawa').setup({})
  vim.cmd('colorscheme kanagawa-dragon')
end


M.icons = function()
  local miniIcons = require('mini.icons')
  local ext3_blocklist = { scm = true, txt = true, yml = true }
  local ext4_blocklist = { json = true, yaml = true }
  miniIcons.setup({
    use_file_extension = function(ext, _)
      return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
    end,
  })
  -- Add LSP kind icons. Useful for 'mini.completion'.
  miniIcons.mock_nvim_web_devicons()
end

M.notify = function()
  local miniNotify = require('mini.notify')
  local win_config = function()
    local has_statusline = vim.o.laststatus > 0
    local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
    return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
  end
  miniNotify.setup({ window = { config = win_config } })
  vim.notify = miniNotify.make_notify()
end

M.statusline = function()
  local miniStatusline = require('mini.statusline')
  miniStatusline.setup({
    set_vim_settings = true,
    use_icons = true,
  })
end
-- OIL
-- local open_oil = function(oil)
--   oil.open(vim.fn.expand('%:p:h'))
-- end

-- add to arglist the file under cursor in oil buffer
local add_to_arglist = function(oil)
  local entry = oil.get_entry_on_line(0, vim.api.nvim_win_get_cursor(0)[1])
  if entry and entry.type == "file" then
    local dir = oil.get_current_dir()
    if dir then
      local filepath = dir .. entry.name
      vim.cmd.argadd(filepath)
      vim.notify("Added to arglist: " .. entry.name)
    end
  end
end

local delete_from_argist = function(oil)
  local entry = oil.get_entry_on_line(0, vim.api.nvim_win_get_cursor(0)[1])
  if entry and entry.type == "file" then
    local dir = oil.get_current_dir()
    if dir then
      local filepath = dir .. entry.name
      vim.cmd.argdelete(filepath)
      vim.notify("Deleted from arglist: " .. entry.name)
    end
  end
end

M.oil = function()
  local oil = require('oil')
  oil.setup({
    default_file_explorer = true,
    columns = {
      "icon",
    },
    prompt_save_on_select_new_entry = true,
    skip_confirm_for_simple_edits = true,
    view_options = { show_hidden = true },
    use_default_keymaps = true,
    keymaps = {
      ["<C-a>"] = { callback = function() add_to_arglist(oil) end, desc = "[oil] add entry to arglist" },
      ["<C-d>"] = { callback = function() delete_from_argist(oil) end, desc = "[oil] delete entry from arglist",
      }
    },
  })
  keymap.map('-', [[<Cmd>Oil<CR>]], 'Open Oil')
end

M.delimiters = function()
  -- vim.pack.add({ 'gh:hiphish/rainbow-delimiters.nvim' })
  -- vim.pack.del({ 'rainbow-delimiters' })
end

M.tinyInlineDiagnostic = function()
  require("tiny-inline-diagnostic").setup({ virtual_text = false })
end

M.tinyCodeAction = function()
  vim.pack.add({
    'gh:nvim-lua/plenary.nvim',
    'gh:rachartier/tiny-code-action.nvim'
  })
  local opts = {
    picker = {
      "buffer",
      opts = {
        hotkeys = true,                     -- Enable hotkeys for quick selection of actions
        hotkeys_mode = "text_diff_based",   -- Modes for generating hotkeys
        auto_preview = false,               -- Enable or disable automatic preview
        auto_accept = false,                -- Automatically accept the selected action (with hotkeys)
        position = "cursor",                -- Position of the picker window
        winborder = "single",               -- Border style for picker and preview windows
        keymaps = {
          preview = "K",                    -- Key to show preview
          close = { "q", "<Esc>" },         -- Keys to close the window (can be string or table)
          select = "<CR>",                  -- Keys to select action (can be string or table)
          preview_close = { "q", "<Esc>" }, -- Keys to return from preview to main window (can be string or table)
        },
        custom_keys = {
          { key = 'm', pattern = 'Fill match arms' },
          { key = 'r', pattern = 'Rename.*' }, -- Lua pattern matching
        },
        group_icon = " └",
      },
    },
    format_title = function(action, client)
      if action.kind then
        return string.format("%s (%s)", action.title, action.kind)
      end
      return action.title
    end,
    resolve_timeout = 100, -- Timeout in milliseconds to resolve code actions
    -- Notification settings
    notify = {
      enabled = true,  -- Enable/disable all notifications
      on_empty = true, -- Show notification when no code actions are found
    },
    signs = {
      quickfix = { "", { link = "DiagnosticWarning" } },
      others = { "", { link = "DiagnosticWarning" } },
      refactor = { "", { link = "DiagnosticInfo" } },
      ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
      ["refactor.extract"] = { "", { link = "DiagnosticError" } },
      ["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
      ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
      ["source"] = { "", { link = "DiagnosticError" } },
      ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
      ["codeAction"] = { "", { link = "DiagnosticWarning" } },
    },

  }
  require("tiny-code-action").setup(opts)
end

return M
