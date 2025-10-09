M = {}
--[[
-- use LuaCATS annotations for functions
 Scratch Module
 A simple scratch buffer module for Neovim
  - [ ] show function to display a scratch buffer with given lines and title
  - [ ] create_buffer function to create a new scratch buffer
  - [ ] create_window function to open a floating window with the scratch buffer
  - [ ] Keymap to close the window with 'q'
  - [ ] Autocommand to set the keymap when entering the buffer
  - [ ] Dynamic sizing based on current window dimensions
  - [ ] Minimal styling with a border
 ## Future Features TODO
  - [ ] a run function to execute code in the scratch buffer (future feature)
  - [ ] a save function to save the scratch buffer to a file (future feature)
  - [ ] a clear function to clear the contents of the scratch buffer (future feature)
  - [ ] a toggle function to show/hide the scratch buffer (future feature)
]]                                                  --                                                 --

--[[#############################################]] --

local width = math.ceil(math.min(vim.o.columns, math.max(80, vim.o.columns - 80)))
local height = math.ceil(math.min(vim.o.lines, math.max(20, vim.o.lines - 10)))

local create_buffer = function()
  local listed = false
  local scratch = true -- always 'nomodified'
  local buf = vim.api.nvim_create_buf(listed, scratch)
  -- vim.api.nvim_set_option_value("filetype", "terminal", { buf = buf })
  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = buf,
    callback = function()
      vim.keymap.set("n", "q", vim.cmd.close, {
        silent = true,
        buffer = true,
      })
    end
  })
  return buf
end

local create_window = function(buf, title)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'win',
    title = title,
    width = width,
    height = height,
    row = 1,
    col = width,
    style = 'minimal',
    focusable = true,
    border = 'single',
  })
end

M.show = function(tbl, title)
  vim.schedule(function()
    local set_lines = vim.api.nvim_buf_set_lines
    local buf = create_buffer()
    create_window(buf, title)
    set_lines(buf, 0, -1, true, tbl)
  end)
end

-- params: cmd (string or table), title string
-- returns: nil
M.run = function(cmd, title)
  vim.schedule(function()
    local buf = vim.api.nvim_create_buf(false, true)
    
    -- Create window for terminal
    local win = vim.api.nvim_open_win(buf, true, {
      relative = 'win',
      title = title or 'Terminal Output',
      width = width,
      height = height,
      row = 1,
      col = width,
      style = 'minimal',
      focusable = true,
      border = 'single',
    })
    
    -- Start terminal with a shell
    local chan = vim.fn.termopen(vim.o.shell, {
      on_exit = function(job_id, exit_code, event_type)
        if exit_code ~= 0 then
          vim.notify('Command failed with exit code ' .. exit_code, vim.log.levels.ERROR)
        else
          vim.notify('Command completed successfully', vim.log.levels.INFO)
        end
      end
    })
    
    -- Set up keymap to close window
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buf,
      callback = function()
        vim.keymap.set("n", "q", vim.cmd.close, {
          silent = true,
          buffer = true,
        })
      end,
      once = true,
    })
    
    if chan == 0 then
      vim.notify('Invalid arguments for terminal', vim.log.levels.ERROR)
      return
    elseif chan == -1 then
      vim.notify('Command not executable', vim.log.levels.ERROR)
      return
    end
    
    -- Wait a bit for shell to be ready, then send the command with newline to execute it
    vim.defer_fn(function()
      vim.fn.chansend(chan, cmd .. '\n')
    end, 100) -- 100ms delay to ensure shell is ready
  end)
end


return M
