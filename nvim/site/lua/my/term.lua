local _M = {}

local log = require('my.log').log
local util = require('my.util')
local getProjectionValue = require('my.project').getProjectionValue
local api = vim.api

function _M.onOpen()
  -- log(' - on term open')
  -- log('   ------------')
  local title = api.nvim_buf_get_var(0, 'term_title')
  -- local jobID = api.nvim_buf_get_var(0, 'terminal_job_id')
  -- local jobPID = api.nvim_buf_get_var(0, 'terminal_job_pid')
   -- log(' - title: '  ..  title )
   -- log(' - jobID: '  ..  jobID )
   -- log(' - jobPID: ' ..  jobPID )
  api.nvim_win_set_option(0, 'number', false)
  api.nvim_win_set_option(0, 'relativenumber', false)
  api.nvim_win_set_option(0, 'spell', false)
  api.nvim_win_set_option(0, 'cursorline', false)
  -- api.nvim_buf_set_option(0, 'modifiable', true)
  api.nvim_buf_set_option(0, 'scrollback', 100000 )
  api.nvim_buf_set_option(0, 'modified', false )
  -- allow closing buffer without warning
  api.nvim_buf_set_option(0, 'bufhidden','wipe')
  -- api.nvim_buf_set_option(0, 'bufhidden','hide')
  -- if not in window wipeout
  api.nvim_win_set_option(0, 'statusline', title )
  -- scrollback
  -- buffhiden
  -- api.nvim_win_set_option(-0, 'hidden', false)
  -- if not util.isGlobalVar( 'my_jobs' ) then
  --   return
  -- end
  -- local jobWaitOpts = {}
  -- jobWaitOpts[1] = {jobID}
  -- local wait = api.nvim_call_function('jobwait', jobWaitOpts )
  -- log('wait: ' .. tostring( type(wait) ))
  -- log('wait: ' .. tostring( util.isArray(wait) ))
  -- log('wait: ' .. tostring( wait[1] ))
  -- api.nvim_command('caddbuffer ')
 -- parse_quickfix_erro
 -- local oMyJobs = api.nvim_get_var( 'my_jobs' )
 -- local iMyJobsCount = util.isArray( oMyJobs )
 -- log(  ' - session job count: ' .. tostring( iMyJobsCount ))
 -- if  iMyJobsCount > 0 then
 --   local oThisJob = oMyJobs[iMyJobsCount]
 --   log( ' - compiler: '   ..  oThisJob['compiler'] )
 --   local ilineCount = api.nvim_buf_line_count(0)
 --   log( ' - lineCount: '   ..  tostring(ilineCount) )
 --   local lines = api.nvim_buf_get_lines(0,1,ilineCount,1)
 --   for i, line in ipairs(lines) do
 --     log( line )
 --   end
 -- end
 -- log('--------------------------------')
end

function _M.onResponse(...)
  -- log(' - on term response')
  -- local title = api.nvim_buf_get_var(0, 'term_title')
  -- local jobID = api.nvim_buf_get_var(0, 'terminal_job_id')
  -- local jobPID = api.nvim_buf_get_var(0, 'terminal_job_pid')
  -- log(' - title: ' .. title)
  -- log(' - jobID: ' .. jobID)
  -- log(' - jobPID: ' .. jobPID)
end

function _M.onClose()
 -- log(' - on term open')
end



function _M.jobOut(jobID, data, event)
  log(' - job std out')
  log(' - job id: ' .. tostring( jobID ) )
  log(' - job data: ' .. type( data ) )
  log(' - job event: ' .. tostring( event ) )
  if util.isArray( data ) > 0 then
    for i, datum in ipairs(data) do
      log(' - datum: ' .. datum  )
      -- api.nvim_command('caddexpr "' .. datum .. '"')
    end
  end
end

function _M.jobErr(jobID, data, event)
  log(' - job std err')
  log(' - job id: ' .. tostring( jobID ) )
  log(' - job data: ' .. type( data ) )
  log(' - job event: ' .. tostring( event ) )
end

function _M.jobExit( jobID, status, event, oMyJob )
  -- log(' - job exit: ' ..  oMyJobs[ util.isArray( oMyJobs )] )
  log(' - job id: ' .. tostring( jobID ) )
  log(' - job status: ' .. tostring( status ) )
  log(' - job event: ' .. tostring( event ) )
end

function _M.job( projection )
  log(' - ' .. projection  .. '" term job')
  log('  -----------------------------------')
  local sBufJob = getProjectionValue( projection )
  if type(sBufJob) ~= 'string' then
    log( ' - no job for curent buffer' )
    return
  end
  local window = api.nvim_get_current_win()
  local buffer = api.nvim_win_get_buf(window)
  local bufferName =  api.nvim_buf_get_name( buffer )
  local sTitle =  projection .. ' job for buffer [' .. buffer .. '] ' .. bufferName
  local oThisJob = {}
  oThisJob['buffer'] = buffer
  oThisJob['window'] = window
  oThisJob['cmd'] = sBufJob
  log( ' - job: ' .. oThisJob['cmd'])
  api.nvim_command('botright 10new')
  api.nvim_call_function('my#term#job',{oThisJob})
end

return _M
