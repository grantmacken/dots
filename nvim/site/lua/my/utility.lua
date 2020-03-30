M = {}
local inspect  = vim.inspect


M.printr = function()
  return  
  function( msg )
    return print( 'ERR:' .. msg  )
  end,
  function( obj )
    return ' got [ ' .. inspect( obj ) .. ' ]'
  end,
  function( obj )
    return ' expected [ ' .. inspect( obj ) .. ' ]'
  end
end







return M 
