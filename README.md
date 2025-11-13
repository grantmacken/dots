# My Dotfiles

This repo is an experimental work in progress!

My operating system is Fedora Silverblue which is an atomic (immutable) operating system, so my
aim is to provide a CLI customized toolbox work environment orientated around Neovim and associated CLI tooling

## Requirements

A modern Linux OS with the following install CLI apps
1. podman
2. toolbox
3. dconf

Note: These are already installed on Fedora

## Dot file management

The terminal CLI tools I use are run from a toolbox container. 
The toolbox container I use is created from the container image 
`ghcr.io/grantmacken/tbx-coding:latest` which is a Fedora based toolbox with additional coding tools installed.

```
toolbox create  --image ghcr.io/grantmacken/tbx-coding:latest tbx-coding
toolbox enter coding
```
From inside the toolbox I clone this repository and run 
```
make init # creates some directories
make      # symlinks my dot files
```

I use Makefile targets to orchestrate the deployment of my dot files and 
 management of systemd services and podman quadlets from inside the toolbox container.

My dotfiles are actually managed by Stow. 
The `make` command is a main target which invokes `stow` the with `--dotfiles` option.
This to symlinks the dot files from this repository into my home directory.
Using the `--dotfiles` option requires base directory naming conventions to be followed.
The directories containing dot directories or files must be named starting with `dot-`
The .stow-local-ignore files at the root of this repo is used to exclude files or directories from being stowed.
The main ones being this README.md file and the Makefile itself.
In addition any `.*` files in the root of the repository are ignored by stow.


## ./dot-local/bin

 - dconf-writes 

    "Dconf is the low-level configuration system used by the GNOME desktop environment"

 The dconf-writes script sets up some of my preferences.

  - switch caps/escape on keyboard
  - use BlexMono as font in Ptyxis terminal
  - use Kanagawa pallette in terminal


 - tbx-reset


## Toolbox


## Quadlets

[docs](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html)


Location: `./dot-config/containers/systemd/`

Files a read during boot and when `systemctl daemon-reload` is run

`.volume, .network, .build, and .image files` run as a `oneshoot` service





## Neovim notes



<!--

## First Things First
Clone this repo and cd into it.
The bin dir contains a bash script: 'neovim-toolbox-setup'
Read the script before you run it!!!

```sh
# read the setup script
cat bin/neovim-toolbox-setup
# make sure it is executable
chmod +x bin/neovim-toolbox-setup
# run the script
./bin/neovim-toolbox-setup
```

-->

<!-- The systemd timer for the associated 'language server' ensures the *latest* language server is available. -->



