M = {}

-- before plugin enabled
-- local setup = function() end

-- after plugin enabled
local config = function()
 require('spellsitter').setup({
  hl = 'SpellBad',
  captures = {'comment'},  -- set to {} to spellcheck everything
  })
end

--M.setup = setup
M.config = config

return M



