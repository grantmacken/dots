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

Although the toolbox container has many of the CLI tools I need,
my dot files are managed in a git repository outside of the container.
This allows me to manage my dot files with git and deploy them into the toolbox container
using GNU Stow.


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

### Note on Toolbox Container

The deployment of the toolbox container is outside the scope of this repository.
This repository is about the management of my dot files and the automation of their deployment and 
not about the toolbox container itself.

### GitHub Actions Testing

I use GitHub actions to test the verify a stow deployment
 of my dot files into a fresh Linux environment. I use the `ubuntu-latest` runner.
 The workflow is defined in `.github/workflows/default.yaml`.
The workflow runs checks to verify:
- `make init` creates required directories
- `make` (stow) deploys without errors

It doesn't test every aspect of my dot files, but it does provide a basic verification
that the stow deployment works in a clean environment.

I would like to do more with GitHub actions but the difficulty of running a toolbox container
inside the GitHub actions runner has limited what I can do so far.

### Deployment Instructions

I don't recommend using my dot files as-is. They are tailored to my personal preferences and workflow.
However, if you would like to use them as a starting point or reference, you can deploy them into your home directory.
To deploy my dot files into your home directory, run the following commands

```sh
git clone https://github.com/grantmacken/dots.git
cd dots
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
- **`make verify`** - Verify deployment would succeed (dry-run conflict check via stow --simulate)
- **`make test`** - TODO! Run Neovim busted tests with nlua

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

- **`make list-configurables`** - TODO! List configurable files in container

<!-- TODO

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


-->

<!-- The systemd timer for the associated 'language server' ensures the *latest* language server is available. -->



