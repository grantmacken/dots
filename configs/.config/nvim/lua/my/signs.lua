local M = {}

local set = function( tbl )
  for key, value in pairs( tbl ) do
    vim.fn.sign_define( key, value )
    -- print(vim.inspect(vim.fn.sign_getdefined( key)))
  end
end

-- print(vim.inspect(vim.api.nvim_get_hl_id_by_name('LspDiagnosticsErrorSign')))
--print(vim.inspect(vim.api.nvim_get_namespaces()))
--psign_getdefined([{name}])

M.set = set

return M
