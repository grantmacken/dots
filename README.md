# dotfiles

Using [make](https://www.gnu.org/software/make) with [stow](http://mywiki.wooledge.org/DotFiles) to organize my [dotfiles](https://github.com/webpro/awesome-dotfiless)
under [git](https://github.com/grantmacken/dot://github.com/grantmacken/dots) control

## directory `configs/.config/`

A configuration file is created by 
 - a folder named after the program in the `configs/.config/` directory
 - a config file in the directory. `configs/.config/{{progam-name}}/{config-file}`

neovim example `configs/.config/nvim/init.vim`

## `make`

Configuration data is symlinked to the $HOME directory.
The xdg configuration directory `~/.config` is used.

## fresh install notes
 
## gh-cli









