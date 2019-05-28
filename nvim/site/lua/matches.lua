 local _M = {}

--[[
ref h:complete-items
  local windowHandle  =   api.nvim_get_current_win()
  local window        =   api.nvim_win_get_number(windowHandle)
  local row, col = unpack(api.nvim_win_get_cursor(0))
  local line =            api.nvim_get_current_line()
  local buffer =          api.nvim_get_current_buf()
  local bufferLineCount = api.nvim_buf_line_count(buffer)
  local bufferLines =     api.nvim_buf_get_lines(buffer,0,bufferLineCount,0)
  local changedTick =     api.nvim_buf_get_changedtick(buffer)
  local fileName    =     api.nvim_buf_get_name(buffer)
---]]

local data = require('tokens').words

local function nvim(method, ...)
  return request('nvim_'..method, ...)
end

function _M.echom(message)
  vim.api.nvim_command('echom "' .. tostring(message) .. '"')
end

function getTokenPart()
  local api = vim.api
  local row, col = unpack(api.nvim_win_get_cursor(0))
  local line = api.nvim_get_current_line()
  local strToCol = string.sub(line,1,col)
  local targetPart = string.match(strToCol, '(%a+)$')
  return col, targetPart
end

function _M.getStartCol()
  local col, tokenPart = getTokenPart()
  -- print( tokenPart )
  if tokenPart ~= nil then
    local tokenPartLength = string.len(tokenPart)
    return (col - tokenPartLength) + 1
  else
    return tokenPart
  end
end

function _M.getMatches()
  local tokens = {}
  local col, tokenPart = getTokenPart()
  for i,token in ipairs(data) do
    if string.match(token, tokenPart ) ~= nil  then
      local item = { word = token ,dup = 1,icase = 1, menu = '[xQ] word token', kind = 'T'}
    -- " map(s:uriliterals,"{'word':v:val,'dup':1,'icase':1,'menu': '[xQ] uriliterals', 'kind' : 'L'}" )
      table.insert(tokens,  item )
    end
  end
  return tokens
end

 return _M
