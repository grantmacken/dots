local _M = {}

--[[ 
--https://github.com/luvit/luv/blob/master/tests/test-fs.lua 
-- https://neovim.io/doc/user/lua.html
--]]

local function json_encode(data)
  local status, result = pcall(vim.fn.json_encode, data)
  if status then
    return result
  else
    return nil, result
  end
end
local function json_decode(data)
  local status, result = pcall(vim.fn.json_decode, data)
  if status then
    return result
  else
    return nil, result
  end
end

-- Some path manipulation utilities
local function is_dir(filename)
local stat = vim.loop.fs_stat(filename)
return stat and stat.type == 'directory' or false
end

local function is_file(filename)
    local stat = vim.loop.fs_stat(filename)
    return stat and stat.type or false
end

local path_sep = vim.loop.os_uname().sysname == "Windows" and "\\" or "/"
-- Asumes filepath is a file.
local function dirname(filepath)
  local is_changed = false
  local result = filepath:gsub(path_sep.."([^"..path_sep.."]+)$", function()
    is_changed = true
    return ""
  end)
  return result, is_changed
end

local function path_join(...)
return table.concat(vim.tbl_flatten {...}, path_sep)
end

-- Ascend the buffer's path until we find the rootdir.
-- is_root_path is a function which returns bool
local function buffer_find_root_dir(bufnr, is_root_path)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if vim.fn.filereadable(bufname) == 0 then
    return nil
  end
  local dir = bufname
  -- Just in case our algo is buggy, don't infinite loop.
  for _ = 1, 100 do
    local did_change
    dir, did_change = dirname(dir)
    if is_root_path(dir, bufname) then
      return dir, bufname
    end
    -- If we can't ascend further, then stop looking.
    if not did_change then
      return nil
    end
  end
end


--  You can also call *projectionist#path()*
--  to get the root of the innermost set of projections

function project_root()
  local bufnr = vim.api.nvim_get_current_buf()
  local root_dir = buffer_find_root_dir(bufnr,
    function(dir)
     return is_dir(path_join(dir, '.git'))
    end
   )
  return root_dir
end

local function project_file()
  local projectRoot = project_root()
  local projectFile 
  if projectRoot then
    projectFile = path_join(projectRoot, '.projections.json')
    if is_file(projectFile) then
      return projectFile
    end
  else
    return nil
  end
end
-- print(vim.inspect( project_file() ))


--[[
-- this returns a lua table 
-- of the projections for project root
--]]

function _M.read_projections()
  local projectFile = project_file()
  local fd = vim.loop.fs_open(projectFile, 'r', tonumber('644', 8))
  local stat =  vim.loop.fs_fstat( fd )
  local chunk = vim.loop.fs_read(fd, stat.size, 0)
  local close = vim.loop.fs_close(fd)
  local obj = json_decode(chunk)
  return obj
end


-- print(vim.inspect( read_projections() ))
-- local project_transformations = {}
-- -- Section: Navigation commands
-- local prefixes = {
--   E = 'edit',
--   S = 'split',
--   V = 'vsplit',
--   T = 'tabedit',
--   D = 'read'
-- }

--local commands = {}



--local function nav_cmds()
--  local tProject = read_projections()
--  -- get all the keys for the project
--  -- each key represent an unexpanded path
--  local lKeys = vim.tbl_keys(tProject)

--  local tCompleteItems = {}
--  local lTypes = {}
--  -- create a uniqe list of projections with type key
--  for  index, value in ipairs ( lKeys ) do
--    if tProject[value].type then
--      local navType = tProject[value].type
--      if not vim.tbl_contains(lTypes,navType) then
--        lTypes[#lTypes+1] = navType
--        -- TODO expand tProject[value] 
--        tCompleteItems[navType] = {}
--        --  else
--        --  table.insert(tCompleteItems[navType],value)
--        --   table:insert(tCompleteItems[navType], value )
--      end
--      local list = tCompleteItems[navType]
--       list[#list+1] = value
--    end
--  end


--  for  index, value in ipairs ( lTypes ) do
--    -- local sCommand = "command! -complete=custom,ListUsers -nargs=1 Finger !finger <args>"


--    -- -nargs=1 E" .. 
--    -- value ..
--    -- " -complete=custom,ListUsers -nargs=1 Finger !finger <args>"
--   vim.api.nvim_command(sCommand)
--  end


--  --[[ tCompleteItems tbl
--  { 
--  ['note'] = { 'path1', 'path2' },
--  ['dotenv'] = { 'path1'}
--  }

--  --]]
  
--  -- for  index, value in ipairs ( lKeys ) do
--  --   if tProject[value].type then
--  --     local navType = tProject[value].type
--  --     if not vim.tbl_contains(lTypes,navType) then
--  --       lTypes[#lTypes+1] = navType
--  --     end
--  --   end
--  -- end


--  -- for each nav type create a nav Command
--  -- h command-completion-custom*
--  -- h command-completion-customlist*
--  for  index, value in ipairs ( lTypes ) do

--    -- local sCommand = "command! -nargs=1 E" .. 
--    -- value .. 
--    -- "-complete=custom,v:lua.lsp_complete_installable_servers"
--   -- vim.api.nvim_command(sCommand)
--  end


--  return tCompleteItems
--end
--print(vim.inspect( nav_cmds()))
-- nav_cmds()



-- function _M.chunk( fd )
-- local chunk = fd:read("*all")
-- fd:close()
-- return chunk
-- end

-- function _M.writeFile( s, f )
--   local fd  = io.open( f, 'w' )
--   if not fd then
--     return fd
--   end
--   fd:write( s )
--   fd:close()
-- end

-- function _M.appendToFile( s, f )
--   local fd  = io.open( f, 'a' )
--   if not fd then
--     return fd
--   end
--   fd:write( s )
--   fd:close()
-- end

return _M
-- print(vim.inspect( _M.project_root()))
-- print(vim.inspect( _M.projections()))
