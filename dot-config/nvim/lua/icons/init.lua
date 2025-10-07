local M = {}

--- Diagnostic severities.
M.diagnostics = {
  ERROR = '',
  WARN = '',
  HINT = '',
  INFO = '',
}

--- For folding.
M.arrows = {
  right = '',
  left = '',
  up = '',
  down = '',
}

-- local get = require('mini.icons').get
--
-- local lsp_kind = {
--   Text = get('Text'),
--   Method = get('Method'),
--   Function = get('Function'),
--   Constructor = get('Constructor'),
--   Field = get('Field'),
--   Variable = get('Variable'),
--   Class = get('Class'),
--   Interface = get('Interface'),
--   Module = get('Module'),
--   Property = get('Property'),
--   Unit = get('Unit'),
--   Value = get('Value'),
--   Enum = get('Enum'),
--   Keyword = get('Keyword'),
--   Snippet = get('Snippet'),
--   Color = get('Color'),
--   File = get('File'),
--   Reference = get('Reference'),
--   Folder = get('Folder'),
--   EnumMember = get('EnumMember'),
--   Constant = get('Constant'),
--   Struct = get('Struct'),
--   Event = get('Event'),
--   Operator = get('Operator'),
--   TypeParameter = get('TypeParameter'),
-- }
--
--
-- --M.lsp_kind = lsp_kind
-- M.get = get
return M
