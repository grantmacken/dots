M = {}

-- before plugin enabled
local setup = function()
  vim.g.dashboard_default_executive = 'telescope'
  vim.g.dashboard_custom_section = {
    a = {description = {'  Find File          '}, command = 'Telescope find_files'},
    b = {description = {'  Recently Used Files'}, command = 'Telescope oldfiles'},
    c = {description = {'  Load Last Session  '}, command = 'SessionLoad'},
    d = {description = {'  Find Word          '}, command = 'Telescope live_grep'},
    -- e = {description = {'  Marks              '}, command = 'Telescope marks'}
  }
  -- vim.g.dashboard_session_directory = CACHE_PATH .. '/session'
end

-- after plugin enabled
-- local config = function() end

--M.config = config
M.setup = setup

return M



