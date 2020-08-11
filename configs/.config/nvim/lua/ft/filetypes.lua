M = {}

local workspace = {}
local log = require('my.log').info
local api = vim.api
local tFileTypes  = {
  ['lua'] = true
}

local init = function()
  local info = ''
  local sFileType = vim.bo.ft
  if  ( type(sFileType) ~= 'string' ) then return end
  if not tFileTypes[  sFileType ] then return end
  local nBuf = api.nvim_get_current_buf()
  local pRoot = require('toolbox.workspace').root()
  -- log.info(pRoot)
  if ( type(workspace[pRoot]) ~= 'table') then
    workspace[pRoot] = {
      [sFileType] = { lsp_client = nil}
    }  
  end
   if not workspace[pRoot][sFileType].lsp_client then
   info = ' started '
   local sMod = 'ft.' .. sFileType
   local nClient = require(sMod).startLanguageServer(pRoot)
   if type(nClient) ~= 'number' then  log(' Failed to get LSP client' ) return end
   workspace[pRoot][sFileType].lsp_client = 
   vim.lsp.buf_attach_client(nBuf,nClient)
 end
   log( ' workspace: '  .. info .. workspace[pRoot][sFileType].lsp_client )
  ---if not  then
  --end
  -- log.info(workspace)
end

-- M.workspace = workspace
M.init = init

return M.init
