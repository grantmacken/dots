--[[ markdown block
-- each tab is a separate 'git' version controlled project
-- a tab project TCD is set
 - [x] toggle terminal - one and only one terminal per tab. i.e. a terminal id handle from the tab
 - [x] open and close terminal for tab. This should hide/open an existing terminal session
 - [x] terminal always opens in bottom right split window occupying the full window width.
 - [x] to avoid distraction of text bouncing around,the space height and width occupied by the terminal window will be the same as width and height of the quickfix and location list
 - [x] Ability to toggle between terminal, quickfix and location list
 - [ ] Project commands - BUILD TEST
--]]
--
local keymap = require('util').keymap
-- Assume you required the module above as 'git_utils'
--
local git_utils = require("git")
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
  group = vim.api.nvim_create_augroup("GitBranchUpdate", { clear = true }),
  callback = git_utils.update_branch_name,
  -- Pattern '*' runs for all files
  pattern = "*",
})

-- Project selector using fzf
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




-- Create user command
vim.api.nvim_create_user_command('ProjectSelect', select_project, {
  desc = 'Select and open a project from ~/Projects directory'
})


-- Window types for toggling
local WINDOW_TYPES = {
  TERMINAL = 'terminal',
  QUICKFIX = 'quickfix',
  LOCATION = 'location'
}

-- Get the standard bottom window height (30% of screen)
local function get_bottom_window_height()
  return math.floor(vim.o.lines * 0.3)
end

-- Check if quickfix window is open
local function is_quickfix_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == 'quickfix' then
      -- Check if it's quickfix (not location list)
      local wininfo = vim.fn.getwininfo(win)[1]
      return wininfo and wininfo.quickfix == 1 and wininfo.loclist == 0
    end
  end
  return false
end

-- Check if location list window is open
local function is_location_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == 'quickfix' then
      -- Check if it's location list (not quickfix)
      local wininfo = vim.fn.getwininfo(win)[1]
      return wininfo and wininfo.loclist == 1
    end
  end
  return false
end

-- Get current bottom window type
local function get_current_bottom_window_type()
  local current_tab = vim.fn.tabpagenr()
  local tab_var_name = 'terminal_buf_' .. current_tab
  local term_buf = vim.t[tab_var_name]

  -- Check if terminal window is open
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == term_buf then
        return WINDOW_TYPES.TERMINAL
      end
    end
  end

  -- Check if quickfix is open
  if is_quickfix_open() then
    return WINDOW_TYPES.QUICKFIX
  end

  -- Check if location list is open
  if is_location_open() then
    return WINDOW_TYPES.LOCATION
  end

  return nil
end

-- Close all bottom windows (terminal, quickfix, location list)
local function close_all_bottom_windows()
  local current_tab = vim.fn.tabpagenr()
  local tab_var_name = 'terminal_buf_' .. current_tab
  local term_buf = vim.t[tab_var_name]

  -- Close terminal window if open
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == term_buf then
        vim.api.nvim_win_close(win, false)
        break
      end
    end
  end

  -- Close quickfix and location list windows
  vim.cmd('cclose')
  vim.cmd('lclose')
end

-- Open terminal window
local function open_terminal()
  local current_tab = vim.fn.tabpagenr()
  local tab_var_name = 'terminal_buf_' .. current_tab
  local term_buf = vim.t[tab_var_name]

  -- If terminal buffer doesn't exist or is invalid, create new one
  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    -- Create terminal in botright split
    vim.cmd('botright split')
    vim.cmd('terminal')

    -- Store the terminal buffer for this tab
    term_buf = vim.api.nvim_get_current_buf()
    vim.t[tab_var_name] = term_buf

    -- Set terminal window to standard height
    vim.api.nvim_win_set_height(0, get_bottom_window_height())

    -- Configure terminal buffer settings
    vim.bo[term_buf].buflisted = false
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = 'no'

    -- Enter insert mode in terminal
    vim.cmd('startinsert')
  else
    -- Terminal buffer exists but window is closed, reopen it
    vim.cmd('botright split')
    vim.api.nvim_win_set_buf(0, term_buf)

    -- Set terminal window to standard height
    vim.api.nvim_win_set_height(0, get_bottom_window_height())

    -- Configure window settings
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = 'no'

    -- Enter insert mode in terminal
    vim.cmd('startinsert')
  end
end

-- local function open_copilot()
--   local current_tab = vim.fn.tabpagenr()
--   local tab_var_name = 'terminal_buf_' .. current_tab
--   local term_buf = vim.t[tab_var_name]
--   if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
--     -- If terminal buffer exists, switch to it
--     for _, win in ipairs(vim.api.nvim_list_wins()) do
--       if vim.api.nvim_win_get_buf(win) == term_buf then
--         vim.api.nvim_set_current_win(win)
--         -- run copilot in terminal if not already running
--         local term_job_id = vim.b[term_buf].terminal_job_id
--         if term_job_id and vim.fn.jobwait({term_job_id}, 0)[1] == -1 then
--           -- Job is still running, assume copilot is active
--           vim.notify('Copilot terminal already running', vim.log.levels.INFO)
--         else
--           -- Start copilot in terminal
--           vim.api.nvim_buf_set_lines(term_buf, 0, -1, false, {'copilot'})
--           vim.cmd('startinsert')
--         end
--         return
--       end
--     end
--   end
-- end



-- Open quickfix window
local function open_quickfix()
  vim.cmd('botright copen')
  vim.api.nvim_win_set_height(0, get_bottom_window_height())
end

-- Open location list window
local function open_location()
  vim.cmd('botright lopen')
  vim.api.nvim_win_set_height(0, get_bottom_window_height())
end

-- Toggle between terminal, quickfix, and location list
local function toggle_bottom_windows()
  local current_type = get_current_bottom_window_type()

  -- Close all bottom windows first
  close_all_bottom_windows()

  -- Determine what to open next based on current state
  if current_type == WINDOW_TYPES.TERMINAL then
    -- Terminal -> Quickfix (if quickfix list has entries)
    if not vim.tbl_isempty(vim.fn.getqflist()) then
      open_quickfix()
    else
      -- No quickfix entries, try location list
      if not vim.tbl_isempty(vim.fn.getloclist(0)) then
        open_location()
      end
      -- If neither has entries, close all (already done above)
    end
  elseif current_type == WINDOW_TYPES.QUICKFIX then
    -- Quickfix -> Location List (if location list has entries)
    if not vim.tbl_isempty(vim.fn.getloclist(0)) then
      open_location()
    else
      -- No location list entries, go to terminal
      open_terminal()
    end
  elseif current_type == WINDOW_TYPES.LOCATION then
    -- Location List -> Terminal
    open_terminal()
  else
    -- Nothing open, start with terminal
    open_terminal()
  end
end

-- Legacy terminal toggle function for backward compatibility
local function toggle_terminal()
  local current_type = get_current_bottom_window_type()

  if current_type == WINDOW_TYPES.TERMINAL then
    -- If terminal is open, close all bottom windows
    close_all_bottom_windows()
  else
    -- If terminal is not open, close others and open terminal
    close_all_bottom_windows()
    open_terminal()
  end
end

-- Clean up terminal buffer when tab is closed
vim.api.nvim_create_autocmd('TabClosed', {
  callback = function()
    -- Clean up tab-local terminal variable when tab closes
    -- Note: This runs after the tab is closed, so we can't access vim.t directly
    -- Terminal buffer will be cleaned up by Neovim's garbage collection
  end,
  desc = 'Clean up terminal when tab closes'
})

-- Create user commands
vim.api.nvim_create_user_command('TerminalToggle', toggle_terminal, {
  desc = 'Toggle terminal for current tab'
})

vim.api.nvim_create_user_command('BottomWindowToggle', toggle_bottom_windows, {
  desc = 'Toggle between terminal, quickfix, and location list'
})

local function run_copilot()
  local on_exit = function(obj)
    vim.notify(vim.inspect(obj.code))
    vim.notify(vim.inspect(obj.stdout))
    --vim.notify(obj.signal)
    --vim.notify(obj.stdout)
    --:vim.notify(obj.stderr)
  end
  -- Runs asynchronously:
  -- copilot -p 'add commit message since last commit' --allow-all-tools --add-dir $(CURDIR)
  --
  local obj = vim.system({
      'copilot',
      '-p',
      'add commit message since last commit',
      '--allow-all-tools',
      '--add-dir', vim.fn.getcwd()
    },
    { text = true }):wait()

  vim.notify(vim.inspect(obj.code))
  vim.notify(vim.inspect(obj.stdout))
end


vim.api.nvim_create_user_command('CopilotToggle', run_copilot, {
  desc = 'Toggle copilot cli'
})


--[[
--KEY BINDS
--]]


keymap('<leader>ps', select_project, '[s]elect project tab')
keymap('<leader>pt', toggle_terminal, 'Toggle project [t]erminal')
keymap('<leader>pw', toggle_bottom_windows, 'Toggle project [w]indows terminal/quickfix/location')

-- Additional keybinding for quick access (legacy terminal toggle)
keymap('<C-t>', toggle_terminal, 'Toggle tab terminal')

-- Additional keybinding for the enhanced toggle
keymap('<C-w>t', toggle_bottom_windows, 'Toggle between terminal/quickfix/location')
