local M = {}

local isDir = function(filename)
	local stat = vim.loop.fs_stat(filename)
	return stat and stat.type == 'directory' or false
end

local function pathJoin(...)
return table.concat(vim.tbl_flatten {...},'/')
end

-- Asumes filepath is a file.
local function getDirname(filepath)
local isChanged = false
local result = filepath:gsub("(/[^/]+)$", function()
  isChanged = true
  return ""
end)
return result, isChanged
end

-- Ascend the buffer's path until we find the rootdir.
-- param: bufnr      : integer
-- param: isRootPath : function
local bufferFindRootDir = function( bufnr, isRootPath )
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if vim.fn.filereadable(bufname) == 0 then
    return nil
  end
  local dir = bufname
  -- Just in case our algo is buggy, don't infinite loop.
  for _ = 1, 50 do
    local didChange
    dir, didChange = getDirname(dir)
    if isRootPath(dir, bufname) then
      return dir, bufname
    end
    -- If we can't ascend further, then stop looking.
    if not didChange then
      return nil
    end
  end
end

local function root()
  local bufnr = vim.api.nvim_get_current_buf()
  local pRoot, pFile = bufferFindRootDir(
    bufnr,
    function(dir)
     return isDir(pathJoin(dir, '.git'))
    end
   )
  -- print( pRoot )
  return pRoot
end



M.root = root

return M
