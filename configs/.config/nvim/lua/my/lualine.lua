M = {}

-- before plugin enabled
-- local setup = function() end
--
--
local colors = {
bg       = '#545454',
fg       = '#dfe0e0',
yellow   = '#c3a769',
cyan     = '#c3a769',
darkblue = '#d0a39f',
green    = '#678568',
orange   = '#67a9aa',
violet   = '#84a4c1',
magenta  = '#d0a39f',
blue     = '#84a4c1';
red      = '#a07474';
}

 
local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end
}

local tblMode = {
  function()
    local mode_color = {
      n      = colors.red,
      i      = colors.green,
      v      = colors.blue,
      [''] = colors.blue,
      V      = colors.blue,
      c      = colors.magenta,
      no     = colors.red,
      s      = colors.orange,
      S      = colors.orange,
      [''] = colors.orange,
      ic     = colors.yellow,
      R      = colors.violet,
      Rv     = colors.violet,
      cv     = colors.red,
      ce     = colors.red,
      r      = colors.cyan,
      rm     = colors.cyan,
      ['r?'] = colors.cyan,
      ['!']  = colors.red,
      t      = colors.red
    }
    vim.api.nvim_command('hi! LualineMode guifg='..mode_color[vim.fn.mode()] .. " guibg="..colors.bg)
    return ''
  end,
  color = "LualineMode",
  left_padding = 0,
}

-- after plugin enabled
local config = function()
  require('lualine').setup({
    options = {
      theme = 'everforest',
      -- Disable sections and component separators
      component_separators = '',
      section_separators = '',
    }
  })
end

M.config = config
-- M.setup = setup

return M



