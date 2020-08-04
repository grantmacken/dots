local M = {}
M.version = 'v0.0.1'
local p = function( obj )
 print(vim.inspect( obj ))
end

local setter = function( win_id )
  local builtin = require('el.builtin')
  local extensions = require('el.extensions')
  local helper = require('el.helper')
  local sections = require('el.sections')
  local meta = require('el.meta')
  local subscribe = require('el.subscribe')
  return {
    extensions.mode,
    sections.split,
    builtin.file,
    sections.collapse_builtin{
      ' ',
      builtin.modified_flag
    },
    sections.split,
    -- lsp_statusline.segment,
    -- lsp_statusline.current_function,
    subscribe.buf_autocmd(
      "el_git_status",
      "BufWritePost",
      function(window, buffer)
        return extensions.git_changes(window, buffer)
      end
    ),
    '[', builtin.line, ' : ',  builtin.column, ']',
    sections.collapse_builtin({
      '[',
      builtin.help_list,
      builtin.readonly_list,
      ']',
    })
  }
end


local set = function()
local cmd = vim.api.nvim_command
 cmd('packadd luvjob.nvim')
 cmd('packadd expressline.nvim')
 --el.set_statusline_:generator = function(item_generator)
 -- p(setter())
 local el = require('el')
 local el_segments = {}
 table.insert(el_segments, '[literal_string]')
el.set_statusline_generator(el_segments)
-- require('el').set_statusline_generator(el_segments)
 -- local win_id = vim.fn.win_getid()
 -- status_line_setter = setter
 -- p(status_line_setter(win_id))
 -- sl = el._window_status_lines[win_id]()
 --p(sl)
-- vim.wo.statusline = sl
 --vim.wo.statusline = string.format([[%%!luaeval('require("el").run(%s)')]], vim.fn.win_getid())
 --vim.wo.statusline = el.run( )
 -- p(statusline)
 -- vim.wo.statusline = string.format('%%!v:lua.el.run(%s)', vim.fn.win_getid())
end

local clear = function()
  require('el.init').clear()
  -- vim.wo.statu:sline = string.format('%%!v:lua.el.run(%s)', vim.fn.win_getid())
end

-- M.set = set

 set()
-- clear()

return M
