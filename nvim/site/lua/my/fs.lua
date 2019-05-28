local _M = {}

-- local uv  = require('luv')
-- https://github.com/luvit/luv/blob/eb87f736ce4398252e3573b153beb5e790b1f0e1/tests/test-fs.lua
-- http://docs.libuv.org/en/v1.x/fs.html

function _M.cwd()
 -- return assert(uv.fs_realpath('./'))
end

function _M.open( file )
  return io.open( file, 'r')
end

function _M.chunk( fd )
local chunk = fd:read("*all")
fd:close()
return chunk
end

function _M.writeFile( s, f )
  local fd  = io.open( f, 'w' )
  if not fd then
    return fd
  end
  fd:write( s )
  fd:close()
end

function _M.appendToFile( s, f )
  local fd  = io.open( f, 'a' )
  if not fd then
    return fd
  end
  fd:write( s )
  fd:close()
end

return _M
