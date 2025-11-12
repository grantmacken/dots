local M = {}
M.version = "0.1.0"
M.description = "Find alternate test/source files based on glob patterns"
--- Check if the given path is a source file
--- @return boolean True if source file, false otherwise
local has_match = function(pattern, path)
  -- grammar An LPEG representation of the pattern
  local grammar = vim.glob.to_lpeg(pattern)
  if grammar:match(path) then
    -- vim.notify("OK! Path matches source pattern: " .. source_pattern, vim.log.levels.INFO)
    return true
  else
    --vim.notify("Path does not match source pattern: " .. source_pattern, vim.log.levels.INFO)
    return false
  end
end

local glob = function(pattern)
  local result = {}
  for _, path in ipairs(vim.fn.glob(pattern, true, true)) do
    table.insert(result, path)
  end
  return result
end

--- Get alternate file path based on alt_type
--- @param alt_type string Type of alternate file
--- @param path string Current file path
--- @return boolean, string  Alternate file path or error message
M.get_alt = function(path, alt_type)
  local pair = vim.t.alt_pairs[alt_type]
  if not pair then
    vim.notify("No alternate pair defined for type: " .. alt_type, vim.log.levels.WARN)
    return false, "No alternate pair defined for type: "
  end
  local source_pattern = pair[1]
  local alt_pattern = pair[2]
  local alternatives = glob(alt_pattern)
  local alt_found = nil
  for _, file in ipairs(alternatives) do
    -- the glob returns absolute paths, so we need to strip the cwd
    local cwd = vim.fn.getcwd()
    local alt_file = file:gsub(cwd .. "/", "")
    -- vim.notify(alt_file, vim.log.levels.WARN)
    if has_match(source_pattern, path) then
      alt_found = alt_file
      break
    end
  end
  if alt_found ~= nil then
    return true, alt_found
  else
    --vim.notify("No alternate file found for type: " .. alt_type, vim.log.levels.WARN)
    return false, "No alternate file found for type"
  end
end

local source = vim.api.nvim_buf_get_name(0)
local path = "dot-config/nvim/lua/show/init.lua"
--local source_pattern = vim.t.alt_pairs.tests[1]
--local test_pattern = vim.t.alt_pairs.tests[2]

local ok, res = M.get_alt(path, "tests")
if ok then
  vim.notify("Alternate file found: " .. res, vim.log.levels.INFO)
else
  vim.notify("Error finding alternate file: " .. res, vim.log.levels.ERROR)
end

--vim.notify(vim.inspect(M.has_match(pattern, path)), vim.log.levels.INFO)
--vim.notify(vim.inspect(M.glob(pattern)), vim.log.levels.INFO)
--
-- return M
