M = {}
M.version = "0.1.0"
--[[ Module description ]]
--- @see https://github.com/ibhagwan/fzf-lua/wiki/Advanced
--[[markdown
 # projects
 A Neovim plugin to manage my git controlled projects
 - Each project has its own named tabage
 - The named tabpage is the project name
 - The name is derived from the project root directory
 - The project root directory is determined by the presence of a `.git` directory
 ]] --


---@return string, table directories  list of project names
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
  local fzf_lua = require("fzf-lua")
  fzf_lua.fzf_exec(projects, {
    prompt = "Projects> ",
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local selected_project = selected[1]
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
    winopts = { --
      fullscreen = true,
      height = 1,
      width = 1,
      row = 0,
      col = 0,
      border = 'none',
      preview = {
        hidden = 'hidden',
      },
    },
    fzf_opts = {
      ['--layout'] = 'reverse',
      ['--query'] = 'dots',
    },
  })
end

M.data = {
  name = "projects",
  version = M.version,
  description = "A Neovim plugin to manage my tab b ased git controlled projects",
}
return M
