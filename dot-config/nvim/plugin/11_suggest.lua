local ok_fzf, fzf = pcall(require, 'fzf-lua')
if ok_fzf then
  fzf.register_ui_select(function(_, items)
    local min_h, max_h = 0.15, 0.70
    local h = (#items + 4) / vim.o.lines
    if h < min_h then
      h = min_h
    elseif h > max_h then
      h = max_h
    end
    return { winopts = { height = h, width = 0.60, row = 0.40 } }
  end)
end


-- local ok_opencode, opencode = pcall(require, 'opencode')
-- if ok_opencode then
--   vim.opt.autoread = true
--   local keymap = require('util').keymap
--   local keymap_buf = require('util').keymap_buf
--   local keymap_dynamic = require('util').keymap_dynamic
--
--
--   -- Recommended keymaps
--   keymap('<leader>ot', function() require('opencode').toggle() end, 'Toggle')
--   keymap('<leader>oA', function() require('opencode').ask() end, 'Ask')
--   keymap('<leader>oa', function() require('opencode').ask('@cursor: ') end, 'Ask about this')
--   keymap('<leader>oa', function() require('opencode').ask('@selection: ') end, 'Ask about selection', 'v')
--   keymap('<leader>o+', function() require('opencode').append_prompt('@buffer') end, 'Add buffer to prompt')
--   --keymap('v', '<leader>o+', function() require('opencode').append_prompt('@selection') end, { desc = 'Add selection to prompt' })
--   keymap('<leader>on', function() require('opencode').command('session_new') end, 'New session')
--   keymap('<leader>oy', function() require('opencode').command('messages_copy') end, 'Copy last response')
--   keymap('<S-C-u>', function() require('opencode').command('messages_half_page_up') end, 'Messages half page up')
--   keymap('<S-C-d>', function() require('opencode').command('messages_half_page_down') end, 'Messages half page down')
--   keymap('<leader>os', function() require('opencode').select() end, 'Select prompt')
--
--   -- Example: keymap for custom prompt
--   -- vim.keymap.set('n', '<leader>oe', function() require('opencode').prompt('Explain @cursor and its context') end, { desc = 'Explain this code' })
--   -- Listen for opencode events
--   vim.api.nvim_create_autocmd("User", {
--     pattern = "OpencodeEvent",
--     callback = function(args)
--       -- See the available event types and their properties
--       -- vim.notify(vim.inspect(args.data))
--       -- Do something interesting, like show a notification when opencode finishes responding
--       if args.data.type == "session.idle" then
--         vim.notify("opencode finished responding")
--       end
--     end,
--   })
--
--
--   vim.g.opencode_opts = {
--     -- Your configuration, if any — see `lua/opencode/config.lua`
--   }
-- end
