local M = {}
M.version = 'v0.0.1'
-- " Get rid of the annoying F1 binding
-- imap <f1> <nop>
-- nvim_set_keymap({mode}, {lhs}, {rhs}, {opts})
-- {  '{{mode}}',  '{{lhs}}', '{{rhs}}' }}
local set = function( tbl )
  local keyMap = vim.api.nvim_set_keymap
  local tOpts = {noremap = true, silent = true}
  for _,item in ipairs( tbl ) do
    --local sMode = item[1]
    --local sLeftHandSide = item[2]
    --local sRightHandSide = item[3]
    if not item[4] then
      tOpts  = {noremap = true, silent = true}
    else
      tOpts  = item[4]
    end
    keyMap(item[1],item[2],item[3],tOpts)
  end
end

M.set = set

return M

