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

**Toolbox Container**:
- Container name: `tbx-coding`
- Container image: `ghcr.io/grantmacken/tbx-coding:latest`
- Required tools (included in image):
  - GNU Stow 2.4.0+ (required for proper symlink handling, see https://github.com/aspiers/stow/issues/33)
  - GNU Make 4.0+
  - Git 2.30+
  - Neovim 0.9+ with Lua support
  - systemctl (systemd 245+)

## Toolbox Setup

Before using these dotfiles, you need to create and enter the tbx-coding toolbox container:

```sh
# Pull the toolbox image
toolbox create --image ghcr.io/grantmacken/tbx-coding:latest tbx-coding

# Enter the toolbox
toolbox enter tbx-coding

# Verify you're in the correct toolbox
cat /run/.containerenv | grep "tbx-coding"

# Check that required tools are available
make check-tools
```

All subsequent commands in this README assume you're running inside the tbx-coding toolbox unless otherwise stated.

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

There is difficulty of running a toolbox container inside the GitHub actions runner.
So what I try to do with GitHub is mimic the toolbox environment in GitHub actions by adding the CLI tools,
I use in my toolbox container. Each tool I use may have a configuration file.
For example, Neovim requires a configuration file at `~/.config/nvim/init.vim`.
These configuration files are provided in the `dot-config/` directory.
This allows me to test the stow deployment of my dot files in an environment
that mimics my toolbox container without actually running a toolbox container.


### Deployment Instructions

⚠️ **Warning**: I don't recommend using my dot files as-is. They are tailored to my personal preferences and workflow.
However, if you would like to use them as a starting point or reference, you can deploy them into your home directory.

**Prerequisites**:
1. Create tbx-coding toolbox (see [Toolbox Setup](#toolbox-setup))
2. Enter the toolbox: `toolbox enter tbx-coding`
3. Ensure no conflicting configs exist in `~/.config/`, `~/.local/`, etc.

**Fresh Deployment**:

```sh
# Clone the repository
git clone https://github.com/grantmacken/dots.git ~/Projects/dots
cd ~/Projects/dots

# Enter toolbox (must be in tbx-coding)
toolbox enter tbx-coding

# Verify environment
make check-toolbox
make check-tools

# Verify deployment will work (dry-run)
make verify

# Create directories and deploy
make init  # creates required directories
make       # symlinks dot files via stow

# Verify deployment succeeded
make validate-setup

# Verify Neovim configuration
make nvim-verify
```

**What gets deployed**:
- `dot-config/` → `~/.config/` (Neovim, systemd, containers configs)
- `dot-local/bin/` → `~/.local/bin/` (executable scripts)
- `dot-bashrc.d/` → `~/.bashrc.d/` (bash configuration snippets)

**What to verify after deployment**:
```sh
# Check symlinks created correctly
ls -la ~/.config/nvim  # should point to ~/Projects/dots/dot-config/nvim

# Test Neovim launches
nvim --headless +q  # should exit without errors

# Check systemd units deployed
ls -la ~/.config/systemd/user/
```

### Updating Deployed Configurations

When you modify configurations, always edit files in `dot-*` directories, not in `~`:

```sh
# Example: Modifying Neovim config
cd ~/Projects/dots
toolbox enter tbx-coding

# Edit source files in dot-config/
nvim dot-config/nvim/init.lua

# Redeploy (safe to run multiple times - idempotent)
make

# Test changes
nvim

# If issues occur, check verification
make verify
make nvim-verify
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

#### Systemd Services

The Makefile provides targets for managing systemd user units from within the toolbox.
These operations affect the host system's systemd user session.

**Backup Service** (`bu_projects`):
- Runs `~/.local/bin/bu_projects` script to backup Projects directory
- Timer: Weekly backups on Mondays at 10:00 AM

**Toolbox Service** (`tbx`):
- Runs toolbox reset and Ptyxis terminal configuration
- Timer: Configurable schedule for toolbox maintenance

**Available Targets**:

- **`make backup_enable`** - Enable and start bu_projects systemd timer
- **`make backup_disable`** - Disable and stop bu_projects systemd timer
- **`make backup_status`** - Check bu_projects timer and service status
- **`make backup_test`** - Manually run bu_projects backup service
- **`make tbx_enable`** - Enable and start tbx systemd timer
- **`make tbx_disable`** - Disable and stop tbx systemd timer
- **`make tbx_status`** - Check tbx timer and service status
- **`make tbx_test`** - Manually run tbx service

**Pattern Rules for New Units**:

The Makefile includes pattern rules for managing any systemd unit. To add a new unit:

1. Create unit files in `dot-config/systemd/user/`:
   - `myunit.service` - The service definition
   - `myunit.timer` - The timer definition (optional)

2. Deploy with `make` (Stow will symlink them to `~/.config/systemd/user/`)

3. Use the pattern rules:
   - **`make myunit_enable`** - Enable and start the timer
   - **`make myunit_disable`** - Disable and stop the timer
   - **`make myunit_status`** - Check timer and service status
   - **`make myunit_test`** - Manually run the service once

#### Podman Quadlets

Quadlet files in `dot-config/containers/systemd/` are deployed to `~/.config/containers/systemd/`.
Systemd reads these during boot and when `systemctl daemon-reload` is run.

**Supported Quadlet Types**:
- `.container` - Container definitions
- `.volume` - Volume definitions
- `.network` - Network definitions
- `.build` - Build instructions
- `.image` - Image pull definitions

Currently, no quadlets are configured. To add quadlets, place `.container`, `.volume`, 
`.network`, `.build`, or `.image` files in `dot-config/containers/systemd/`, then run `make` to deploy.

#### Utilities

- **`make git-status`** - Show git status and recent commits
- **`make list-configurables`** - TODO! List configurable files in container

### Git Workflow

This repository uses Git for version control of all dotfile configurations.
All Git operations work from within the toolbox container.

#### Fresh Clone Workflow

To set up dotfiles on a new system:

```sh
# Clone the repository
git clone git@github.com:grantmacken/dots.git ~/Projects/dots
cd ~/Projects/dots

# Enter toolbox (or create if not exists)
toolbox enter tbx-coding

# Inside toolbox: Initialize and deploy
make init  # Creates required directories in ~
make       # Deploys dotfiles via Stow (symlinks to ~)

# Verify deployment
make verify

# Start using Neovim
nvim
```

#### Making Configuration Changes

When modifying configurations, always edit files in `dot-*` directories, not the symlinked files in `~`:

```sh
# Edit source files in dot-config/
vim dot-config/nvim/init.lua

# Test changes
make        # Re-stow (safe to run multiple times)
nvim        # Verify changes work

# Check status and commit
make git-status
git add dot-config/nvim/init.lua
git commit -m "nvim: adjust init.lua settings"
git push upstream main
```

#### Important Git Guidelines

1. **Never edit files in `~` directly** - They are symlinks managed by Stow
2. **Edit in `dot-*` directories** - These are the source of truth
3. **No symlinks in dot-config/systemd/user/** - Only actual unit files
4. **No symlinks in dot-config/containers/** - Only actual quadlet files
5. **Test before committing** - Run `make verify` to catch conflicts

#### Common Git Commands

All standard Git operations work from the toolbox:

```sh
git status              # Check working tree status
git log --oneline -10   # View recent commits
git diff               # See unstaged changes
git add <file>         # Stage changes
git commit -m "msg"    # Commit changes
git push upstream main # Push to remote
git pull upstream main # Pull from remote
```

Or use the convenience target:

```sh
make git-status        # Show status + recent commits
```

## Success Validation

After deployment, verify the system meets all success criteria:

### SC-001: Clean Deployment
From toolbox, `make` deploys all configs successfully on fresh system.

**Verification**:
```sh
# On fresh system (or in GitHub Actions)
cd ~/Projects/dots
toolbox enter tbx-coding
make init && make
# Should complete without errors
```

### SC-002: Neovim Functions Correctly
Neovim launches from toolbox with all plugins (≤20) and LSP working.

**Verification**:
```sh
make nvim-verify
nvim --headless +"echo 'OK'" +q
# Should show plugin count ≤20, no errors
```

### SC-003: Makefile Targets Work
All Makefile targets execute without errors from toolbox.

**Verification**:
```sh
make verify          # Should pass
make backup_status   # Should show unit status
make git-status      # Should show git info
```

### SC-004: No Manual Symlinks
No manual symlink creation needed - Stow handles everything.

**Verification**:
```sh
# After `make`, symlinks should exist:
ls -la ~/.config/nvim  # → ~/Projects/dots/dot-config/nvim
ls -la ~/.local/bin    # → ~/Projects/dots/dot-local/bin
# No manual `ln -s` commands required
```

### SC-005: No Host CLI Tools
No CLI tools required on host - all in toolbox.

**Verification**:
```sh
# On host (outside toolbox):
# Only podman, toolbox, dconf needed

# In toolbox:
make check-tools
# Should verify: stow, make, git, systemctl, nvim all present
```

### Quick Validation Script

Run all validations at once:
```sh
make verify && \
make nvim-verify && \
make validate-setup && \
echo "✅ All success criteria validated"
```

## Troubleshooting

For error scenarios and solutions, see [docs/error-handling.md](docs/error-handling.md).

Common issues:
- **Stow conflicts**: Run `make verify` first to detect
- **Toolbox not detected**: Ensure running `toolbox enter tbx-coding`
- **Broken symlinks**: Remove and redeploy with `make`
- **Plugin count exceeded**: Max 20 plugins (constitution limit)

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



