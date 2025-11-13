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

### Toolbox Setup

```bash
# Create the toolbox container
toolbox create --image ghcr.io/grantmacken/tbx-coding:latest tbx-coding

# Enter the toolbox
toolbox enter tbx-coding

# Clone this repository
git clone https://github.com/grantmacken/dots.git
cd dots

# Deploy dotfiles
make init  # creates directories
make       # symlinks dot files
```

### Makefile Targets

I use Makefile targets to orchestrate the deployment of my dot files and 
management of systemd services and podman quadlets from inside the toolbox container.

#### Setup & Deployment

- **`make init`** - Create required directories in $HOME (.config, .cache, .local, etc.)
- **`make`** (default) - Deploy dotfiles via Stow (symlinks dot-* directories to ~)
- **`make reset_nvim`** - Reset Neovim (clean cache/state, redeploy, reinstall plugins)

#### Verification

- **`make check-toolbox`** - Verify running in tbx-coding toolbox
- **`make check-tools`** - Verify required CLI tools and versions (stow, make, git, systemctl, nvim)
- **`make test`** - Run Neovim busted tests with nlua

#### Systemd Services - Backup

- **`make backup_enable`** - Enable and start bu_projects systemd timer
- **`make backup_disable`** - Disable and stop bu_projects systemd timer
- **`make backup_status`** - Check bu_projects timer and service status
- **`make backup_test`** - Manually run bu_projects backup service

#### Systemd Services - Toolbox

- **`make tbx_enable`** - Enable and start tbx systemd timer
- **`make tbx_disable`** - Disable and stop tbx systemd timer
- **`make tbx_status`** - Check tbx timer and service status
- **`make tbx_test`** - Manually run tbx service

#### Utilities

- **`make list-configurables`** - List configurable files in container

### How Stow Works

My dotfiles are managed by GNU Stow. 
The `make` command invokes `stow` with the `--dotfiles` option.
This symlinks the dot files from this repository into my home directory.

Using the `--dotfiles` option requires base directory naming conventions:
- Directories containing dot directories or files must be named starting with `dot-`
- Example: `dot-config/` → `~/.config/`, `dot-local/` → `~/.local/`

The `.stow-local-ignore` file at the root excludes files from being stowed:
- README.md and Makefile
- Any `.*` files in the root directory
- Specification and documentation files


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



