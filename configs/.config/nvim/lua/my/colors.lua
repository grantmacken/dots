vim.g.nord_style = "nord"
vim.g.nord_borders = false
vim.g.nord_contrast = false
vim.g.nord_cursorline_transparent = true
vim.g.nord_disable_background = true
require('nord').set()
vim.cmd 'hi normal guibg=#2f334d'
print( 'set up nord colorscheme')
