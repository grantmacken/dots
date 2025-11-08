M = {}
M.version = "0.1.0"
--[[ Module description ]]
--[[markdown
 # projects
 A Neovim plugin to manage my git controlled projects
 - Each project has its own named tabage
 - The named tabpage is the project name
 - The name is derived from the project root directory
 - The project root directory is determined by the presence of a `.git` directory
 ]] --

---@param projects_dir string directory containing projects, defaults to ~/Projects
---@return table folders list of project folder names
local function get_project_folders(projects_dir)
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

local new_project = function()
  local project = vim.t.project
end

-- Project selector using fzf
--
M.select = function()
  if vim.api.nvim_buf_get_name(0) ~= "" then return end -- only run on empty buffer
  -- check if Projects directory exists
  local projects_dir = vim.g.projects_dir
  if projects_dir and vim.fn.isdirectory(projects_dir) == 0 then
    vim.notify('Projects directory does not exist', vim.log.levels.ERROR)
    return
  end
  local projects = get_project_folders(projects_dir)
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
      -- check if tabpage variable vim.t.project exists
      local project = vim.t.project
      if not project then
        vim.cmd('tabnew')
        vim.cmd('tcd ' .. project_path)
        -- vim.notify('Opened new project tab: ' .. selected_project, vim.log.levels.INFO)
        -- initial edit window
        local readme = project_path .. '/README.md'
        if vim.fn.filereadable(readme) == 1 then
          vim.cmd.edit(readme)
        else
          vim.cmd.edit(project_path)
        end
        vim.t.project = {}
        project = vim.t.project
        project['name'] = selected_project
        project['root'] = project_path
      end
    end,
    options = {
      '--prompt=Projects> ',
      '--height=40%',
      '--layout=reverse',
      '--border',
      '--preview-window=hidden',
      '--query=dots'
    }
  })
end


--[[ markdow
-
      -- Check if a tab with this project already exists
      -- local existing_tab = nil
      -- for i = 1, vim.fn.tabpagenr('$') do
      --   local tab_cwd = vim.fn.getcwd(-1, i)
      --   if tab_cwd == project_path then
      --     existing_tab = i
      --     break
      --   end
      -- end
      if existing_tab then
        vim.notify('Switch to existing tab')
        --         vim.cmd('tabn ' .. existing_tab)
        vim.cmd('tcd ' .. project_path)
        -- check if tabpage variable vim.t.project exists
        local project = vim.t.project
        if not project then
          vim.t.project = {}
          project = vim.t.project
          project['name'] = selected_project
          project['root'] = project_path
          if vim.fn.filereadable(project_path ) == 1 then
            vim.notify('Sourcing project config: ' .. project_config, vim.log.levels.INFO)
            vim.cmd.source(project_config)
          end
        end
        local tabpage      = vim.api.nvim_get_current_tabpage()
        local wins         = vim.api.nvim_tabpage_list_wins(tabpage)
        local win          = vim.api.nvim_get_current_win()
        local bufnr        = vim.api.nvim_get_current_buf()
        local winInTabpage = vim.api.nvim_tabpage_get_win(tabpage)
        vim.notify('Current tabpage: ' .. tostring(tabpage) ..
          ' win: ' .. tostring(win) ..
          ' bufnr: ' .. tostring(bufnr) ..
          ' winInTabpage: ' .. tostring(winInTabpage))
        -- vim.notify('Switched to existing project tab: ' .. project['name'], vim.log.levels.INFO)
        -- use oil plugin to open project root in current window
        -- this will replace the empty buffer
        vim.cmd.edit(project['root'])
        --
        -- local project = vim.t.project
        -- project['name'] = selected_project
        -- project['root'] = project

        -- if vim.fn.filereadable(project_config) == 1 then
        --   vim.notify('Sourcing project config: ' .. project_config, vim.log.levels.INFO)
        --   vim.cmd.source(project_config)
        -- end
        -- Ensure project tab is set up
        -- M.per_tab_setup()
      else
        vim.notify('Create new tab and set working directory')
        vim.cmd('tabnew')
        vim.cmd('tcd ' .. project_path)
        vim.cmd.edit(project_path)
        vim.notify('Opened new project tab: ' .. selected_project, vim.log.levels.INFO)
        -- Set up project tab (terminal, etc)
        local project = vim.t.project
        project['name'] = selected_project
        project['root'] = project
        --check if .nvim.lua exists in project root and source it
        local project_config = project_path .. '/.nvim.lua'
        if vim.fn.filereadable(project_config) == 1 then
          vim.notify('Sourcing project config: ' .. project_config, vim.log.levels.INFO)
          vim.cmd.source(project_config)
        end
      end
-
--
--
--
--
--
--
--
# Project Terminal
A Neovim plugin to manage project-specific terminal buffers
 - Each project has its own named tabage
 - The named tabpage is the project name
 - The name is derived from the project root directory
 - The project root directory is determined by the presence of a `.git` directory
 - autocmmands
 - The global status line shows the current project name
 - Each project tab has its own terminal buffer
 - The terminal buffer is opened in a bottom right split window

 .
--

--[[ utils ]] --
-- check if buffer is valid
-- @param buf number|nil
-- @return boolean
local function is_buf_valid(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end


-- check if window is open and valid
-- TODO!
--- @param win number
--- @return boolean
local function is_open(win)
  return win and vim.api.nvim_win_is_valid(win)
end

--- Create or get a tabpage terminal buffer
--- @return number bufnr terminal buffer number
local function tabpage_term_buffer()
  local project = vim.t.project
  if not project then
    -- Initialize per tab project-specific settings
    vim.t.project = {}
    project = vim.t.project
  end
  -- Reuse existing terminal buffer if valid
  if is_buf_valid(project['term_buf_id']) then
    local bufnr = project['term_buf_id']
    -- Clear modified flag when reusing buffer
    vim.bo[bufnr].modified = false
    return bufnr
  end
  vim.notify('Creating new terminal buffer for project tab: ' .. (project['name'] or 'unknown'))
  -- Create new terminal buffer
  local listed            = false -- not listed in buffer list
  local scratch           = false -- ?? saved to disk
  project['term_buf_id']  = vim.api.nvim_create_buf(listed, scratch)
  local bufnr             = project['term_buf_id']
  vim.bo[bufnr].bufhidden = 'hide'     -- not in the buffer list
  vim.bo[bufnr].filetype  = 'terminal' -- set filetype to terminal
  vim.bo[bufnr].modified  = false      -- clear modified flag
  -- Set buffer name so we can display in winbar and identify
  -- if vim.api.nvim_buf_get_name(bufnr) ~= 'project-terminal' then
  --   vim.api.nvim_buf_set_name(bufnr, 'project-terminal')
  --  end

  -- Add autocmd to clean up on terminal close
  -- vim.api.nvim_create_autocmd('TermClose', {
  --   buffer = bufnr,
  --   callback = function()
  --     vim.schedule(function()
  --       vim.bo[bufnr].channel = 0
  --       vim.bo[bufnr].modified = false
  --     end)
  --   end,
  -- })

  return bufnr
end


--- Open or reuse a window to show the project terminal buffer
--- @param bufnr number  buffer number
--- @return number win|nil window number or nil on error
local function open_term_window(bufnr)
  if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
    vim.notify('Invalid buffer number provided: ' .. tostring(bufnr), vim.log.levels.ERROR)
    return nil
  end
  local win = vim.t['term_win_id'] or nil
  if -- already open and the buffer is in show window
      win and
      vim.api.nvim_win_is_valid(win) and
      vim.api.nvim_win_get_buf(win) == bufnr
  then
    vim.notify('window ' .. win .. ' already open for buffer ' .. bufnr)
    vim.api.nvim_win_set_buf(win, bufnr) -- ensure the buffer is set in the window
    return win
  end
  -- win already open however buffer is not in window
  if win and
      vim.api.nvim_win_is_valid(win) and
      vim.api.nvim_win_get_buf(win) ~= bufnr
  then
    require('mini.bufremove').unshow_in_window(win) -- remove existing buffer from window
    vim.api.nvim_win_set_buf(win, bufnr)            -- set the buffer in the window
    vim.notify('reused window ' .. win .. ' for buffer ' .. bufnr)
    return win
  end
  -- otherwise
  --- create a new split window for buffer bufnr at the bottom of the screen
  vim.notify(' - opening new window for buffer ' .. bufnr)
  local height = math.floor(vim.o.lines * 0.3)
  local enter = false -- do not enter the window after creation
  -- see h: api-win_config
  -- opts: table (optional) with keys
  local config = {
    height = height,       -- 30% of total lines
    split = 'below',       -- split below
    style = 'minimal',     -- no number, cursorline, etc
    width = vim.o.columns, -- full width
    win = -1,              -- create a new window
  }
  -- create the window for the buffer bufnr with the given config
  win = vim.api.nvim_open_win(bufnr, enter, config)
  if not (win and vim.api.nvim_win_is_valid(win)) then
    vim.notify('Failed to open window for buffer ' .. bufnr, vim.log.levels.ERROR)
    return nil
  end
  -- set this show window as a tab scoped variable
  vim.t['term_win_id'] = win
  -- sorted window options
  --[[ minimal style
  Disables
  'number',
  'relativenumber',
  'cursorline',
  'cursorcolumn',
  'foldcolumn',
  'spell' and
  'list'
  options.
  'signcolumn' is changed to `auto` and
  'colorcolumn' is cleared.
  'statuscolumn' is changed to empty.
  The end-of-buffer region is hidden by setting`eob` flag of 'fillchars' to a space char,
  and clearing the |hl-EndOfBuffer| region in 'winhighlight'.
  ]]

  vim.wo[win].sidescrolloff = 0
  vim.wo[win].winbar = "## %{bufname('%')} ## window [%{bufwinid('%')}] buffer [%{bufnr('%')}] buftype [%{&buftype}]"
  vim.wo[win].winfixheight = true
  vim.wo[win].wrap = false
  -- vim.wo[win].statuscolumn = " "
  vim.notify(' - opened window ' .. win .. ' for buffer ' .. bufnr)
  return win
end
--- Start or reuse a terminal channel in the tabpage terminal buffer
--- @param cmd string|table command to run in terminal
--- @return number channel id or zero on failure
local function tabpage_term_channel(cmd)
  local bufnr = tabpage_term_buffer()
  if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
    vim.notify('Invalid terminal buffer for command: ' .. tostring(cmd), vim.log.levels.ERROR)
    vim.t['term_chan_id'] = 0
    return vim.t['term_chan_id']
  end
  local win = open_term_window(bufnr)
  open_term_window(bufnr)
  -- Start terminal job in the buffer channel no open if not already started
  if not vim.bo[bufnr].channel or vim.bo[bufnr].channel == 0 then
    vim.notify('Starting new terminal channel in buffer ' .. bufnr .. ' with command: ' .. tostring(cmd))
    vim.api.nvim_buf_call(bufnr, function()
      local shell = vim.o.shell
      local job_opts = {
        term = true,
        pty = true,
      }
      vim.fn.jobstart(shell, job_opts)
    end)
  else
    vim.notify('Reusing existing terminal channel in buffer ' .. bufnr .. ' for command: ' .. tostring(cmd))
    -- get handle for existing channel
    local chan = vim.bo[bufnr].channel
    local ok, err = pcall(vim.fn.chansend, chan, cmd)
    if not ok then
      vim.notify('Failed to send command to terminal: ' .. tostring(err), vim.log.levels.ERROR)
      -- Try to restart terminal
      --vim.bo[bufnr].channel = 0
      --return M.interactive_term(cmd, opts) -- Retry once
    end
  end
  vim.t['term_chan_id'] = vim.bo[bufnr].channel
  return vim.t['term_chan_id']
end

M.per_tab_setup = function()
  vim.notify("Project tab  set up: ")
  local buf = vim.api.nvim_get_current_buf()
  local tab = vim.api.nvim_get_current_tabpage()
  local bufname = vim.api.nvim_buf_get_name(buf)
  vim.notify(" - current buffer name: " .. bufname)
  -- Determine project root from current buffer
  local start_dir = vim.fn.fnamemodify(bufname, ':h')
  local git_root = vim.fs.root(start_dir, '.git')
  if git_root then
    -- The vim.t table holds tabpage-local variables
    if not vim.t.project then
      -- Initialize project-specific settings
      vim.t.project = {}
      local project = vim.t.project
      project['name'] = vim.fs.basename(git_root)
      project['root'] = git_root
      -- Open or reuse terminal buffer and window
      local term_buf = tabpage_term_buffer()
      local term_win = open_term_window(term_buf)
      local term_chan = tabpage_term_channel("cd " .. git_root .. "\n")
      vim.notify("Set up project tab: " .. project['name'] .. " at root: " .. project['root'])
    else
      vim.notify("Project tab already set up: " .. vim.t.project['name'])
    end
  end
end


-- TODO: TESTING function to open terminal in current project tab
-- expose functions for external use and testing then remove later
M.tabpage_term_buffer = tabpage_term_buffer
M.open_term_window = open_term_window
M.tabpage_term_channel = tabpage_term_channel
-- M.setup = per_tab_setup

return M
