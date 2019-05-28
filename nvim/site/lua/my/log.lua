local _M = {}

local fs = require('my.fs')
-- local util = require('my.util')

local log = {}
log.outfile = 'tmp/project.log'


function _M.log( str )
  local line =  '[' ..
  os.date("!%Y-%m-%dT%TZ") ..
  '] ' ..
  str ..
  '\n'

  fs.appendToFile( line ,log.outfile )
end

function _M.clear()
  local line = ''
  fs.writeFile( line ,log.outfile )
end

return _M
