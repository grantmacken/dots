M = {}

-- global functions
local tab_complete = function()
  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end
  local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
      return true
    else
      return false
    end
  end
  if vim.fn.pumvisible() == 1 then
    return t('<C-n>')
  elseif require('luasnip').expand_or_jumpable() then
    print('expand')
    return t('<Plug>luasnip-expand-or-jump')
  elseif check_back_space() then
    return t('<Tab>')
  else
    return vim.fn['compe#complete']()
  end
end

local s_tab_complete = function()
  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end
  if vim.fn.pumvisible() == 1 then
    return t('<C-p>')
  elseif require('luasnip').jumpable(-1) then
    return t('<Plug>luasnip-jump-prev')
  else
    return t('<S-Tab>')
  end
end

local set_vars = function( tbl )
  for key,value in pairs( tbl ) do
    vim.g[key] = value
  end
end

local set_options = function( tbl )
  for key,value in pairs( tbl ) do
    vim.opt[key] = value
  end
end

local set_global_options = function( tbl )
  for key,value in pairs( tbl ) do
    vim.opt_global[key]= value
  end
end

local set_local_options = function( tbl )
  for key,value in pairs( tbl ) do
    vim.opt_local[key] = value
  end
end

local create_augroups = function(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup '..group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

M.create_augroups = create_augroups
M.s_tab_complete = s_tab_complete
M.tab_complete = tab_complete
M.set_vars = set_vars
M.set_options = set_options
M.set_global_options = set_global_options
M.set_local_options = set_local_options
return M



