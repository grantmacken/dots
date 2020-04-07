local M = {}
local vim = vim
local api = vim.api
local uv  = vim.loop
local fn  = vim.fn
local inspect  = vim.inspect
local fs = require('my.fs')
local err, got, exp = require('my.utility').printr()

--[[
-- :NvimAP
h api
h lua
h vim-function
for built in functions e.g. vim.fn.getcwd()
h vim-variable
for built in functions 
e.g. api.eval('v:echospace')
e.g. api.eval'v:oldfiles')
--]]

local read_projections = function( pRoot )
  local pFile = '.projections.json'
  local chunk = fs.read( pRoot, pFile )
  local status, mJsonProjections = pcall(fn.json_decode,chunk)
  if not status then
    err( 'could not decode "projections.json"  at ' .. pRoot )
    err(  got( status ) .. exp( true ) )
    return false, {}
  end
  return true, mJsonProjections
end

local get_json_projections = function( pRoot )
  local gitRoot
  if type( pRoot ) == 'nil' then
    local cwd =  vim.loop.cwd()
    if fs.is_dir( cwd .. '/.git'  ) then
      gitRoot = cwd
    else
      -- todo get current buffer
     -- gitRoot =  fs.git_project_root(cwd)

     return false
    end
      -- if ( type(gitRoot) ~= 'string' ) then 
    --   err( ' '  )
    --   err( got( gitRoot ) .. exp('string') )
    --   return false
    -- end
  else
    gitRoot = pRoot
  end
  local ok, mJsonProjections = read_projections( gitRoot )
  if not ok then err( got( ok ) .. exp(true) ) return false end
  if vim.tbl_isempty(mJsonProjections) then err( got({}) .. exp('mapped table') ) return false end
  if not ( vim.tbl_contains(vim.tbl_keys(mJsonProjections),'*')) then
   err( 'projections.json should have a wildcard key "*"'  )
   return false
  end
  if not ( vim.tbl_contains(vim.tbl_keys(mJsonProjections['*']),'project')) then
   err( 'in .projections.json the root wildcard "*" object should contain a "project" object'  )
   return false
  end
  local tRootExtend  = vim.tbl_extend( 'error', mJsonProjections['*'],{root = gitRoot})
  local tbl = {}
  local aKeys = vim.tbl_keys( mJsonProjections )
  for i, v in ipairs ( aKeys ) do
    if v == '*' then
     tbl[v] = tRootExtend
   else
    tbl[v] = mJsonProjections[v]
    end
  end
  return tbl
end
-- print( inspect(get_json_projections()) )

local getJsonProjectionsExpandedFiles = function( mJsonProjections )
  local  aFiles= {}
  local aKeys = vim.tbl_keys(mJsonProjections)
  for i, v in ipairs ( aKeys ) do
    if mJsonProjections[v].type then
       local aExpanded = vim.split(vim.fn.expand(v),'\n')
         for int, val in ipairs ( aExpanded ) do
           if not fs.is_dir(val) then
              vim.list_extend(aFiles,{val})
           end
          end
    end
  end
  return aFiles
end

M.list_all_project_files = function()
  local mJsonProjections = get_json_projections()
  return getJsonProjectionsExpandedFiles(mJsonProjections)
end
-- print( inspect(M.list_all_project_files()))
----
-- M.show_project_files = function()
--   require('my.fwin').show(listJsonProjectionsExpandedFiles(get_json_projections()))
-- end
--M.show_project_files()

local getProjection = function( mJsonProjections ,pFile )
  local mProjections
  local aKeys = vim.tbl_keys(mJsonProjections)
  for index, value in ipairs ( aKeys ) do
    if mJsonProjections[value].type then
      local aValues =  vim.split(vim.fn.expand(value),'\n')
      if vim.tbl_contains(aValues, pFile) then
        mProjections = mJsonProjections[value]
      end
    end
  end
  return mProjections
end


--]]
local getProjectionsNavItems = function( mJsonProjections )
  local aTypes = {}
  local aKeys = vim.tbl_keys( mJsonProjections )
  for  int, sValue in ipairs ( aKeys ) do
    if mJsonProjections[sValue].type then
      local sType  = mJsonProjections[sValue].type
      local aExpanded = vim.split(vim.fn.expand(sValue),'\n')
      if aTypes[sType] then
        for  i, v in ipairs ( aExpanded ) do
          if not vim.tbl_contains(aTypes[sType],v) then
             vim.list_extend(aTypes[sType],{v})
          end
        end
      else
        aTypes[sType] = aExpanded
      end
    end
  end
  return aTypes
end

local isAllowableBuffer = function(bt,ft)
  local conditional = true
  -- if buftype is "" then this is a normal buffer
  if ( bt ~= ""  ) then conditional = false
  else
    if ( ft == 'dirvish') then conditional = false end
    if (ft == 'netrw' ) then conditional = false end
  end
  return conditional
end

-- print(inspect(M.start('dots')))

local absToRel = function( pRoot ,pFile )
  local iLen = string.len(pRoot) +2
  return string.sub(pFile,iLen)
end

--local project_activate = function( mProject )
-- --[[
--- [x] set lcd
--- [*] set show commands
--- [*] Upcase nav commands
--TODO
--show_project_files
-- --]]
--  vim.api.nvim_command('tcd ' .. mProject.root )
--  -- -buffer	    The command will only be available in the current buffer.
--   -- api.nvim_set_var('cmd_type',false)

--end


-- the process of discovering whether
-- a tab has a git-root with projections
--[[ ===  global myProjects ===
myProjects is a global var
It starts as a empty table.
As projections are discovered for a window
a key may be added to the myProjects table
A myProjects Key is added only if the key is not present.
myProjects Key are project identifiers.
The project key is found by looking at projections.json 
and looking for the wildcard  '*' object with child  'project' object.
The 'project' objects value is the project 'key' for the myProjects table.

Keys in a myProjects signify a 'project' table
a project table has these mapped keys
 - 'project' the project ID obtained from projections.json
 - 'root': the file system directory path to the project
 - 'nav':  these are  nav items obtained from projections.json


A note on the project 'root' key
At the project 'root' due to the detect process know there will be
   1. a projections.json file
   2. a git repo

--]]
M.detect = function()
  local iBuf = api.nvim_get_current_buf()
  local ok, mProjections = pcall(api.nvim_buf_get_var,iBuf,'projections')
  if ok then return mProjections end
  local mJsonProjections = get_json_projections()
  -- if not mJsonProjections then return false end
  local sID   = mJsonProjections['*'].project
  local pRoot = mJsonProjections['*'].root
  local ok, gMyProjects = pcall(api.nvim_get_var,'myProjects')
  if not ok then
    fs.clean_log( pRoot )
    gMyProjects = {}
    gMyProjects[sID] = {
      root = pRoot,
      nav = getProjectionsNavItems(mJsonProjections)
    }
    fs.log( pRoot , '🌐 [ myProjects ] initiated with project:' .. sID )
    api.nvim_set_var('myProjects', gMyProjects )
  else
    local tKeys = vim.tbl_keys(gMyProjects)
    if not vim.tbl_contains(tKeys,sID) then
      gMyProjects[sID] = {
        root = pRoot,
        nav = getProjectionsNavItems(mJsonProjections)
      }
      fs.log( pRoot , '🌐 [ myProjects ] added project : ' .. sID  )
      api.nvim_set_var('myProjects', gMyProjects )
    end
  end

  -- TODO  comment out for tests
  -- local status = pcall(api.nvim_buf_get_var,iBuf,'projections')
  -- if status == true then
  --   return  api.nvim_buf_get_var( iBuf, 'projections' )
  -- end
  if not api.nvim_buf_is_loaded( iBuf ) then return false end
  local bufType = api.nvim_buf_get_option( iBuf, 'buftype' )
  local fileType = api.nvim_buf_get_option( iBuf, 'filetype' )
  -- TODO also check nvim_buf_is_valid
  if not isAllowableBuffer(bufType,fileType) then return false end
  local pFile = api.nvim_buf_get_name( iBuf )
  ---- get the ID from
  local sID = mJsonProjections['*'].project
  local pRelFile = absToRel( pRoot ,pFile )
  local aFiles =  getJsonProjectionsExpandedFiles(mJsonProjections)
  if not vim.tbl_contains(aFiles, pRelFile ) then return end
  --M.Activate( api.nvim_get_var('myProjects') )
  --[[ === activate ===
 activation occurs per buffer
 activation only occurs 
  - on allowable buffers [ fs.isAllowableBuffer(bufType,fileType) ]
  - only if a projection has a type key
  - the buffer filename is matched to a wildcard expanded projection value
--]]
  fs.log( pRoot, 'buffer [ ' .. pRelFile .. ' ] projections discovered' )
  local  bufInitialProjections = getProjection(mJsonProjections,pRelFile)
  local tMore = {
    project = sID,
    root = pRoot,
    file = pRelFile
  }
  fs.log( pRoot, 'buffer [ ' .. pRelFile .. ' ] - set projections')
  local bufProjections =  vim.tbl_extend( 'error',bufInitialProjections, tMore)
  api.nvim_buf_set_var(iBuf,'projections',bufProjections)
  local mProject = api.nvim_get_var('myProjects')[sID]

    -- === BUFFER COMMANDS ===
    fs.log( pRoot, 'buffer [ ' .. pRelFile .. ' ] - set "MyShow" commands')
    local sBegin = 'command! -nargs=1 -buffer -complete=customlist,v:lua.'
    api.nvim_command(sBegin .. 'cmdline_complete_projects MyShowProject lua require("my.project").show_project(<f-args>)')
    api.nvim_command(sBegin .. 'cmdline_complete_projects MyShowLog lua require("my.project").show_log(<f-args>)')
    fs.log( pRoot, 'buffer [ ' .. pRelFile .. ' ] - set E edit commands')
    local aKeys = vim.tbl_keys(mProject.nav)
    for  i, sKey in ipairs ( aKeys ) do
      local cmd = sBegin .. 'cmdline_complete_nav E' ..sKey ..' lua require("my.project").edit(<f-args>)'
      --print(cmd)
      api.nvim_command(cmd)
    end
  return  api.nvim_buf_get_var(iBuf,'projections')

end
-- print( inspect(M.detect()) )

M.root_from_id = function( sID )
  local myProjects = api.nvim_get_var('myProjects')
  if vim.tbl_isempty( myProjects ) then return false end
  local tKeys = vim.tbl_keys( myProjects )
  if not vim.tbl_contains(tKeys,sID) then return false end
  local tProject = myProjects[sID]
  if ( type(tProject) ~= 'table' ) then return false end
  local pRoot = tProject.root
  if ( type(pRoot) ~= 'string' ) then return false end
  return pRoot
end

-- M.show_json_projections = function()
--   -- local myProjects = api.nvim_get_var('myProjects')
--   -- if vim.tbl_isempty( myProjects ) then 
--   --   return print( 'ERR: global "myProjects" is empty' )
--   -- end
--   -- local aLines = vim.split(vim.inspect(myProjects),'\n' )
--   -- require('my.fwin').show(aLines)
-- end

M.show_projects = function()
  local myProjects = api.nvim_get_var('myProjects')
  if vim.tbl_isempty( myProjects ) then 
    return print( 'ERR: global "myProjects" is empty' )
  end
  local aLines = vim.split(vim.inspect(myProjects),'\n' )
  require('my.fwin').show(aLines)
end
-- M.show_projects()

M.list_projects = function()
  local myProjects = api.nvim_get_var('myProjects')
  if vim.tbl_isempty( myProjects ) then return myProjects end
  return vim.tbl_keys( myProjects )
end
 --print(inspect(M.list_projects()))

M.get_project = function(sID)
  local myProjects = api.nvim_get_var('myProjects')
  if vim.tbl_isempty( myProjects ) then return false end
  return myProjects[sID]
end
--print(inspect(M.get_project( 'dots' )))

M.get_project_value = function( sID, sKey )
  local myProject = M.get_project(sID)
  local aKeys = vim.tbl_keys(myProject)
  if ( vim.tbl_contains( aKeys, sKey)) then  
    return myProject[sKey]
  else
    err( 'could not resolve key: ' .. sKey) 
    return false
  end
end
-- print(inspect(M.get_project_value( 'dots','root' )))

M.get_project_nav = function( sID )
 return M.get_project_value(sID,'nav') 
end

 -- print(inspect(M.get_project_nav('dots')))

M.show_project = function(sID)
  local mProject = M.get_project(sID)
  if vim.tbl_isempty( mProject ) then return false end
  local aLines = vim.split(vim.inspect(mProject),'\n' )
  require('my.fwin').show(aLines)
end
-- M.show_project('dots')

M.open_project = function(sID)
  print('TODO!')
end

M.close_project = function(sID)
  print('TODO!')
end

-- === BUFFER ===

M.get_buf_projections = function()
  local iBuf = api.nvim_get_current_buf()
  local mProjections = vim.fn.getbufvar( iBuf, 'projections')
  if ( type(vim.fn.getbufvar( iBuf, 'projections')) ~= 'table' ) then 
    print('WARN: no projections set for buffer' )
  end
 return mProjections
end
--print(inspect(M.get_buf_projections()))

M.show_buf_projections = function()
  local mProjections =M.get_buf_projections()
  local tLines = vim.split(inspect(mProjections),'\n')
  require('my.fwin').show(tLines)
end
-- M.show_buf_projections()

M.get_projection_value = function( sKey )
  local mProjections = M.get_buf_projections()
  local aKeys = vim.tbl_keys(mProjections)
  if ( vim.tbl_contains(aKeys, sKey) ) then 
    return mProjections[sKey]
  else err( got(sKey) .. ' => expected a valid key' ) return end
end
-- print(inspect(M.get_projection_value('type')))

M.get_projections_project_value = function()
  return M.get_projection_value('project')
end

M.get_projections_type_value = function()
  return M.get_projection_value('type')
end

M.get_projections_root_value = function()
  return M.get_projection_value('root')
end

-- print(inspect(M.get_projections_root_value()))

M.show_log = function( sID )
  local pRoot = M.get_projection_value('root')
  local sChunk = fs.read(pRoot,'.project.log')
  local tLines = vim.split(sChunk,'\n')
  require('my.fwin').show(tLines)
end

-- M.show_log()

M.list_files_by_type = function( sType )
local sID = M.get_projections_project_value()
if not sID then err( got(sID) .. ' => expected projections project value') return end
return M.get_project_nav(sID)[sType]
end
-- print(inspect(M.list_files_by_type( 'note') ))

M.list_file_names_by_type = function(sType)
  local aList = M.list_files_by_type(sType)
  local res = {}
  for _, sValue in ipairs(aList) do
    local aFiles = vim.split(sValue, '/')
    local sFile =  aFiles[#aFiles]
    local aFile = vim.split(sFile, '[.]')[1]
    vim.list_extend(res,{aFile})
  end
  return res
end

-- M.get_file_by_filename = function( pFilename )
--   local sID = M.get_projection_value('project')
--   if type( sID ) ~= 'string' then return false end
--   local aList = M.get_project_value(sID,'nav')[sType]
--   local res = {}
--   for _, sValue in ipairs(aList) do
--     local split = vim.split(sValue, '/')
--     if ( sValue )
--      vim.list_extend(res, {split[#split]})
--   end
--   return res
-- end


--print(inspect(M.list_file_names_by_type( 'note') ))


-- == Command Line Completions == --
--[[
getcmdline() String	return the current command-line
getcmdpos()			Number	return cursor position in command-line
getcmdtype()			String	return current command-line type
getcmdwintype()			String	return current command-line window type
getcompletion({pat}, {type} [, {filtered}]) List	list of cmdline completion matches
setcmdpos({pos})		Number	set cursor position in command-line

complete_info(['mode'])  should return with value "cmdline"
--]]

local cmdline_complete = function( aList, sArgLead )
  local res = {}
  for index, value in ipairs(aList) do
    if ( string.len(sArgLead) > 0 ) then
      if vim.startswith(value,sArgLead) then
        vim.list_extend(res,{value})
      end
    else
      vim.list_extend(res,{value})
    end
  end
  return res
end

-- M.cmdline_complete_nav =  function( sArgLead, sCmdLine, iCursorPos )
--   return cmdline_complete( M.list_buffer_nav(sCmdLine), sArgLead  )
-- end

M.cmdline_complete_projects =  function( sArgLead, sCmdLine, iCursorPos )
  return cmdline_complete( M.list_projects(), sArgLead )
end

M.cmdline_complete_nav = function( sArgLead, sCmdLine, iCursorPos)
  -- api.nvim_del_var('myCmdLine')
  local status = pcall(api.nvim_get_var,'myCmdLine')
  if status ~= true then
    local sNav = string.sub(vim.trim(sCmdLine),2)
    local aFilenames = M.list_files_by_type(sNav)
    local aFiles = M.list_file_names_by_type(sNav)
    local res = {}
    res['nav'] = sNav
    res['files'] = {}
    for i, sValue in ipairs(aFiles) do
      res['files'][sValue] = aFilenames[i]
    end
    api.nvim_set_var('myCmdLine',res)
  end
  local aList = vim.tbl_keys(api.nvim_get_var('myCmdLine').files)
  return cmdline_complete(aList, sArgLead )
end
-- print(inspect(M.cmdline_complete_nav('','Enote','')))


M.edit =  function( pName )
  local mFiles = api.nvim_get_var('myCmdLine').files
  api.nvim_del_var('myCmdLine')
  local aList = vim.tbl_keys(mFiles)
  local pFile
  if vim.tbl_contains(aList,pName) then
    pFile = mFiles[pName]
  else
    return api.nvim_command( 'edit '.. M.get_projection_value('file') ) 
  end
  if fs.is_file(pFile) then
    return api.nvim_command( 'edit '.. pFile )
  else
    -- should reload 'file'
    return api.nvim_command( 'edit '.. M.get_projection_value('file') )
  end
end
-- print(inspect(M.get_projection_value('file')))

-- print(inspect(M.edit('README')))
--
return M
