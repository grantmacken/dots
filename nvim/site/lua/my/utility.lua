M = {}
local vim = vim
local inspect  = vim.inspect
local api  = vim.api


M.printr = function()
  return
  function( msg )
    return print( 'ERR:' .. msg  )
  end,
  function( obj )
    return ' got [ ' .. inspect( obj ) .. ' ]'
  end,
  function( obj )
    return ' expected [ ' .. inspect( obj ) .. ' ]'
  end
end

M.nvim_loaded_buffers = function()
  local result = {}
  local buffers = api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if api.nvim_buf_is_loaded(buf) then
      table.insert(result, buf)
    end
  end
  return result
end

-- Kill the target buffer (or the current one if 0/nil)
M.buf_kill = function(target_buf, should_force)
  if not should_force and vim.bo.modified then
    return api.nvim_err_writeln('Buffer is modified. Force required.')
  end
  local command = 'bd'
  if should_force then command = command..'!' end
  if target_buf == 0 or target_buf == nil then
    target_buf = api.nvim_get_current_buf()
  end
  local buffers = M.nvim_loaded_buffers()
  if #buffers == 1 then
    api.nvim_command(command)
    return
  end
  local nextbuf
  for i, buf in ipairs(buffers) do
    if buf == target_buf then
      nextbuf = buffers[(i - 1 + 1) % #buffers + 1]
      break
    end
  end
  api.nvim_set_current_buf(nextbuf)
  api.nvim_command(table.concat({command, target_buf}, ' '))
end
M.buf_kill()

return M
