M = {}


local workspace = {}
local log = require('my.log')
local api = vim.api
local tFileTypes  =
{
  ['lua'] = true
}


local init = function()
  local sFileType = vim.bo.ft
  if  ( type(sFileType) ~= 'string' ) then return end
  if not tFileTypes[  sFileType ] then return end
  local nBuf = api.nvim_get_current_buf()
  local pRoot = require('toolbox.workspace').root()
  log.info(pRoot)
  if ( type(workspace[pRoot]) ~= 'table') then
    workspace[pRoot] = {
      [sFileType] = { lsp_client = 0}
    }  
  end
  if not workspace[pRoot][sFileType].lspClient then
    log.info("Start lsp client for buffer")
  end
  log.info(workspace)

end



M.init = init

return M.init()
