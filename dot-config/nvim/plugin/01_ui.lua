---ICONS-
local ok_icons, icons = pcall(require, 'mini.icons')
if ok_icons then
  icons.setup()
end

-- NOTIFY
local ok_notify, miniNotify = pcall(require, 'mini.notify')
if ok_notify then
  local win_config = function()
    local has_statusline = vim.o.laststatus > 0
    local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
    return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
  end
  miniNotify.setup({ window = { config = win_config } })
  vim.notify = miniNotify.make_notify()
end

-- UI_SELECT //TODO
-- local ok_fzf, fzf = pcall(require, 'fzf-lua')
-- if ok_fzf then
--   vim.ui.select = function(items, opts, on_choice)
--     local ui_select = require 'fzf-lua.providers.ui_select'
--     -- Register the fzf-lua picker the first time we call select.
--     if not ui_select.is_registered() then
--       ui_select.register(function(ui_opts)
--         if ui_opts.kind == 'luasnip' then
--           ui_opts.prompt = 'Snippet choice: '
--           ui_opts.winopts = {
--             relative = 'cursor',
--             height = 0.35,
--             width = 0.3,
--           }
--         elseif ui_opts.kind == 'color_presentation' then
--           ui_opts.winopts = {
--             relative = 'cursor',
--             height = 0.35,
--             width = 0.3,
--           }
--         else
--           ui_opts.winopts = { height = 0.5, width = 0.4 }
--         end
--
--         -- Use the kind (if available) to set the previewer's title.
--         if ui_opts.kind then
--           ui_opts.winopts.title = string.format(' %s ', ui_opts.kind)
--         end
--
--         return ui_opts
--       end)
--     end
--
--     -- Don't show the picker if there's nothing to pick.
--     if #items > 0 then
--       return vim.ui.select(items, opts, on_choice)
--     end
--   end
-- end
