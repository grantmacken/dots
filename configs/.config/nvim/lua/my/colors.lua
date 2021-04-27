local M = {}
M.version = 'v0.0.1'
local cmd = vim.api.nvim_command
M.setup = function( tbl )
 local sColorscheme = tbl.scheme
 local sPackName = tbl.packname
  vim.o['termguicolors'] =  true
  vim.o['background'] = 'dark'
  if sColorscheme == 'nord' then
    -- https://www.nordtheme.com/docs/ports/vim/configuration
    vim.g['let g:nord_uniform_status_lines'] = 1
    -- let g:nord_cursor_line_number_background = 1
    -- let g:nord_bold_vertical_split_line = 1
    -- let g:nord_uniform_diff_background = 1
  elseif sColorscheme == 'seoul256' then
    vim.g['seoul256_background'] = 238
    vim.g['seoul256_srgb'] = 1
    -- https://github.com/neovim/neovim/wiki/FAQ
    -- change default pmenu
    -- api.nvim_command( 'highlight Pmenu guifg=#d7d7af guibg=#585858' )
    -- api.nvim_command( 'highlight PmenuSel  guifg=#4e4e4e  guibg=#d7d7af' )
    -- api.nvim_command( 'highlight Cursor guifg=#558817 guibg=#558817' )
    -- api.nvim_command( 'highlight Cursor2 guifg=#a33243 guibg=#a33243' )
    -- api.nvim_command( 'highlight VertSplit guifg=#585858 guibg=#585858' )
  end
  cmd('packadd ' .. sPackName )
  cmd('colorscheme ' .. sColorscheme )
end
return M
