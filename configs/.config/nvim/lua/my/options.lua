local M = {}
M.version = 'v0.0.1'

local tLSPBufferOptions = {
  --omnifunc = vim.lsp.omnifunc,
  shiftwidth = 2,
}

local setGlobalOptions = function( tbl )
  for key,value in pairs( tbl ) do
    -- print( key .. ': ' .. tostring(vim.o[key]) )
    vim.o[key] = value
  end
end

local setBufferOptions = function( tbl )
  for key,value in pairs( tbl ) do
    -- print( key .. ': ' .. tostring(vim.o[key]) )
    vim.bo[key] = value
  end
end

local setWindowOptions = function( tbl ) 
  for key,value in pairs( tbl ) do
    --print( key .. ': ' .. tostring(vim.o[key]) )
    vim.wo[key] = value
  end
end

M.setGlobalOptions = setGlobalOptions
M.setBufferOptions = setBufferOptions
M.setWindowOptions = setWindowOptions
-- return M.setWindowOptions( tWindows )
return M
