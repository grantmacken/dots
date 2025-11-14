# Dotfiles Constitution

## Purpose
Manage personal configuration files for CLI tools to ensure they are fit for purpose.

## Core Principles

1. **Config Quality** - Configurations must work correctly for their intended tools
2. **Stow-Based Management** - All configs deployed via GNU Stow symlink management
3. **Makefile Orchestration** - Tasks automated through Makefile targets
4. **Systemd Automation** - Background tasks via systemd user units and quadlets
5. **Neovim-Centric** - Primary focus on Neovim editor configuration
6. **Git-Controlled** - All configs version-controlled outside containers

## Constraints

1. **Host is Fedora Silverblue** - Atomic/immutable OS; minimal host modifications
2. **Toolbox for CLI Tools** - Development tools run in toolbox (not host)
3. **Cannot Replicate Full Environment** - GitHub Actions tests basic deployment only
4. **Configs Managed Outside Container** - Dotfiles repo is on host, deployed via Stow

## Success Criteria

- Configs deploy without conflicts via `make init && make`
- Neovim config is functional and well-structured
- Systemd units activate correctly
- Makefile targets execute successfully
- Changes are reversible and traceable via git
