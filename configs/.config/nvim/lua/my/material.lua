M = {}

-- before plugin enabled
local setup = function()
  -- Example config in lua
  vim.g.material_style = 'palenight'
  --vim.g.material_italic_comments = true
  --vim.g.material_italic_keywords = true
  --vim.g.material_italic_functions = true
  --vim.g.material_italic_variables = false
  vim.g.material_contrast = true
  vim.g.material_borders = true
  vim.g.material_disable_background = false
  --vim.g.material_custom_colors = { black = "#000000", bg = "#0F111A" }
end

-- after plugin enabled
local config = function()
  require('material').set()
  vim.api.nvim_set_keymap('n', '<C-m>', [[<Cmd>lua require('material.functions').toggle_style()<CR>]], { noremap = true, silent = true })
end

M.config = config
M.setup = setup

return M



