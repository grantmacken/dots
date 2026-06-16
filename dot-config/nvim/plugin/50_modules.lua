--- @see dot-config/nvim/lua/projects/init.lua  the projects module
--[[ markdown
--]]
local misc = require('mini.misc')
misc.safely('later', function()
  require('repo').setup()
  require('arglist').setup()
end)
