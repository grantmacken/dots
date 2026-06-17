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
M.commands = {
  "ProjectSetRootAndName",
  "ProjectGetRootAndName",
  "ProjectSetWindowLayout",
  "ProjectPicker",
}

M.keymaps = {
  { 'n', '<leader>pp', ':ProjectPicker<CR>', 'Open project picker' },
}

M.autocmds = {
  {
    event = 'TabNew',
    pattern = '*',
    group = 'projects',
    callback = function() M.setRootAndName() end,
    desc = 'Set project root and name when a new tab is opened',
  },
}

M.setup = function()
  for _, cmd in ipairs(M.commands) do
    -- cmd is a string with the format "ProjectCommandName"
    -- the function to call is the substring after "Project", with the first letter lowercased
    -- e.g. "ProjectSetRootAndName" -> "setRootAndName"
    local func        = cmd:sub(8, 8):lower() .. cmd:sub(9)
    -- the function to call is M[cmd:sub(8, 8):lower() .. cmd:sub(9)]
    -- the description for the command is the cmd  split into words, e.g. "ProjectSetRootAndName" -> "Project Set Root And Name"
    -- the spliting function call is cmd:gsub("%u", " %0"):gsub("^%s+", "")
    local description = cmd:gsub("%u", " %0"):gsub("^%s+", "")
    vim.api.nvim_create_user_command(cmd, M[func], { desc = description })
  end
  for _, keymap in ipairs(M.keymaps) do
    -- keymap is a table with the format { mode, lhs, rhs, desc }
    vim.keymap.set(keymap[1], keymap[2], keymap[3], { desc = keymap[4] })
  end
  for _, autocmd in ipairs(M.autocmds) do
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = autocmd.group,
      pattern = autocmd.pattern,
      callback = autocmd.callback,
      desc = autocmd.desc,
    })
  end
  -- setup project specific autocommands, keymaps, and plugins here
  -- this function is called when the project root and name are set
  vim.notify("Project setup complete for project: " .. vim.t.project_name, vim.log.levels.INFO)
end

-- get project root and set project name from the root directory name
M.setRootAndName = function()
  local t = vim.t
  local root = vim.fs.root(0, { ".git", "Makefile" })
  -- set tcd to the project root directory
  -- this changes the working directory for the current tabpage, but not for other tabpages
  vim.cmd('tcd ' .. root)
  if vim.t['project_name'] then return end -- if project is already set, do not override it
  if root then
    t['working_dir'] = root
    t['project_name'] = vim.fs.basename(root)
  else
    vim.notify("No project root found. Please run this command from within a git controlled project.",
      vim.log.levels.WARN)
  end
end

M.getRootAndName = function()
  local root = vim.t.working_dir
  local name = vim.t.project_name
  if root and name then
    return root, name
  else
    vim.notify(
      "Project root and name not set. Please run :SetProjectRootAndName command from within a git controlled project.",
      vim.log.levels.WARN)
    return nil, nil
  end
end

M.setWindowLayout = function()
  vim.echo("Setting up window layout for project: " .. vim.t.project_name)
  --[[
 layout consists of three windows:
  - code window: for editing project files
  - alt window: for editing alternative files (tests, docs, etc.)
  - show window: for running project related commands and displaying output
 ------------------------------------------------
                    |
  code window       |  alt window
                    |
  -----------------------------------------------
              show window
 ------------------------------------------------

 --]]

  local tabID = vim.api.nvim_get_current_tabpage()
  -- close all existing windows (In the tab ? ) except the first one
  vim.cmd('only')
  -- open first arg in the arglist in the first window
  local first_arg = vim.fn.argv(0) or vim.fn.expand('%:p') or ''
  if first_arg ~= '' then
    vim.cmd('edit ' .. first_arg)
  end
end

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
  vim.ui.select(
    projects,
    { prompt = 'Select a project to open:' },
    function(selected_project)
      if not selected_project then return end
      local project_path = projects_dir .. '/' .. selected_project
      --TODO: open the selected project in a new tabpage if it is not already open, otherwise switch to the existing tabpage
      -- TODO: if the project is already open in a tabpage, switch to that tabpage instead of opening a new one
      -- check if the selected project is already open in a tabpage
      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        local tab_project = vim.t[tab].project
        if tab_project == selected_project then
          vim.api.nvim_set_current_tabpage(tab)
          return
        end
      end
      -- check if tabpage variable vim.t.project exists
      -- local project = vim.t.project
      -- if not project then
      --   -- if not, set it to the selected project and open it in the current tabpage
      --   vim.t.project = selected_project
      --   -- create new tabpage
      --   vim.cmd('tabnew')
        -- this triggers autocommand defined in
        -- @see dot-config/nvim/lua/projects/init.lua
      end
    end
  )
end

return M
