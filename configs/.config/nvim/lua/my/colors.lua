M = {}

-- before plugin enabled
local setup = function()
  vim.g.seoul256_contrast = true
  vim.g.seoul256_borders = true
  vim.g.seoul256_disable_background = true
end

-- after plugin enabled
local config = function()
  require('seoul256').set()
end

M.config = config
M.setup = setup

return M



