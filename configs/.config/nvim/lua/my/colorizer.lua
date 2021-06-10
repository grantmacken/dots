M = {}

-- before plugin enabled
-- local setup = function() end

-- after plugin enabled
local config = function()
  require'colorizer'.setup({})
end

M.config = config
-- M.setup = setup

return M



