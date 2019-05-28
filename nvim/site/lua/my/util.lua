local _M = {}

local log = require('my.log').log
local api = vim.api

function _M.echom(message)
  api.nvim_command('echom "' .. tostring(message) .. '"')
end

-- TODO if not in use remove

function _M.contains( T, val )
  for index, value in ipairs (T) do
    if value == val then
      return true
    end
  end
  return false
end

-- isArray
-- Determine with a Lua table can be treated as an array.
-- Explicitly returns "not an array" for very sparse arrays.
-- Returns:
-- -1   Not an array
-- 0    Empty table
-- >0   Highest index in the array
function _M.isArray(T)
    local max = 0
    local count = 0
    for k, v in pairs(T) do
        if type(k) == "number" then
            if k > max then max = k end
            count = count + 1
        else
            return -1
        end
    end
    if max > count * 2 then
        return -1
    end
    return max
end

-- listKeys
-- Returns: string
--  as a bar separated list of keys
function _M.listKeys( T )
  local t = {}
  for k, v in pairs(T) do
    table.insert(t, tostring(k))
  end
  return table.concat(t," | ")
end

function _M.isGlobalVar( v )
  local value, err = pcall(api.nvim_get_var, v )
   if not value then
     log(' [ERR] ' .. err )
     return false
    else
     return true
   end
end

function _M.reverseTable( T )
    local reversedTable = {}
    local itemCount = #T
    for k, v in ipairs( T ) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

return _M
