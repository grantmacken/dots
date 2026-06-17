# My Dotfiles

This repo is an experimental work in progress!

My operating system is Fedora Silverblue which is an atomic (immutable) operating system, so my
aim is to provide a CLI customized toolbox work environment orientated around Neovim and associated CLI tooling

## Requirements

**Host System**:
Modern Linux OS (Fedora Silverblue recommended)
**Main Host Tool Set**:
1. terminal emulator: ptyxis (configured in my toolbox container)
1. podman (for container management)
2. toolbox (for container management)
3. dconf (for terminal profile management)

Note: These are already installed on Fedora Silverblue, 
but may require manual installation on other Linux distributions.

## ptyxis terminal
 The ptyxis terminal is the default terminal emulator in my toolbox container.
 It is a modern terminal emulator that supports multiple tabs and panes,
 as well as various keyboard shortcuts for navigation and management.
 It the gnome terminal emulator that is included in the toolbox container, 
 and it is configured to be the default terminal emulator for the container.

### Terminal Tab Navigation

Ptyxis supports the following keyboard shortcuts for tab navigation:
| Action              | Shortcut         | Note                                      |
|---------------------|------------------|-------------------------------------------|
| Next Tab            | Ctrl+PageDown    | Cycles forward through the tabs.
| Previous Tab        | Ctrl+PageUp      | Cycles backward through the tabs.
| Direct Tab Access   | Alt+1 through Alt+9 | Directly jumps to the corresponding tab number (e.g., Alt+3 goes to the third tab)

## Personal Toolbox Container

The repo contains 2 scripts I use to  keep my toolbox up to date.
1 `dot-local/bin/tbx_reset`: downloads the latest tbx-coding toolbox
2. `dot-local/bin/pty_conf`: configures the ptyxis terminal and keyboard shortcuts to work with my toolbox container.

 - The ptyxis terminal is configured to use a `default profile`, and this profile is configured to use the `default container` for its terminal sessions.
 - The `default container` for this profile uses my toolbox container.

My `~/Projects` directory contains my git controlled projects. 
The pty_conf script configures keyboard shortcuts to open new ptyxis terminal tabs.
Each shortcut opens a new terminal tab with the git project working directory set and opens in Neovim or Copilot Chat.

| Name                | Shortcut         | Note                                         |
|---------------------|------------------|-------------------------------------------   |
| neovim_accounts     | Control Alt 1    | Open nvim in accounts directory in new tab   |
| copilot_accounts    | Shift Alt 1      | Open copilot in accounts directory in new tab|
| neovim_dots         | Control Alt 2    | Open nvim in dots directory in new tab       |
| copilot_dots        | Shift Alt 3      | Open copilot in dots directory in new tab    |


## Dot file management
My dot files are managed in this Git repository via stow.

### How Stow Works With My Dotfiles

My dotfiles are managed by GNU Stow. 
The `make` command invokes `stow` with the `--dotfiles` option.
This symlinks the dot files from this repository into my home directory.

Using the `--dotfiles` option requires base directory naming conventions:
 - Directories containing dot directories or files must be named starting with `dot-`
 - Example: `dot-config/` → `~/.config/`, `dot-local/` → `~/.local/`

The `.stow-local-ignore` file at the root excludes files from being stowed:
 - README.md and Makefile are not stowed as they are in the .stow-local-ignore file.

 Also any `.*` files in the root directory are also excluded from being stowed by default.



### Better tooling with better configurations

My dot files provide configurations for various CLI tools I use.
The aim is to provide better configurations for these tools to improve my productivity.
For example, my Neovim configuration provides a better coding experience with
syntax highlighting, code completion, linting, and other features.

### Deployment Instructions

⚠️ **Warning**: I don't recommend using my dot files as-is. They are tailored to my personal preferences and workflow.
However, if you would like to use them as a starting point or reference, you can deploy them into your home directory.

**Prerequisites**:

```sh
# Clone the repository
mkdir -p ~/Projects
git clone https://github.com/grantmacken/dots.git ~/Projects/dots
cd ~/Projects/dots
# make check-tools script executable
chmod +x dot-local/bin/check-tools.sh
# verify required CLI tools are installed
dot-local/bin/check-tools.sh
# Create directories 
make init
# Deploy dot files
make
``` 

**What gets deployed**:
- `dot-config/` → `~/.config/` (Neovim, systemd, containers configs)
- `dot-local/bin/` → `~/.local/bin/` (executable scripts)
- `dot-bashrc.d/` → `~/.bashrc.d/` (bash configuration snippets)



## Ptyxis Default Profile with default container

The script `dot-local/bin/pty_conf` configures my ptyxis terminal and keyboard shortcuts to work with my toolbox container.







## My Toolbox Container





