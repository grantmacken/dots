local M = {}
M.version = 'v0.0.1'
local api = vim.api

M.setup = function( sColorscheme )
  api.nvim_set_option('termguicolors', true)
  if sColorscheme == 'ayu' then
    -- api.nvim_set_var('ayucolor','light')
    api.nvim_set_var('ayucolor','mirage')
    api.nvim_command('colorscheme ' .. sColorscheme)
    return true
  end
  if sColorscheme == 'nord' then
    -- https://www.nordtheme.com/docs/ports/vim/configuration
    -- let g:nord_uniform_status_lines = 1
    -- let g:nord_cursor_line_number_background = 1
    -- let g:nord_bold_vertical_split_line = 1
    -- let g:nord_uniform_diff_background = 1
    api.nvim_command('colorscheme ' .. sColorscheme)
    --api.nvim_set_option('colorscheme', sColorscheme )
    return true
  end
  if sColorscheme == 'seoul256' then
    api.nvim_set_var('seoul256_background',238)
    api.nvim_set_var('seoul256_srgb',1)
    api.nvim_set_option('background','dark')
    -- https://github.com/neovim/neovim/wiki/FAQ
    -- change default pmenu
    api.nvim_command( 'highlight Pmenu guifg=#d7d7af guibg=#585858' )
    api.nvim_command( 'highlight PmenuSel  guifg=#4e4e4e  guibg=#d7d7af' )
    api.nvim_command( 'highlight Cursor guifg=#558817 guibg=#558817' )
    api.nvim_command( 'highlight Cursor2 guifg=#a33243 guibg=#a33243' )
    api.nvim_command( 'highlight VertSplit guifg=#585858 guibg=#585858' )
    api.nvim_command('colorscheme ' .. sColorscheme)
    return true
  end

end
-- M.setup('nord')
return M
