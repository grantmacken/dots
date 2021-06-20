M = {}

-- before plugin enabled
-- local setup = function() end
--
--

 
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


-- after plugin enabled
local config = function()
  local lualine = require('lualine')
  local colors = {
    bg0    = '#323d43',
    bg1    = '#3c474d',
    bg3    = '#505a60',
    fg     = '#d8caac',
    aqua   = '#87c095',
    green  = '#a7c080',
    orange = '#e39b7b',
    magenta = '#d39bb6',
    red    = '#e68183',
    grey1  = '#868d80',
  }




  local mode =  function()
      local mode_color = {
        n      = colors.red,
        i      = colors.green,
        v      = colors.aqua,
        [''] = colors.aqua,
        V      = colors.aqua,
        c      = colors.magenta,
        no     = colors.red,
        s      = colors.orange,
        S      = colors.orange,
        [''] = colors.orange,
        ic     = colors.yellow,
        R      = colors.yellow,
        Rv     = colors.magenta,
        cv     = colors.red,
        ce     = colors.red,
        r      = colors.grey1,
        rm     = colors.grey1,
        ['r?'] = colors.grey1,
        ['!']  = colors.red,
        t      = colors.red
      }
      vim.api.nvim_command('hi! LualineMode guifg='..mode_color[vim.fn.mode()] .. " guibg="..colors.bg0)
      return ''
    end

  lualine.setup({
    options = {
      icons_enabled = true,
      theme = 'everforest',
      component_separators = '',
      section_separators = '',
      disabled_filetypes = {}
    },
    sections = {
      lualine_a = { {mode,color = "LualineMode",left_padding = 0}},
      lualine_b = {'branch'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  })
end

M.config = config
-- M.setup = setup

return M



