M = {}

-- before plugin enabled
local setup = function()
  vim.opt.background = 'dark'
  vim.g.seoul256_contrast = true
  vim.g.seoul256_borders = true
  vim.g.seoul256_disable_background = false
end

-- after plugin enabled
local config = function()
  require('seoul256').set()
end

M.config = config
M.setup = setup

return M


