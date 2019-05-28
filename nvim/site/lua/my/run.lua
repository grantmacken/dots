
--[[
--  develop stuff here
--  run
--  luafile $DATAPATH/lua/my/run.lua
--  turn imto module
--]]


local log = require('my.log').log
local trm = require('my.term')
local api = vim.api

  -- local buf = api.nvim_get_current_buf()
  -- local line = api.nvim_get_current_line()
  -- local pos = api.nvim_win_get_-cursor(win)
  --local winNum = api.nvim_win_get_number(win)
  --local buf = api.nvim_win_get_buf(win)
  -- local buf = api.nvim_win_get_buf(win)
  -- local bufMark = api.nvim_buf_get_mark(buf,'M')
  -- local bufName = api.nvim_buf_get_name(buf)
  -- local bufChangedTick = api.nvim_buf_get_changedtick(buf)
  -- local bufOpt = api.nvim_buf_get_option(winBuf,'projectionist')
  -- local bufOpt = api.nvim_buf_get_var(winBuf,'projectionist')
  -- local row = pos[1]
  -- local col = pos[2]
  --  -- local bufs = api.nvim_list_bufs()
  -- util.echom( cjson.encode(bufs) )
  -- util.echom( util.isArray( bufs ))


--[[
-- Get Relative Path
--]]



local function getRelativePath( dProjectPath , fPath )
  --local iProjectPathLength =  string.len(dProjectPath) + 2
  local iProjectPathLength =  api.nvim_strwidth(dProjectPath) +2
  return string.sub( fPath, iProjectPathLength )
end

local function findBufNameInWin( dProjectPath, fName )
  local wins = api.nvim_list_wins()
  local winFound
  for i, window in ipairs(wins) do
    local buffer = api.nvim_win_get_buf(window)
    local bufferName = api.nvim_buf_get_name( buffer )
    local fBuf = getRelativePath( dProjectPath, bufferName)
    if fBuf == fName then
      winFound = window
      break
    end
  end
 return winFound
end

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
      end
    end
  end
  return winFound, bufferName, buffer
end


trm.job( 'coverage' )




-- local oMyJobs = api.nvim_get_var( 'my_jobs' )
-- local jobStack = {}

-- for key, value in pairs(oMyJobs) do
--   local oThisJob = oMyJobs[key]
--    table.insert( jobStack, oThisJob )
-- end
-- -- do first job first
--  api.nvim_buf_set_var(0, 'myBufferJobs', util.reverseTable(jobStack))
--  jobs.doJob()

-- log( ' - quicklist items'  )
-- empty dictionary
-- local qflist =  api.nvim_call_function('getqflist',{})
--   log( ' - type: '   ..  type(qflist) )
--   log( ' -  count: ' ..  tostring(util.isArray(qflist)))
-- -- for i, err in ipairs(qflist) do
-- --   log( ' -  ' ..  util.listKeys(err))
-- --   log( ' - type: '   ..  err['type'] )
-- --   log( ' - buffer: ' ..  err['bufnr'] )
-- --   log( ' - line: ' ..  err['lnum'] )
-- --   log( ' - column: ' ..  err['col'] )
-- --   log( ' - text: '   ..  err['text'] )
-- -- end
-- log( ' -----------------------------------------  ' )


 -- local qfHistory = api.nvim_command('chistory')
-- local qfHistory =  api.nvim_call_function('chistory',{})
--   log( type(qfHistory) )
-- local wins = api.nvim_list_wins()
-- local winFound
-- local buffer
-- local bufferName
-- for i, window in ipairs(wins) do
--   buffer = api.nvim_win_get_buf(window)
--   local bufferType = api.nvim_buf_get_option( buffer, 'buftype' )
--   bufferName = api.nvim_buf_get_name( buffer )
--   if bufferType == 'terminal' then
--     local nameFound = string.find( bufferName, sCmd )
--     if nameFound ~= nil then
--       winFound = window
--     end
--   end
-- end


