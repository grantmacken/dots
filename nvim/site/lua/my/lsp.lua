M = {}

local api = vim.api
local nvim_lsp    = require('nvim_lsp')
local diagnostic  = require('diagnostic')
local completion  = require('completion')

local attach = function()
  diagnostic.on_attach()
  completion.on_attach()
end

M.init = function()
  local tLangServers = {
    'bashls',
    'vimls',
    'sumneko_lua'
  }
  for i, sLangServer in ipairs(tLangServers) do
    nvim_lsp[sLangServer].setup{ attach }
  end

  local tFileTypes = {
    'lua',
    'vim',
    'sh'
  }
  api.nvim_command('augroup lsp')
  api.nvim_command('autocmd!')
  for i, sFileType in ipairs(tFileTypes) do
    local cmd = 'autocmd FileType ' .. sFileType  .. ' setl omnifunc=v:lua.vim.lsp.omnifunc'
    api.nvim_command(cmd)
  end
  api.nvim_command('augroup END')
  return true
end


return M
