--[[ markdown block
 --]]

--[[ start section:
  fzf project selector
  - lists directories in ~/Projects
  - if selected project is already open in a tab, switch to that tab
  - if not, open a new tab and set the working directory to the selected project
--]]
--
-- Project selector using fzf
-- TODO move to project module
local function select_project()
  local projects_dir = vim.fn.expand('~/Projects')
  -- Get list of folders using vim.uv
  local function get_project_folders()
    local handle = vim.uv.fs_scandir(projects_dir)
    local folders = {}
    if handle then
      repeat
        local name, type = vim.uv.fs_scandir_next(handle)
        if name and type == 'directory' then
          table.insert(folders, name)
        end
      until not name
    end

    return folders
  end

  local projects = get_project_folders()
  if #projects == 0 then
    vim.notify('No projects found in ~/Projects', vim.log.levels.WARN)
    return
  end

  -- Generic fzf picker
  vim.fn['fzf#run']({
    source = projects,
    sink = function(selected_project)
      if not selected_project then return end

      local project_path = projects_dir .. '/' .. selected_project

      -- Check if a tab with this project already exists
      local existing_tab = nil
      for i = 1, vim.fn.tabpagenr('$') do
        local tab_cwd = vim.fn.getcwd(-1, i)
        if tab_cwd == project_path then
          existing_tab = i
          break
        end
      end
      if existing_tab then
        -- Switch to existing tab
        vim.cmd('tabn ' .. existing_tab)
        vim.notify('Switched to existing project tab: ' .. selected_project, vim.log.levels.INFO)
      else
        -- Create new tab and set working directory
        vim.cmd('tabnew')
        vim.cmd('tcd ' .. project_path)
        vim.cmd.edit(project_path)
        vim.notify('Opened new project tab: ' .. selected_project, vim.log.levels.INFO)
      end
    end,
    options = {
      '--prompt=Projects> ',
      '--height=40%',
      '--layout=reverse',
      '--border',
      '--preview-window=hidden'
    }
  })
end

vim.api.nvim_create_user_command(
  'ProjectSelect',
  select_project,
  { desc = 'Select and open a project from ~/Projects directory' }
)

local keymap = require('util').keymap
keymap('<leader>ps', select_project, '[s]elect project tab')

--[[ end section: fzf project selector ]] --
--


--[[ start section: per tab project setup
  set tab project variables
  - vim.t.proj - the project name
  - vim.t.root - the root directory of the project
--]]
---- create Command to setup project terminal in current tabpage
-- vim.api.nvim_create_user_command("ProjectTermSetup", function()
--   require("project_term").setup_tabpage_term()
-- end, {
--   desc = "Set up project terminal for current tabpage",
--

-- Create the autocommands
-- vim.api.nvim_create_autocmd({ "TabEnter", "TabNew" }, {
--   group = vim.api.nvim_create_augroup("TabPageProjectSetup", { clear = true }),
--   callback = require('project_term').setup,
--   desc = "Apply settings when entering a tabpage",
-- })
--
-- end section: per tab project setup ]] --
local function run_on_startup()
  -- Check if Neovim started without any arguments
  -- and is currently on a "no-name" buffer (where the splash screen usually is).
  if vim.api.nvim_buf_get_name(0) == "" then
    -- Put your custom logic here
    --print("Running custom startup function!")
    -- Example: open a file explorer like nvim-tree
    --vim.cmd("NvimTreeOpen")
    -- Example: open a scratch buffer with a welcome message
    -- vim.cmd("enew | setlocal buftype=nofile | normal! iWelcome to Neovim!")
  end
end

-- Create an autocommand to run the function on editor start
vim.api.nvim_create_autocmd("VimEnter", {
  callback = select_project,
  once = true, -- Only run this once when Neovim starts
})
