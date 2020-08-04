vim = vim or {}
api = vim.api
fn = vim.fn

function openJobWindow()
  local lines = api.nvim_get_option("lines")
  local columns = api.nvim_get_option("columns")
  local height = fn.float2nr((lines - 2) * 0.3)
  local row = fn.float2nr((lines - height) / 2)
  local width = fn.float2nr(columns * 0.6)
  local col = fn.float2nr((columns - width) / 2)
  local border_opts = {
    relative = 'editor',
    row = row - 1,
    col = col - 2,
    width = width + 4,
    height = height + 2,
    style = 'minimal'
  }

  local opts = {
    relative = 'editor',
    row = row - 4,
    col = col,
    width = width,
    height = height,
    style = 'minimal'
  }
  local top = string.format("╭%s╮", string.rep("─", width + 2))
  local mid = string.format("│%s│",string.rep(" ", width + 2))
  local bot = string.format("╰%s╯", string.rep("─", width + 2))
  local bufLines = string.format("%s%s%s",top,string.rep(mid, height),bot)
  local bbuf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(bbuf, 0, -1, true, { bufLines })
  -- api.nvim_open_win(bbuf, true, border_opts)
  local buf = api.nvim_create_buf(false, true)
  local window = api.nvim_open_win(buf, true, opts)
  return { buf = buf, window = window }
end

openJobWindow()
