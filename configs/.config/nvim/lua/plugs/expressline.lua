M = {}
---- Default status line setter.
local status_line_setter = function(win_id)
  local builtin = require('el.builtin')
  local extensions = require('el.extensions')
  local sections = require('el.sections')
  --local meta = require('el.meta')
  --local subscribe = require('el.subscribe')
  return {
    extensions.mode,
    sections.split,
    builtin.file,
    sections.collapse_builtin{
      ' ',
      builtin.modified_flag
    },
    sections.split,
    '[', builtin.line, ' : ',  builtin.column, ']',
    sections.collapse_builtin{
      '[',
      builtin.help_list,
      builtin.readonly_list,
      ']',
    },
    builtin.filetype,
  }
end
local init = function()
  local cmd = vim.api.nvim_command
  cmd [[packadd! plenary.nvim]]
  cmd [[packadd! express_line.nvim]]
  vim._update_package_paths()
  require('el').set_statusline_generator(status_line_setter)
end

M.init = init
return init()
