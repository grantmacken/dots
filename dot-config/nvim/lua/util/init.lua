local M = {}
M.version = '0.1.0'
--[[ markdown
This module provides utility functions for key mappings and other common tasks in Neovim.
It includes functions for
 - setting keymaps and buffer-specific keymaps with descriptions.
 - creating autocommand groups and autocommands.
 - splitting strings into words while being UTF-8 aware.
]] --

--autocommands
M.augroup = function(name) vim.api.nvim_create_augroup(name, {}) end
M.au = function(event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback, desc = desc })
end


--- UTF-8 aware word splitting. See |keyword|
---@see https://github.com/folke/sidekick.nvim/blob/main/lua/sidekick/util.lua
---@param str string
---@return string[] table list of words
M.split_words = function(str)
  if str == "" then
    return {}
  end

  local ret = {} ---@type string[]
  local word = {} ---@type string[]
  local starts = vim.str_utf_pos(str)

  local function flush()
    if #word > 0 then
      ret[#ret + 1] = table.concat(word)
      word = {}
    end
  end

  for idx, start in ipairs(starts) do
    local stop = (starts[idx + 1] or (#str + 1)) - 1
    local ch = str:sub(start, stop)
    if vim.fn.charclass(ch) == 2 then -- iskeyword
      word[#word + 1] = ch
    else
      flush()
      ret[#ret + 1] = ch
    end
  end

  flush()
  return ret
end

-- Pattern for the source file (e.g., in a 'src' directory)
M.get_current_file_name = function()
  return vim.fn.expand("%:t:r") -- :t gets filename, :r removes extension
end

-- copy relative file path from current working directory to clipboard
M.get_relative_file_path = function()
  local path = '@' .. vim.fn.expand("%:p:.")
  vim.fn.setreg('+', path) -- Copy to system clipboard
  return path
end

-- use uv to read a file
M.read_file = function(path)
  local uv = vim.uv
  local fd = uv.fs_open(path, "r", 438) -- 438 = 0666 in octal
  if not fd then
    return nil, "Could not open file: " .. path
  end
  local stat = uv.fs_fstat(fd)
  if not stat then
    uv.fs_close(fd)
    return nil, "Could not stat file: " .. path
  end
  local data = uv.fs_read(fd, stat.size, 0)
  uv.fs_close(fd)
  if not data then
    return nil, "Could not read file: " .. path
  end
  return data
end

--use uv to write a file
M.write_file = function(path, data)
  local uv = vim.uv
  local fd = uv.fs_open(path, "w", 438) -- 438 = 0666 in octal
  if not fd then
    return false, "Could not open file: " .. path
  end
  local ok, err = uv.fs_write(fd, data, 0)
  uv.fs_close(fd)
  if not ok then
    return false, "Could not write file: " .. path .. " Error: " .. err
  end
  return true
end

--- Check if an optional plugin has been loaded with packadd
---@param module_name string The name of the plugin module
---@return boolean true if plugin is loaded, false otherwise
M.is_plugin_loaded = function(module_name)
  return package.loaded[module_name] ~= nil
end

M.redirect_vim_command_output = function(vim_command, output_file, append)
  -- Determine the redirection mode (overwrite or append)
  local redir_mode = append and ">>" or ">"

  -- Construct the full command sequence
  local command_sequence = string.format(
    "redir %s %s | silent %s | redir END",
    redir_mode,
    output_file,
    vim_command
  )

  -- Execute the sequence
  vim.cmd(command_sequence)

  -- Optional: Notify the user
  vim.notify(
    string.format("Output of ':%s' written to '%s'", vim_command, output_file),
    vim.log.levels.INFO,
    { title = "Neovim Redirect" }
  )
end



return M
