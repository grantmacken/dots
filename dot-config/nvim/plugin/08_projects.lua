--[[ markdown block
 - each tab is a separate 'git' version controlled project
 - a tab project TCD is set
 - a tab will have tab scoped vars  `:help vim.t`
  - vim.t.proj - the project name
  - vim.t.root - the root directory of the project
  - vim.t.term - the terminal buffer for the tab

these are set when a tab is created or when entering a buffer

 - [ ] autocmd to set the tab vars when entering a buffer or creating a new tab
 - [ ] command to create a new tab project `:TabNewProj <path>` -:w


 - [ ] toggle terminal - one and only one terminal per tab. i.e. a terminal id handle from the tab
 - [ ] open and close terminal for tab. This should hide/open an existing terminal session
 - [ ] terminal always opens in bottom right split window occupying the full window width.
 - [ ] terminal should open in the project root directory
 --]]
--
--
--
--
--[[ start section:
  fzf project selector
  - lists directories in ~/Projects
  - if selected project is already open in a tab, switch to that tab
  - if not, open a new tab and set the working directory to the selected project
--]]
--
-- Project selector using fzf
---
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

--[[ start section:
  set tab project variables
  - vim.t.proj - the project name
  - vim.t.root - the root directory of the project
--]]

---@return nil
local function set_tab_project_vars()
  local buf = vim.api.nvim_get_current_buf()
  local tab = vim.api.nvim_get_current_tabpage()
  local bufname = vim.api.nvim_buf_get_name(buf)
  local start_dir = vim.fn.fnamemodify(bufname, ':h')
  local git_root = vim.fs.root(start_dir, '.git')
  if git_root then
    vim.t.root = git_root
    vim.t.proj = vim.fs.basename(vim.t.root)
  else
    vim.t.proj = nil
    vim.t.root = nil
  end
end

local group = vim.api.nvim_create_augroup('my_project_tab', {})
local au = function(event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback, desc = desc })
end

au({ 'BufEnter', 'TabNew' }, '*', function()
  set_tab_project_vars()
end, 'Set tab project variables')

--[[ end section: set tab project variables ]]--

-- vim.api.nvim_create_autocmd({ 'BufEnter', 'TabNew' }, {
--   callback = function()
--     set_tab_project_vars()
--   end,
-- })

vim.api.nvim_create_user_command('TermOpen', require('term').open, {
  desc = 'open terminal window'
})


vim.api.nvim_create_user_command('TermClose', require('term').close, {
  desc = 'close terminal window'
})

vim.api.nvim_create_user_command(
  'Make',
  function()
    require('term').open()
    local chan = vim.t.term_chan
    if chan then
      --vim.api.nvim_chan_send(chan, "clear\r\n")
      vim.api.nvim_chan_send(chan, "clear && make\n")
    else
      vim.notify("No terminal channel found", vim.log.levels.WARN, { title = 'Make Command' })
    end
  end
  , {
    desc = 'open terminal window and run make'
  })

vim.api.nvim_create_user_command('TabSet', set_tab_project_vars, {
  desc = 'set_tab_project_vars'
})



local keymap = require('util').keymap
keymap('<leader>to', require('term').open, 'open [t]erminal window')
keymap('<leader>tc', require('term').close, 'close [t]erminal window')
keymap('<leader>tm', ':Make<CR>', '[t]erminal run [m]ake')

--
