local _M = {}

-- h setqflist
-- h getqflist

local util = require('my.util')
local api = vim.api

-- GF: nvim/site/after/ftplugin/qf.vim
function _M.close()
  local bClose, err = pcall( api.nvim_command,'cclose' )
  if not bClose then
     util.echom( ' - err: ' .. err)
  end
end

function _M.rotateNext()
  local bNext = pcall( api.nvim_command,'cnext' )
  if not bNext then
    return pcall( api.nvim_command,'cfirst')
  end
end

function _M.rotatePrev()
  local bNext = pcall( api.nvim_command,'cprevious')
  if not bNext then
    return pcall( api.nvim_command,'clast')
  end
end

function _M.toggle()
  local qflist =  api.nvim_call_function('getqflist',{})
  if util.isArray(qflist) == 0 then
    util.echom('no errors for quickfix list')
    return
  end
  local buffers = api.nvim_list_bufs()
  local bufFound = false
  for i, buffer in ipairs(buffers) do
    local bufferType = api.nvim_buf_get_option( buffer, 'buftype' )
    if bufferType == 'quickfix' then
      bufFound = true
      break
    end
  end
  if not bufFound then
    api.nvim_command('botright copen 3')
    -- api.nvim_command('cbottom')
    -- api.nvim_command('botright cwindow 10')
  else
    api.nvim_command('cclose')
  end
end

-- function _M.isWindowOpen()

function _M.hasBuffer()
  -- log( '- is quickfix window open' )
  local buffers = api.nvim_list_bufs()
  local bBufFound = false
  for i, buffer in ipairs(buffers) do
    local bufferType = api.nvim_buf_get_option( buffer, 'buftype' )
    if bufferType == 'quickfix' then
      bBufFound = true
      break
    end
  end
  if not bBufFound then
    return false
  else
    return true
  end
end

function _M.properties()
  local qfDic = api.nvim_eval("getqflist({'nr': 0,'title': 1,'winid': 1})")
  local props = {}
  props['qfListNumber'] = qfDic['nr']
  props['qfWindowID'] = qfDic['winid']
  props['qfTitle'] = qfDic['title']
  local qflist =  api.nvim_call_function('getqflist',{})
  local itemCount = util.isArray(qflist)
  props['qfItemCount'] = itemCount
  local errorCount = 0
  local warnCount = 0
  local infoCount = 0
  for i, err in ipairs(qflist) do
    if  err['type'] == 'E' then
      errorCount = errorCount + 1
    end
    if  err['type'] == 'W' then
      warnCount = warnCount + 1
    end
    if  err['type'] == 'I' then
      infoCount = infoCount + 1
    end
  end
  props['qfErrorCount'] = errorCount
  props['qfWarningCount'] = warnCount
  props['qfInfoCount'] = infoCount
  return props
end

-- :h qf
--  on qf commands triggers
--  e.g. make

function _M.onCmdPre()
  -- log('before a quicklist command is run')
end

function _M.onCmdPost()
  -- log('after a quicklist command is run')
end

--  on qf buffer triggers

function _M.onFilled()
   -- log(' - the quickfix window has been filled')
end

function _M.onEntered()
 -- log(' - the quickfix window has been entered')
end

return _M
