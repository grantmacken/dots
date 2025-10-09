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

-- set the tab project variables via an autocmd
--
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
  --print(vim.inspect(vim.t.root))
  --print(vim.fs.basename(vim.t.root))
end

local group = vim.api.nvim_create_augroup('my_project_tab', {})
local au = function(event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, { group = group, pattern = pattern, callback = callback, desc = desc })
end
au({ 'BufEnter', 'TabNew' }, '*', function()
  set_tab_project_vars()
end, 'Set tab project variables')

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
