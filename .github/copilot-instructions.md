# GitHub Copilot CLI Instructions for Dotfiles Project

This project contains personal dotfiles managed through a structured workflow combining 
 - Stow-based deployment,
 - systemd automation, and
 - toolbox isolation for Fedora Silverblue.

## Project Overview

These are dotfiles for a Fedora Silverblue system that prioritizes:
- **Declarative configuration** over imperative scripts
- **Stow-based management** for symlink deployment
- **Toolbox isolation** for development tools (not on host)
- **Systemd-first automation** for background tasks and services
- **Neovim-centric workflow** with LSP and offline-capable setup

## Core Tooling

1. **GNU Stow** - Symlink farm manager for dotfile deployment
2. **Makefile** - Primary orchestration layer for all operations
3. **Git** - Version control and branch-based feature development
4. **Bash Shell scripts** - Idempotent setup and configuration tasks
5. **NLua Scripts** - Neovim configuration and plugin management
5. **dconf** - GNOME settings management
6. **systemd** - User units (quadlets, services, timers) for automation
7. **Toolbox/Podman** - Containerized development environment

## Configuration Architecture

### Directory Structure
- `dot-config/` - Stow-managed config files (→ `~/.config/`)
- `dot-local/` - Stow-managed local files (→ `~/.local/`)
- `dot-bashrc.d/` - Bash configuration snippets
- `.specify/` - Feature specification and planning system
- `.github/prompts/` - Copilot CLI prompt templates

### Key Principles

When working with this codebase, always follow these principles:

Important principles to follow when working with this codebase:

1. **Declarative Configuration**: Use config files over scripts; make scripts idempotent
2. **Stow-Based Management**: All dotfiles via GNU Stow; Makefile orchestrates operations
3. **Toolbox Isolation**: Dev tools in containers, not on host; minimal host modifications
4. **Systemd-First**: Use systemd user units for automation; Makefile wraps systemctl
5. **Neovim-Centric**: LSP configs support offline operation and reproducible setup
6. **Makefile Targets**: Target are tasks that can be run with `make [target]`
7. **No Direct Edits**: Edit files in `dot-*` directories, not in `~` directly
8. **No Manual Symlinks**: Use Stow via Makefile; no symlinks in `dot-*` directories
9. **Review**: After ask in copilot cli prompt, let me review review changes before committing to files
10. **Command line**: when using copilot commandline `-p` flag with the changes can be applied directly to files

- Neovim setup is in `dot-config/nvim/`
  - Lua Modules are in `dot-config/nvim/lua/{name}.lua`. Use LuaCATS annotations for lua code modules @see https://luals.github.io/wiki/annotation
  - Plugin configs are in `dot-config/nvim/plugin/{integer}_{name}.lua` these load in sequential numbered order after `init.lua`
  - Busted specs are nlua files in `dot-config/nvim/tests/`
- Systemd units are in `dot-config/systemd/user/`
- Quadlets for Podman containers are in `dot-config/containers/`
- Bash and nlua scripts are in `dot-local/bin/`


## Common Tasks

### Adding New Dotfiles
1. Place files in `dot-config/` or `dot-local/` with proper structure
2. Update Makefile targets if needed

### Adding Systemd Units Timers and Quadlets
1. Create systemd unit file and timers in appropriate `dot-config/system` subdirectory
2. Create quadlets for containers, volumes etc in appropriate `dot-config/containers` subdirectory
3. Add Makefile targets: `*_enable`, `*_disable`, `*_status`, `*_test`
4. Verify: `make [unit]_status`
5. Commit changes with descriptive messages

### Adding Bash and Lua Scripts
1. Place scripts in `dot-local/bin/`. 
2. Executable permissions are make with make using default target `make`
1. Ensure idempotency (safe to run multiple times)
2. Handle existing state gracefully
3. Add Makefile target for each dot-local/bin/ script if needed
4. Document in README

### Configurations

1. Where possible a configurable executable should have its own directory inside `dot-config/`
2. Configuration files should be seen in the context running the executable inside Neovim terminal inside the toolbox

### Modifying Configuration
1. Edit files in `dot-*` directories (not in `~` directly)
2. Never run `make delete` as these will reset my configs and delete local changes and I will cry
4. Never test changes with `make delete && make` to verify functionality
3. Do not edit files in `~` directly; they are symlinked from `dot-*` directories and managed by Stow
4. Do not add symlinks manually; always use Stow via Makefile
5. Do not add symlinks inside `dot-*` directories; they should only contain source files for Stow.
   This is important, the dot-config/systemd/user/ and dot-config/containers directories should not contain any symlinks.
   They should only contain the actual unit files and container Quadlet definitions.
   Adding symlinks here will break the Systemd and Podman workflows.
5. Commit changes with descriptive messages

### Modifying Neovim Configuration

1. Edit files in `dot-config/nvim/` and subdirectories
2. Use LuaCATS annotations for Lua modules
3. Follow this naming convention `dot-config/nvim/plugin/{number}_{name}.lua` for plugin configurations:
  - number is two digits (e.g. 01, 02, ..., 10, 11, ..., 99)
  - name uses underscores instead of hyphens(e.g. `01_my_plugin.lua`)
  Files loaded in sequential order after `init.lua` so select numbering accordingly 
4. Modules follow this naming convention `dot-config/nvim/lua/{name}/init.lua`:
   - single word name as the directory name 
   - init.lua as the main entry point
   This allows `require("{name}")` to work correctly
5. TODO! Test changes in Neovim terminal inside toolbox

## Tips for Copilot CLI

- Keep host system minimal; use toolbox for development tools
- Make scripts idempotent with proper state checking
- Prefer declarative configs over complex bash scripts

