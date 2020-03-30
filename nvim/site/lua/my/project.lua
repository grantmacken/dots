local _M = {}
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
  return mJsonProjections
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

_M.list_all_project_files = function()
  local mJsonProjections = get_json_projections()
  return getJsonProjectionsExpandedFiles(mJsonProjections)
end
-- print( inspect(_M.list_all_project_files()))
----
-- _M.show_project_files = function()
--   require('my.fwin').show(listJsonProjectionsExpandedFiles(get_json_projections()))
-- end
--_M.show_project_files()

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

-- print(inspect(_M.start('dots')))

local absToRel = function( pRoot ,pFile )
  local iLen = string.len(pRoot) +2
  return string.sub(pFile,iLen)
end

local project_activate = function( mProject )
 --[[
- [x] set lcd
- [*] set show commands
- [*] Upcase nav commands
TODO
show_project_files
 --]]
  vim.api.nvim_command('tcd ' .. mProject.root )
  -- -buffer	    The command will only be available in the current buffer.
   -- api.nvim_set_var('cmd_type',false)

end

-- the process of discovering whether
-- a buffer has projections
_M.detect = function()
  --  api.nvim_set_var('myProjects',{})
  -- local win = api.nvim_get_current_win()
  local iBuf = api.nvim_get_current_buf()
  -- TODO  comment out for tests
  local status = pcall(api.nvim_buf_get_var,iBuf,'projections')
  if status == true then
     return  api.nvim_buf_get_var( iBuf, 'projections' )
  end

  if not api.nvim_buf_is_loaded( iBuf ) then 
   return false
  end
  local bufType = api.nvim_buf_get_option( iBuf, 'buftype' )
  local fileType = api.nvim_buf_get_option( iBuf, 'filetype' )
  -- TODO also check nvim_buf_is_valid
  if not isAllowableBuffer(bufType,fileType) then 
    -- print('WARN: condition not met:  buffer not allowed')
    return false
  end
  local pFile = api.nvim_buf_get_name( iBuf )
  local status, mJsonProjections = get_json_projections( iBuf )
  if not status then return status end
  -- print(inspect(type(mJsonProjections)))
  ---- get the ID from
  local sID = mJsonProjections['*'].project
  if ( type(sID) ~= 'string' ) then 
    print('ERR: no project ID in JSON projections ')
    return  false
  end
-- print( inspect(mP) )

-- 
--[[ ===  global myProjects ===
myProjects is a global var
It starts as a empty table.
As projections are discovered for a buffer
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
--
  local pRelFile = absToRel( pRoot ,pFile )
  local aFiles = listJsonProjectionsExpandedFiles(mJsonProjections)

  local mP = {
    project = sID,
    root = pRoot, 
    nav = getProjectionsNavItems(mJsonProjections)
  }

  local status = pcall(api.nvim_get_var,'myProjects')
  if status ~= true then
    print('INFO: init global [ myProjects ] ')
    fs.clean_log( pRoot )
    api.nvim_set_var('myProjects',{})
    fs.log( pRoot , 'global [ myProjects ] initiated with empty table' )
  end
  local gMyProjects = api.nvim_get_var('myProjects')
  if ( type( gMyProjects) ~= 'table' ) then 
    print('ERR: got [ '  .. type(gMyProjects) .. ' ] global "myProject" should be table ')
    return false
  end

  if vim.tbl_isempty( gMyProjects ) then
    -- fresh start of all projects
    gMyProjects[sID] = mP
    fs.log( pRoot , 'global [ myProjects ] added project : ' .. sID  )
    -- note gMyProjects is added to global myProjects only if projections found for buffer
    api.nvim_set_var('myProjects', {})
  else
    local tKeys = vim.tbl_keys(mJsonProjections)
    if not vim.tbl_contains(tKeys,sID) then
      gMyProjects[sID] = mP
      fs.log( pRoot , 'global [ myProjects ] added project : ' .. sID  )
    end
  end

 
  --[[
2. activate

 activation occurs per buffer
 activation only occurs 
  - on allowable buffers [ fs.isAllowableBuffer(bufType,fileType) ]
  - only if a projection has a type key
  - the buffer filename is matched to a wildcard expanded projection value
--]]
  if vim.tbl_contains(aFiles, pRelFile ) then
    fs.log( pRoot, 'buffer [ ' .. pRelFile .. ' ] projections discovered' )

    --[[ === new project discovery and activation  ===
    - activate if myProjects empty => there is a first project fo myProjects
    - activate if myProjects does not contain sID key => their is an additional project for myProjects
    --]]
    local mProject = gMyProjects[sID]
    local myProjects = api.nvim_get_var('myProjects')
    if vim.tbl_isempty( myProjects ) then
      fs.log( pRoot, 'global [ myProjects ] activating project: "' .. sID  .. '"')
        api.nvim_set_var('myProjects',gMyProjects)
        project_activate(mProject)
    else
      local tKeys = vim.tbl_keys(myProjects)
      if vim.tbl_contains(tKeys,sID) then
        fs.log( pRoot, 'global [ myProjects ] project: "' .. sID  .. '" already activated')
      else
        fs.log( pRoot, 'global [ myprojects ] activating project: "' .. sID  .. '"')
        api.nvim_set_var('myProjects',gMyProjects)
        project_activate(mProject)
      end
    end
    -- reset global NOTE! only if we found a projectionist buffer
    -- TODO! projects_activate
    --set local buffer var
    local bufProjections = getProjection(mJsonProjections,pRelFile)
    if ( type(bufProjections) ~= 'table' ) then
        fs.log( pRoot, 'WARN: buffer [ ' .. pRelFile ..' ] has no projections for project: ' .. sID  .. '"')

    return 
  end

    local tMore = {
      project = sID,
      root = pRoot,
      file = pRelFile
    }
    fs.log( pRoot, 'buffer [ ' .. pRelFile .. ' ] - set projections')
    api.nvim_buf_set_var(iBuf,'projections',vim.tbl_extend( 'error', bufProjections, tMore))
    -- api.nvim_command(sBegin .. 'cmdline_complete_projects MyShowProjects lua require("my.project").show_projects()')
    -- api.nvim_command(sBegin .. 'cmdline_complete_projects MyShowProjects lua require("my.project").show_projects()')
    -- === BUFFER COMMANDS ===
    fs.log( pRoot, 'buffer [ ' .. pRelFile .. ' ] - set "MyShow" commands')
    local sBegin = 'command! -nargs=1 -buffer -complete=customlist,v:lua.'
    api.nvim_command(sBegin .. 'cmdline_complete_projects MyShowProject lua require("my.project").show_project(<f-args>)')
    api.nvim_command(sBegin .. 'cmdline_complete_projects MyShowLog lua require("my.project").show_log(<f-args>)')
    fs.log( pRoot, 'buffer [ ' .. pRelFile .. ' ] - set E edit commands')
    local aKeys =  vim.tbl_keys(mProject.nav)
    for  index, sKey in ipairs ( aKeys ) do
      api.nvim_command(sBegin .. 'cmdline_complete_nav E' ..sKey ..' lua require("my.project").edit(<f-args>)')
    end
  end
  -- TODO alternate commands

-- api.nvim_buf_get_var(iBuf, 'projections')
--- api.nvim_buf_get_var('myProjections')
--  return api.nvim_buf_get_var(iBuf, 'projections')
end
-- print(inspect(_M.detect()))

_M.root_from_id = function( sID )
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

-- _M.show_json_projections = function()
--   -- local myProjects = api.nvim_get_var('myProjects')
--   -- if vim.tbl_isempty( myProjects ) then 
--   --   return print( 'ERR: global "myProjects" is empty' )
--   -- end
--   -- local aLines = vim.split(vim.inspect(myProjects),'\n' )
--   -- require('my.fwin').show(aLines)
-- end

_M.show_projects = function()
  local myProjects = api.nvim_get_var('myProjects')
  if vim.tbl_isempty( myProjects ) then 
    return print( 'ERR: global "myProjects" is empty' )
  end
  local aLines = vim.split(vim.inspect(myProjects),'\n' )
  require('my.fwin').show(aLines)
end
-- _M.show_projects()

_M.list_projects = function()
  local myProjects = api.nvim_get_var('myProjects')
  if vim.tbl_isempty( myProjects ) then return myProjects end
  return vim.tbl_keys( myProjects )
end
-- print(inspect(_M.list_projects()))

_M.get_project = function(sID)
  local myProjects = api.nvim_get_var('myProjects')
  if vim.tbl_isempty( myProjects ) then return false end
  return myProjects[sID]
end
-- print(inspect(_M.get_project('dots')))

_M.show_project = function(sID)
  local mProject = _M.get_project(sID)
  if vim.tbl_isempty( mProject ) then return false end
  local aLines = vim.split(vim.inspect(mProject),'\n' )
  require('my.fwin').show(aLines)
end
--_M.show_project('dots')


-- print(inspect(_M.list_project_files() ))


-- _M.show_project_files( 'dots')


-- === BUFFER ===


_M.get_buf_projections = function()
  local iBuf = api.nvim_get_current_buf()
  local mProjections = vim.fn.getbufvar( iBuf, 'projections')
  if ( type(vim.fn.getbufvar( iBuf, 'projections')) ~= 'table' ) then 
    print('WARN: no projections set for buffer' )
  end
 return mProjections
end
-- print(inspect(_M.get_buf_projections()))

_M.show_buf_projections = function()
  local mProjections =_M.get_buf_projections()
  local tLines = vim.split(inspect(mProjections),'\n')
  require('my.fwin').show(tLines)
end
-- _M.show_buf_projections()

_M.get_projection_value = function( sKey )
  local mProjections =_M.get_buf_projections()
  local aKeys = vim.tbl_keys(mProjections)
  if ( vim.tbl_contains(aKeys, sKey) ) then 
    return mProjections[sKey]
  else
    print('WARN: [ ' .. skey .. ' ] key not found' )
    return false
  end
  return aKeys
end
-- print(inspect(_M.get_projection_value('type')))

_M.show_log = function( sID )
  local pRoot = _M.get_projection_value('root')
  local sChunk = fs.read(pRoot,'.project.log')
  local tLines = vim.split(sChunk,'\n')
  require('my.fwin').show(tLines)
end
-- _M.show_log()

-- _M.list_buffer_nav = function()
--   local sID = _M.get_projection_value('project')
--   local mProject = _M.get_project(sID)
--   return mProject.nav
-- end
-- print(inspect(_M.list_buffer_nav()))

-- TODO!
_M.list_files_by_type = function(sType)
  local sID = _M.get_projection_value('project')
  if type( sID ) ~= 'string' then return {} end
  local aNav = _M.get_project( sID ).nav[sType]
  if type( aNav ) ~= 'table' then return {} end
  return aNav
end
-- print(inspect(_M.list_files_by_type( 'Enote' ) ))

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

-- _M.cmdline_complete_nav =  function( sArgLead, sCmdLine, iCursorPos )
--   return cmdline_complete( _M.list_buffer_nav(sCmdLine), sArgLead  )
-- end

_M.cmdline_complete_projects =  function( sArgLead, sCmdLine, iCursorPos )
  return cmdline_complete( _M.list_projects(), sArgLead )
end

_M.cmdline_complete_nav = function( sArgLead, sCmdLine, iCursorPos)
  local status = pcall(api.nvim_get_var,'myCmdLine')
  if status ~= true then
    api.nvim_set_var('myCmdLine',string.sub(vim.trim(sCmdLine),2))
  end
  local aList = _M.list_files_by_type(api.nvim_get_var('myCmdLine'))
  return cmdline_complete(aList, sArgLead )
end

_M.edit =  function( pFile )
  api.nvim_del_var('myCmdLine')
  if fs.is_file(pFile) then
    api.nvim_command( 'edit '.. pFile )
  else
    -- should reload 'file'
    api.nvim_command( 'edit '.. _M.get_projection_value('file') )
  end
end

return _M
