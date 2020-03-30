local _M = {}
_M.version = 'v0.0.1'
local api = vim.api
local vim = vim
local uv = vim.loop
local myFs  = require('my.fs')
local path_sep = uv.os_uname().sysname == "Windows" and "\\" or "/"

_M.append = function( sID, sData )
  local pRoot = require('my.project').root_from_id( sID )
  local pLog = pRoot ..path_sep .. '.project.log'
  local fd
  if myFs.is_file(pLog) then
    fd = uv.fs_open(pLog, 'a', tonumber('644', 8))
  else
    fd = uv.fs_open(pLog, 'w', tonumber('644', 8))
  end
  local sLogLine =  '[' .. os.date("!%Y-%m-%dT%TZ") .. '] ' .. sData .. '\n'
  local offset = -1
  local chunk = uv.fs_write(fd,sLogLine,offset)
  local close = uv.fs_close(fd)
  return close
end
-- print(vim.inspect(_M.append('dots', 'xxxxx')))

-- print(vim.inspect( _M.log('xxxx') ))

_M.clean = function( pRoot ) 
  if type(pRoot) ~= 'string' then return end
  local pLog = pRoot ..path_sep .. '.project.log'
  local fd = uv.fs_open(pLog, 'w', tonumber('644', 8))
  local offset = -1
  local chunk = uv.fs_write(fd,'',offset)
  local close = uv.fs_close(fd)
  return close
end
-- print(vim.inspect(_M.clean('/home/gmack/projects/grantmacken/dots')))
-- vim._update_package_paths()

_M.show = function( sID )
  if type(sID) ~= 'string' then return end
  local pRoot  = _M.root_from_id(sID)
  local sChunk = _M.read(pRoot,'.project.log')
  local tLines = vim.split(sChunk,'\n')
  require('my.fwin').show(tLines)
end


local _M = {}
