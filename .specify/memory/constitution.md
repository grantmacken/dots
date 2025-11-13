# Dotfiles Constitution

## Core Principles

### I. Declarative Configuration
Configuration files over imperative scripts. Scripts MUST be idempotent and handle existing state gracefully.

### II. Stow-Based Management
 - All dotfiles deployed via GNU Stow.
 - Makefile orchestrates all operations. 
 - No manual symlinks in `dot-*` directories. 
 - No direct edits in `~`.

### III. Toolbox Isolation
Development tools in containers, not on host. Minimal host system modifications.

### IV. Systemd-First Automation
 - Background tasks and services via systemd user units. 
 - Makefile wraps systemctl commands.

## Constraints

- **No symlinks** in `dot-config/systemd/user/` or `dot-config/containers/` - breaks systemd/podman workflows
- **Never run** `make delete` - destroys local configs
- **Neovim plugins** numbered `{NN}_{name}.lua`, modules as `{name}/init.lua`
- **LuaCATS annotations** required for all Lua modules

## Governance

Constitution supersedes all practices. Changes require version bump and amendment record.

**Version**: 1.0.0 | **Ratified**: 2025-11-13 | **Last Amended**: 2025-11-13
