local _M = {}

local util = require('my.util')
local log = require('my.log').log
local api = vim.api

--[[
-- :NvimAPI
-- :h api
-- :h lua
--]]
local function getProjectionValue( projection )
  -- log( ' - get projection value: ' .. projection )
  local arr = {}
  arr[1] = projection
  -- local value, err = pcall(isGlobalVar,'my_placeholder_window')
  local value, err = pcall(api.nvim_call_function,'my#project#value',arr)
  if not value then
    log( '[ERR] ' ..  err )
    return nil
  end
  return api.nvim_call_function('my#project#value',arr)
end

local function getRelativePath( fPath )
  local dProjectPath = api.nvim_call_function('projectionist#path',{})
  --local iProjectPathLength =  string.len(dProjectPath) + 2
  local iProjectPathLength =  api.nvim_strwidth(dProjectPath) +2
  return string.sub( fPath, iProjectPathLength )
end

_M.getProjectionValue = getProjectionValue

function _M.detect()
  local value, err = pcall(api.nvim_get_var, 'my_project_init')
  if not value then
    api.nvim_set_var('my_project_init', 0)
    -- log('[ERR] ' .. err )
    return
  end
  -- util.echom( ' -  searching for projections')
  -- log( ' -  searching for projections'  )
  return
end


--[[
For each projectionist buffer
look for the projection values we handle

1. buffer content piped to stdin of CLI progmam,
   then buffer content replaced with the stdout of that command.

# format: pretty formatting
  set the formatprg which will be used by neoformat
  let g:neoformat_try_formatprg = 1

# linters:  static analysis of typed languages
  up setup ale linters for buffer
  Errors, Warnings placed into location list

2. prove:  onsave buffer content piped to stdin of CLI prog,
   then stdout, stdout analyised with
  Errors, Warnings and Information items placed into quickfix list
  The buufer content is not altered

  prove is an array of CLI jobs
   if the job job exit status is a succesfull 0
   then the next job in the array will run
  if the job fails with a exit status 1
    then then no addtional jobs will run

 ---]]


function _M.activate()
  -- log( ' - projection activated'  )
  local value, err = pcall(api.nvim_get_var, 'my_project_init')
  if not value then
    api.nvim_command('Pcd')
    require('my.log').clear()
    log( ' - project activated'  )
    log( ' - ================='  )
    api.nvim_set_var('my_project_init', true )
  end

  local buffer = api.nvim_get_current_buf()
  --local bufHasProjection, err = pcall(isBufferVar,'projectionist')
  local value, err = pcall(api.nvim_buf_get_var, buffer,'projectionist_file')
  if not value then
    -- log('[ERR] ' .. err )
    return
  end

  local projectFile = getRelativePath(api.nvim_buf_get_var(buffer,'projectionist_file'))
  local value = pcall(api.nvim_buf_get_var, buffer, 'my_buffer_init')
  if not value then
    log( ' - buffer activated: [ ' .. projectFile .. ' ]'  )
    api.nvim_buf_set_var( buffer, 'my_buffer_init', true )
    --  tests array
    local oProofs = getProjectionValue( 'prove' )
    if type(oProofs) == 'table' then
      local iProofs = util.isArray( oProofs )
      if  iProofs > 0  then
        local sType =  getProjectionValue('type')
        log ( ' - - tests type: [ ' .. sType .. ' ]' )
        log ( ' - - tests sequence: : [ ' .. table.concat(oProofs," | ") .. ' ]'  )
        local sTestFile = getProjectionValue('alternate')
        -- if the sType starts with test then the test file is the  project file
        if string.sub(sType ,1,string.len('test')) == 'test'then
          sTestFile = projectFile
        end
        api.nvim_buf_set_var( buffer, 'my_test_file', sTestFile )
        log ( ' - - test file: [ ' .. sTestFile .. ' ]')
        --api.nvim_command( 'autocmd CursorHold <buffer=' .. buffer .. '>  echo "hold"' )
        --@see nvim/site/lua/my/jobs.lua
        local str = 'autocmd BufWritePost <buffer=' ..
        buffer ..'>  lua require("my.jobs").qfJobs("prove")'
        api.nvim_command( str )
         log ( ' - - run tests on [ ' .. str  .. ' ]')
      end
    end
    -- build cmd
    local oBuilds = getProjectionValue( 'build' )
    if type(oBuilds) == 'table' then
        local iBuild = util.isArray( oBuilds )
        if  iBuild > 0  then
        local sType =  getProjectionValue('type')
        log ( ' - - build type: [ ' .. sType .. ' ]' )
        log ( ' - - build sequence: : [ ' .. table.concat(oBuilds," | ") .. ' ]'  )
        local sType =  getProjectionValue('type')
        log ( ' - -  buffer build is to run with : [ autocommand BufWritePost ] '  )
        local str = 'autocmd BufWritePost <buffer=' ..
            buffer ..'>  lua require("my.jobs").qfJobs("build")'
            api.nvim_command( str )
        -- api.nvim_command( 'autocmd CursorHold <buffer=' .. buffer .. '>  echo "hold"' )
        end
    end
     -- linters array
    local oLinters = getProjectionValue( 'linters' )
    if type(oLinters) == 'table'then
      local iLinters = util.isArray( oLinters )
      if  iLinters > 0  then
        log ( ' - - setup ale linters: [ ' .. table.concat(oLinters," | ") .. ' ]' )
        api.nvim_buf_set_var( buffer, 'ale_linters', oLinters )
        -- set linting for buffer
      end
    end
    -- format program string
    local sFormatter = getProjectionValue( 'format' )
    if type(sFormatter) == 'string' then
      log ( ' - - setup formatter: [ ' .. sFormatter .. ' ]' )
      api.nvim_buf_set_option( buffer, 'formatprg', sFormatter )
      -- set linting for buffer
    end
    -- format program string
    -- TODO!
    local sCoverage = getProjectionValue( 'coverage' )
    if type(sCoverage) == 'string' then
      log ( ' - - setup coverage: [ ' .. sCoverage .. ' ]' )
      api.nvim_buf_set_var( buffer, 'my_coverage', sCoverage )
      -- set linting for buffer
    end
  end
end




-- TODO! remove below




--[[
Find command in terminal window
--]]
local function findCmdInTermWin( sCmd )
  local wins = api.nvim_list_wins()
  local winFound
  local buffer
  local bufferName
  for i, window in ipairs(wins) do
    buffer = api.nvim_win_get_buf(window)
    local bufferType = api.nvim_buf_get_option( buffer, 'buftype' )
    bufferName = api.nvim_buf_get_name( buffer )
    if bufferType == 'terminal' then
      local nameFound = string.find( bufferName, sCmd )
      if nameFound ~= nil then
        winFound = window
        api.nvim_win_set_height(winFound, 10)
      end
    end
  end
  return winFound, buffer
end


--[[
--  Find Buffer name in window
--]]
local function findBufNameInWin( fName )
  local wins = api.nvim_list_wins()
  local winFound
  for i, window in ipairs(wins) do
    local buffer = api.nvim_win_get_buf(window)
    local bufferName = api.nvim_buf_get_name( buffer )
    local fBuf = getRelativePath( bufferName)
    if fBuf == fName then
      winFound = window
      api.nvim_win_set_height(winFound, 10)
      break
    end
  end
 return winFound
end



function _M.openInTerminalWindow( projection )
  -- api.nvim_command('DeleteHiddenBuffers')
  local arr = {}
  arr[1] = projection
  local sTermCommand = api.nvim_call_function('my#project#value',arr)
  -- util.echom( type(sTermCommand) )
  if type(sTermCommand) ~= 'string' then
    return
  end
  local oOpts = {
    sTermCommand
  }
  -- util.echom( 'create new window' )
  -- util.echom( ' - execute term command: ' ..  sTermCommand )
  local placeHolderWindow = api.nvim_get_current_win()
  local winFound, buffer = findCmdInTermWin( sTermCommand )
  if winFound then
     util.echom( ' - window: ' .. tostring(winFound))
    -- util.echom( ' - bufferName: ' .. bufferName)
    -- util.echom( ' - buffer: ' .. tostring(buffer))
    api.nvim_set_current_win(winFound)
    api.nvim_set_current_buf(buffer)
    api.nvim_command('bw!')
  end
   -- util.echom( ' - open new window' )
   api.nvim_command('botright 7new term')
  --  api.nvim_win_set_height(api.nvim_get_current_win(), 7)
  -- api.nvim_win_set_height(api.nvim_get_current_win(), 5)
   api.nvim_call_function('termopen',oOpts)
   api.nvim_set_current_win(placeHolderWindow)
   -- local window = api.nvim_get_current_win()
   -- local buffer = api.nvim_get_current_buf()
   -- api.nvim_win_set_height(window, 7)
   -- local iLines = api.nvim_buf_line_count(buffer)
   --  util.echom( iLines )
   -- local iLines = api.nvim_buf_line_count(buffer)
   -- api.nvim_set_cursor(buffer)
    -- ['on_stdout'] = onStdOut(),
   -- ['on_stderr'] = onStdErr(),
   --oOpts['on_exit'] = onExit(api.nvim_get_current_win(),placeHolderWindow)
end
--[[
Display Project Log
--]]
function _M.openInSplitWindow( projection )
  local arr = {}
  arr[1] = projection
  local fLog = api.nvim_call_function('my#project#value',arr)
  local placeHolderWindow = api.nvim_get_current_win()
  local winFound = findBufNameInWin( fLog )
  if winFound then
    --util.echom( ' - use old window' )
    api.nvim_set_current_win(winFound)
    api.nvim_command('Elog')
  else
    -- util.echom( 'create new window' )
    api.nvim_command('Slog')
    api.nvim_win_set_height(api.nvim_get_current_win(), 10)
  end
  api.nvim_set_current_win(placeHolderWindow)
end



return _M
