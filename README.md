# dotfiles

Using [make](https://www.gnu.org/software/make) with [stow](http://mywiki.wooledge.org/DotFiles) to organize my [dotfiles](https://github.com/webpro/awesome-dotfiless)
under [git](https://github.com/grantmacken/dot://github.com/grantmacken/dots) control


# `configs/.config/`

A configuration file is created by 
 - a folder named after the program in the `configs/.config/` directory
 - a config file in the directory. `configs/.config/{{progam-name}}/{config-file}`

neovim example `configs/.config/nvim/init.vim`

## `make configs`

Configuration data is symlinked to the $HOME directory.
The xdg configuration directory `~/.config` is used.
As a conveniance directories in `configs/.config` are also 
symlinked to the current directory, so you can 
navigate to a config directory from the root directory.


```
ls -l ./kitty
lrwxrwxrwx 1 gmack gmack 21 Jul 18 08:25 kitty -> configs/.config/kitty
```







