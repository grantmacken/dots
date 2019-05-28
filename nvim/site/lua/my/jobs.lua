local _M = {}

local util = require('my.util')
local log = require('my.log').log
local getProjectionValue = require('my.project').getProjectionValue
-- project.getProjectionValue( projection )
local signTypes = require('my.signs').signTypes
--local md5 = require('resty.md5')
local api = vim.api

--[[
  -- TODO wait for patch
  -- https://groups.google.com/forum/#!topic/vim_use/LTWNG0nRQCc
  -- https://groups.google.com/forum/#!topic/vim_dev/Cd1sNBzc0NE
  -- https://neovim.io/doc/reports/vimpatch/
windows
 buffers

gobal array
myJobs = [] (array)

jobs buffer obtained via project.getProjectionValue( 'jobs' )

myJob[1] {}  object  oThisJob 1
myJob[2] {}  object  oThisJob 2


oThisJob['buffer'] = buffer
oThisJob['window'] = window
oThisJob['compiler'] =  via project.getProjectionValue( 'jobs' )
 - then set complier for buffer and extract
oThisJob['makeprg'] = makePrg
oThisJob['errorformat'] = errorFormat
--]]

local function clearSigns()
  -- log(' - clear signs')

  local function clearSign( err, i )
    -- log(' - clear sign')
    local iID = i
    local str =   'sign unplace ' .. tostring(iID) ..
    ' buffer=' .. err['bufnr']
    -- log(' - ' .. str )
    api.nvim_command( str )
  end

  local qflist = api.nvim_call_function('getqflist',{})
  local qflistCount = util.isArray( qflist )
  log(' - previous errors count: ' .. tostring(qflistCount) )
  if qflistCount > 0 then
    for i, err in ipairs(qflist) do
      clearSign( err, i )
    end
  end
end

local function placeSign( err, i )
  -- log(' - place sign')
  local iID = i
  local iLine= err['lnum']
  local sName = signTypes[err['type']]
  local sFile =  api.nvim_buf_get_name( err['bufnr'] )
  local str =   'sign place ' .. tostring(iID) ..
  ' line=' .. tostring(iLine) ..
  ' name=' .. sName ..
  ' file=' .. sFile
  -- log(' - ' .. str )
   api.nvim_command( str )
end

-- TODO
local function statusLine( err, i )
  log(' - statusline')
end

-- TODO
local function echoMessage( err, i )
  log(' - statusline')
end

local function doJob( oMyJobs )
  if util.isArray( oMyJobs ) > 0 then
    local oThisJob = oMyJobs[1]
    log( ' - do job' )
    -- log( ' - compiler: ' .. oThisJob['compiler'] )
    -- log( ' - buffer: ' .. oThisJob['buffer'] )
    -- log( ' - window: ' .. oThisJob['window'] )
    log( ' - - make program: ' ..  oThisJob['makeprg'] )
    log( ' - - error format: ' ..  oThisJob['errorformat'] )
    -- api.nvim_buf_set_option(oThisJob['buffer'] , 'makeprg', oThisJob['makeprg'])
    -- api.nvim_buf_set_option(oThisJob['buffer'] , 'errorformat', oThisJob['errorformat'])
    api.nvim_set_option('errorformat',oThisJob['errorformat'])
    api.nvim_call_function('my#jobs#job',{oMyJobs})
  end
end

local function jobsFinished()
  log( ' - compiler jobs finished' )
  -- local errorBufferStack = {}
  local qflist =  api.nvim_call_function('getqflist',{})
  for i, err in ipairs(qflist) do
    -- for each error 
    -- log(util.listKeys( err))
    -- log(err['lnum']) 
    if err['lnum'] > 0 then
      if  err['type'] == 'E' then
        placeSign(err, i)
      elseif err['type'] == 'W' then
        placeSign(err, i)
      elseif err['type'] == 'I' then
        placeSign(err, i)
      end
    end
  end
end

function _M.jobOut(jobID, data, event)
  -- log(' - job std out')
  -- log(' - job id: ' .. tostring( jobID ) )
  -- log(' - job data: ' .. type( data ) )
  -- log(' - job event: ' .. tostring( event ) )
  if util.isArray( data ) > 0 then
    for i, datum in ipairs(data) do
      -- log(' - datum: ' .. datum  )
      -- let filename = fnamemodify(line, ':p:.'
      api.nvim_command('silent! caddexpr "' .. datum .. '"')
    end
  end
end

function _M.jobErr(jobID, data, event)
  log(' - job std err')
   -- log(' - job id: ' .. tostring( jobID ) )
  -- log(' - job data: ' .. type( data ) )
  -- log(' - job event: ' .. tostring( event ) )
end

function _M.jobExit( jobID, status, event, oMyJobs )
   --log(' - job exit: ' ..  oMyJobs[ util.isArray( oMyJobs )] )
   -- log(' - job id: ' .. tostring( jobID ) )
   log(' - job status: ' .. tostring( status ) )
   -- log(' - job event: ' .. tostring( event ) )
   if status ~= 0 then
    log(' - job failed - returned exit status: ' .. tostring( status ) )
    jobsFinished()
   end

  table.remove(oMyJobs, 1)
  local iJobs = util.isArray( oMyJobs )
  if iJobs > 0 then
    log(' - remaining jobs count: ' .. tostring( iJobs ) )
    doJob( oMyJobs )
  else
    jobsFinished()
  end
end

function _M.qfJobs( projection )
  log(' - set "' .. projection  .. '" compiler jobs')
  log('  -----------------------------------')
  local oMyJobs = {}
  local oBufJobs = getProjectionValue( projection )
  if type(oBufJobs) ~= 'table' then
    log( ' - no jobs for curent buffer' )
    return
  end
  local iBufJobs = util.isArray( oBufJobs )
  if  not ( iBufJobs > 0 )  then
    log( ' - no jobs for curent buffer' )
    return
  end
  local window = api.nvim_get_current_win()
  local buffer = api.nvim_win_get_buf(window)
  local bufferName =  api.nvim_buf_get_name( buffer )
  local sTitle = 'compiler jobs for buffer [' .. buffer .. '] ' .. bufferName
  local qfTitle = { title =  sTitle }
  local what = {}
  what['all'] = true
  local qfDic = api.nvim_call_function('getqflist',{what})
  -- log( ' - quickfix-error-list title: ' ..  qfDic['title'])
  -- log( ' - quickfix-error-list title: ' ..  type(qfDic['title']))
  -- log( ' - we have quickfix buffer: ' .. tostring(qf.hasBuffer() ))
  if qfDic['title'] ~= '' then
    clearSigns()
  end
  -- create a new quickfix list
  api.nvim_call_function('setqflist',{{},' ',qfTitle})
  local makePrg, errorFormat
  log( ' - ' .. iBufJobs .. ' jobs for curent buffer' )
  for i, value in ipairs(oBufJobs) do
    local oThisJob = {}
    oThisJob['buffer'] = buffer
    oThisJob['window'] = window
    oThisJob['compiler'] = value
    log( ' - job: ' ..  tostring(i) .. ': ' ..  value )
    -- invoke compiler for buffer
    --  this will set makeprg and errorformat
    api.nvim_command('compiler ' .. value )
    --  |:cd| to the innermost root
    api.nvim_command('Pcd')
    makePrg = api.nvim_buf_get_option(0, 'makeprg')
    errorFormat = api.nvim_buf_get_option(0, 'errorformat')
    oThisJob['makeprg'] = makePrg
    oThisJob['errorformat'] = errorFormat
    -- log( ' - make Program: '   ..  makePrg )
    -- log( ' - errorFormat: ' ..  errorFormat )
    -- add to global
    -- oMyJobs key based on compiler
    oMyJobs[i] = oThisJob
  end
   -- print( ' ... backgound jobs start ')
   doJob( oMyJobs )
end


function _M.trmJobs( projection )
  log(' - set "' .. projection  .. '"terminal job')
  log('  -----------------------------------')
end

return _M
