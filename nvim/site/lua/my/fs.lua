local _M = {}
_M.version = 'v0.0.1'
local api     = vim.api
local inspect = vim.inspect
local uv      = vim.loop
local fn      = vim.fn
local inspect = vim.inspect
--[[ 
--https://github.com/luvit/luv/blob/master/tests/test-fs.lua 
-- https://neovim.io/doc/user/lua.html
--]]

local path_sep = uv.os_uname().sysname == "Windows" and "\\" or "/"
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
  local bufname = api.nvim_buf_get_name(bufnr)
  if fn.filereadable(bufname) == 0 then
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

-- === UTLITY ===

_M.split_file_name = function( strFilename)
  return string.match(strFilename, "(.-)([^\\]-([^\\%.]+))$")
end

-- Some path manipulation utilities
_M.is_dir = function(filename)
  local stat = uv.fs_stat(filename)
  return stat and stat.type == 'directory' or false
end

_M.is_file = function(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
end

_M.git_project_root = function( iBuf )
  -- local bufnr = vim.api.nvim_get_current_buf()
  local root_dir = buffer_find_root_dir( iBuf, function(dir)
     return _M.is_dir(path_join(dir, '.git'))
    end
   )
  return root_dir
end
-- print(inspect(_M.git_project_root(vim.api.nvim_get_current_buf())))
-- print(inspectgit_project_root(uv.cwd())))

_M.read = function( pDir, pFile )
  if type( pDir ) ~= 'string' then return false end
  local  pPath = path_join( pDir, pFile)
  --  if not _M.is_file( pPath ) then return false end
  local fd = uv.fs_open(pPath, 'r', tonumber('644', 8))
  local stat =  uv.fs_fstat( fd )
  local chunk = uv.fs_read(fd, stat.size, 0)
  local close = uv.fs_close(fd)
  return chunk
end

_M.log = function( pRoot, sData )
  -- local tProjects = api.nvim_get_var('myProjects')
  -- if vim.tbl_isempty( tProjects ) then return end
  -- local tProject = tProjects[sID]
  -- if ( type(tProject) ~= 'table' ) then return end
  -- local tKeys = vim.tbl_keys( tProjects)
  -- if not vim.tbl_contains(tKeys,sID) then return end
  -- local pRoot = tProjects[sID].root
  if type(pRoot) ~= 'string' then return end
  local pLog = path_join(pRoot, '.project.log')
  local fd
  if _M.is_file(pLog) then 
    fd = vim.loop.fs_open(pLog, 'a', tonumber('644', 8))
  else
    fd = vim.loop.fs_open(pLog, 'w', tonumber('644', 8))
  end
  local offset = -1
  local sLogLine =  '[' .. os.date("!%Y-%m-%dT%TZ") .. '] ' .. sData .. '\n'
  local chunk = vim.loop.fs_write(fd,sLogLine,offset)
  local close = vim.loop.fs_close(fd)
  return close
end

-- print(vim.inspect( _M.log('xxxx') ))

_M.clean_log = function( pRoot )
  if type(pRoot) ~= 'string' then return false end
  local pLog = path_join(pRoot, '.project.log')
  if not _M.is_file(pLog) then return end
  local fd = vim.loop.fs_open(pLog, 'w', tonumber('644', 8))
  local offset = -1
  local chunk = vim.loop.fs_write(fd,'',offset)
  local close = vim.loop.fs_close(fd)
  return close
end
-- print(vim.inspect(_M.clean_log('dots')))

_M.show_log = function( sID )
  if type(sID) ~= 'string' then return end
  local pRoot  = _M.root_from_id(sID)
  local sChunk = _M.read(pRoot,'.project.log')
  local tLines = vim.split(sChunk,'\n')
  require('my.fwin').show(tLines)
end










-- _M.show_projects = function()
--   local sDetect = vim.inspect(_M.detect())
--   local tLines = vim.split(sDetect,'\n')
--   require('my.fwin').show(tLines )
-- end




-- print(vim.inspect( _M.clean_log() ))



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
--

return _M
-- print(vim.inspect( _M.project_root()))
-- print(vim.inspect( _M.projections()))
