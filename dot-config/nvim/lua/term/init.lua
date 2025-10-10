local M = {}


local function get_bottom_window_height()
  return math.floor(vim.o.lines * 0.3)
end

local function term_buffer()
  local tab = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(tab)
  for _, win in ipairs(wins) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    if vim.bo[bufnr].buftype == 'terminal' then
      return bufnr
    end
  end
  local listed = true
  local scratch = false
  local bufnr = vim.api.nvim_create_buf(listed, scratch)
  vim.bo[bufnr].filetype = 'terminal'
  return bufnr
end

local function term_window(bufnr)
  local tab = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(tab)
  for _, win in ipairs(wins) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    if vim.bo[bufnr].buftype == 'terminal' then
      return win
    end
  end
  local height = get_bottom_window_height()
  local enter = false
  local win = vim.api.nvim_open_win(bufnr, enter, {
    width = vim.o.columns,
    height = height,
    split = 'below',
    win = -1
  })
  return win
end

M.open = function()
  local bufnr = term_buffer()
  local win = term_window(bufnr)
  vim.api.nvim_buf_call(bufnr, function() vim.cmd.term() end)
  vim.t.term_buf = bufnr
  vim.t.term_win = win
  vim.t.term_chan = vim.bo[bufnr].channel
  vim.t.term_name = vim.api.nvim_buf_get_name(bufnr)
  vim.notify(vim.inspect({
    bufnr = vim.t.term_buf,
    win = vim.t.term_win,
    chan = vim.t.term_chan,
    name = vim.t.term_name
  }), vim.log.levels.INFO, { title = 'Terminal Opened' })
  -- vim.api.nvim_chan_send(vim.t.term_chan, "ls -l \r\n")
end

M.close = function()
  vim.notify(vim.inspect({
    bufnr = vim.t.term_buf,
    win = vim.t.term_win,
    chan = vim.t.term_chan,
    name = vim.t.term_name
  }), vim.log.levels.INFO, { title = 'Terminal Opened' })
  if vim.t.term_win and vim.api.nvim_win_is_valid(vim.t.term_win) then
    vim.api.nvim_win_close(vim.t.term_win, true)
  end
end

return M
