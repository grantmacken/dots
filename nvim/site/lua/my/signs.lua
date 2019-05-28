local _M = {}

local api = vim.api

local signTypes = {
['E'] = 'MyErrorSign',
['W'] = 'MyWarningSign',
['I'] = 'MyInfoSign'
}

_M.signTypes = signTypes

function _M.define()
--  log(' - define signs')
  local str

  str =   'highlight ALEWarningSign guibg=#4e4e4e'
  api.nvim_command( str )

  str =   'highlight ALEErrorSign guibg=#4e4e4e'
  api.nvim_command( str )

  str =   'highlight MyWarningSign guifg=#d7005f guibg=#4e4e4e'
  api.nvim_command( str )

  str =   'highlight MyWarningSign guifg=#d7875f guibg=#4e4e4e'
  api.nvim_command( str )

  str =   'sign define ' .. signTypes['E'] ..
  ' text=⛆' ..
  ' texthl=ALEErrorSign'
  api.nvim_command( str )
  str =   'sign define ' .. signTypes['W'] ..
  ' text=⛆' ..
  ' texthl=MyWarningSign'
  api.nvim_command( str )
  str =   'sign define ' .. signTypes['I'] ..
  ' text=⛆' ..
  ' texthl=MyWarningSign'
  api.nvim_command( str )
  str =   'sign define ' .. signTypes['I'] ..
  ' text=⛆' ..
  ' texthl=LineNr'
  api.nvim_command( str )
end


return _M
