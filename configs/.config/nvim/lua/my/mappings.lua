local M = {}
M.version = 'v0.0.1'
--[[ 
@help vim_set_keymap
-- nvim_set_keymap({mode}, {lhs}, {rhs}, {opts})
@arg table { sMode, sLeftHandSide, sRightHandSide, tOpts }
@usage:
  require('my.mappings')({
   { sMode, 'gc', '<Plug>Commentary', tOpts };
  })
]]-- value 
-- " Get rid of the annoying F1 binding
-- imap <f1> <nop>

local set = function( tbl )
  local keyMap = vim.api.nvim_set_keymap
  for _,item in ipairs( tbl ) do
    local sMode = item[1]
    local sLeftHandSide = item[2]
    local sRightHandSide = item[3]
    local tOpts
    if not item[4] then
      tOpts  = {noremap = true, silent = true}
    else
      tOpts  = item[4]
    end
    keyMap(sMode,sLeftHandSide,sRightHandSide,tOpts)
  end
end

local bufferSet = function( nBuf, tbl )
  local keyMap = vim.api.nvim_buf_set_keymap
  for _,item in ipairs( tbl ) do
    local sMode = item[1]
    local sLeftHandSide = item[2]
    local sRightHandSide = item[3]
    local tOpts
    if not item[4] then
      tOpts  = {noremap = true, silent = true}
    else
      tOpts  = item[4]
    end
    keyMap(nBuf,sMode,sLeftHandSide,sRightHandSide,tOpts)
  end
end
M.set = set
M.bufferSet = bufferSet

return M

