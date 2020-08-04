local M = {}
M.version = 'v0.0.1'
vim = vim or {}
api = vim.api
fn = vim.fn

local deleteFile = function()
  local fileName = api.nvim_get_current_line()
  print('TODO')
  --os.remove(fileName)
  --api.nvim_input('R')
end

local renameFile = function()
  local fileName = api.nvim_get_current_line()
  print('TODO')
  --os.remove(fileName)
  --api.nvim_input('R')
end

local listFiles = function(pattern) 
  fn.setqflist({}, 'r', {title = 'Files', lines = results, efm = '%f'})
  -- nvim.command[[copen]]
  print('TODO')
end


M.deleteFile = deleteFile
M.listFiles  = listFiles
M.renameFile = renameFile

--[[ test
 - uncomment setCmds
 - comment out return
 - luafile %
--]]
--setCmds()
return M
