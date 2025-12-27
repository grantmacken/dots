local M = {}
M.version = "0.1.0"
M.description = [[
 A nvim lua module to manage my git controlled projects
 - Each project has its own named tabage
 - The named tabpage is the project name
 - The name is derived from the project root directory
 - The project root directory is determined by the presence of a `.git` directory
 - Projects are stored in `~/Projects` directory
 - The plugin provides a FZF based project picker to select and open projects in new tabpages
]]

--- @see url https://github.com/echasnovski/mini.pick

---@return string, table project directory and list of names
local function get_project_directories()
  local projects_dir = vim.g.projects_dir or (vim.fn.expand('~') .. '/Projects')
  local handle = vim.uv.fs_scandir(projects_dir)
  local dirs = {}
  if handle then
    repeat
      local name, type = vim.uv.fs_scandir_next(handle)
      if name and type == 'directory' then
        table.insert(dirs, name)
      end
    until not name
  end
  return projects_dir, dirs
end

M.picker = function()
  -- if vim.api.nvim_buf_get_name(0) ~= "" then return end -- only run on empty buffer
  -- check if Projects directory exists
  local projects_dir, projects = get_project_directories()
  -- if #projects == 0 then
  --   vim.notify('No projects found in ~/Projects', vim.log.levels.WARN)
  --   return
  -- end
  local MiniPick = require("mini.pick")
  MiniPick.start({
    source = {
      items = projects,
      name = "Projects",
      choose = function(selected_project)
        if not selected_project then return end
        local project_path = projects_dir .. '/' .. selected_project
        -- check if tabpage variable vim.t.project exists
        local project = vim.t.project
        if not project then
          -- create new tabpage
          vim.cmd('tabnew')
          -- this triggers autocommand defined in
          -- @see dot-config/nvim/lua/projects/init.lua
          vim.cmd('tcd ' .. project_path)
        end
      end,
    },
    options = {
      content_from_bottom = false,
      use_cache = false,
    },
    window = {
      config = function()
        local height = vim.o.lines
        local width = vim.o.columns
        return {
          anchor = 'NW',
          height = height,
          width = width,
          row = 0,
          col = 0,
          border = 'none',
        }
      end,
    },
  })
  -- Set initial query to 'dots' after picker starts
  vim.schedule(function()
    vim.fn.feedkeys('dots', 'n')
  end)
end

return M
