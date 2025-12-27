# My Dotfiles

This repo is an experimental work in progress!

My operating system is Fedora Silverblue which is an atomic (immutable) operating system, so my
aim is to provide a CLI customized toolbox work environment orientated around Neovim and associated CLI tooling

## Requirements

**Host System**:
1. Modern Linux OS (Fedora Silverblue recommended)
2. podman
3. toolbox
4. dconf

Note: These are already installed on Fedora Silverblue

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

### GitHub Actions Testing

I use GitHub actions to test the verify a stow deployment
 of my dot files into a fresh Linux environment. I use the `ubuntu-latest` runner.
 The workflow is defined in `.github/workflows/default.yaml`.
The workflow runs checks to verify:
- `make init` creates required directories
- `make` (stow) deploys without errors

It doesn't test every aspect of my dot files, but it does provide a basic verification
that the stow deployment works in a clean environment.

All my coding tools run inside a toolbox container. 
The toolbox container I use not really relevant to this repository.
There is difficulty of running a toolbox container inside the GitHub actions runner.
So with GitHub actions I mimic my toolbox environment by adding the CLI tools I use in my toolbox.

### Checking Tool Configurations

Each tool I use may have a configuration file.
For example, Neovim requires a configuration file at `~/.config/nvim/init.vim`.
These configuration files are provided in the `dot-config/` directory.
This allows me to test the stow deployment of my dot files in an environment
that mimics my toolbox container without actually running a toolbox container.

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

*
