<!--
Sync Impact Report:
Version: 0.0.0 → 1.0.0 (Initial constitution for dotfiles project)
Added sections:
  - Core Principles (5 principles defined)
  - Development Standards
  - User Experience
  - Governance
Templates status:
  ✅ constitution.md - created with all principles defined
  ⚠ plan-template.md - should validate against Stow-based deployment principle
  ⚠ spec-template.md - should check for automation requirements
  ⚠ tasks-template.md - should align with declarative configuration principle
Follow-up: Review dependent templates for alignment with dotfiles-specific principles
-->

# Dotfiles Constitution

## Core Principles

### I. Declarative Configuration
Configuration MUST be expressed declaratively wherever possible. Prefer configuration files over imperative scripts. When imperative code is necessary (bash scripts), it MUST be idempotent and safe to run multiple times. Every script MUST handle existing state gracefully without destructive side effects.

**Rationale**: Declarative configuration is predictable, reviewable, and version-controllable. Idempotency ensures reliability across different system states.

### II. Stow-Based Management
All dotfiles MUST be managed through GNU Stow for symlink deployment. Directory structure follows Stow conventions with `dot-` prefix for dotfile directories. 
The Makefile MUST serve as the primary orchestration layer with clear targets for install, uninstall, and verification operations.

**Rationale**: Stow provides a clean, reversible deployment mechanism.
Centralized Makefile orchestration ensures consistent operations across all components.

### III. Toolbox Isolation
Development tools and CLI applications MUST run within containerized toolboxes (Fedora toolbox/podman).
Host system modifications MUST be minimal and limited to: Stow-managed symlinks, systemd user units, and GNOME dconf settings.
All language runtimes, LSPs, and development tools belong in the toolbox environment.
Common CLI are built into the toolbox, not the host. This includes stow as well as git, curl, wget, fd, rg, jq, etc.
Config files for these tools are the ./dot-config directory managed by stow.

**Rationale**: Atomic OS (Silverblue) requires immutability. Toolbox isolation prevents host contamination while enabling full development capabilities.

### IV. Systemd-First Automation
Background tasks, timers, and service management MUST use systemd user units (services and timers). Quadlets MUST be used for container lifecycle management. All automation MUST be controllable via Makefile targets that wrap systemctl commands with clear enable/disable/status/test operations.

**Rationale**: Systemd provides robust scheduling, logging, and dependency management. User-level units run without root privileges and integrate with session management.

### V. Neovim-Centric Workflow
Configuration prioritizes Neovim as the primary editor. LSP configurations, treesitter parsers, and plugin management MUST support offline operation and reproducible setup. Helper scripts for Neovim diagnostics (`nv_info`, `nv_log`, `nvim_*`) MUST be maintained alongside configuration.

**Rationale**: Editor-first workflow enables consistent development experience. Offline capability and reproducibility are essential for reliability.



## Development Standards

All changes MUST:
- Maintain compatibility with Fedora Silverblue atomic OS model
- Preserve existing Makefile targets and their documented behavior  
- Test with `make delete && make` cycle to verify clean install/uninstall
- Verify systemd units with appropriate `*_status` and `*_test` targets
- Document new scripts in README with clear purpose statements

## User Experience

Configuration changes MUST:
- Preserve user's ability to understand and modify behavior
- Provide clear feedback during operations (echoed task names, completion markers)
- Fail fast with informative error messages on misconfiguration
- Support incremental adoption (users can skip optional components)

## Governance

This constitution supersedes ad-hoc practices. All feature development MUST verify alignment with these principles through the `/constitution` command. Changes requiring principle violations MUST be explicitly justified and documented before implementation.

Amendments to this constitution require:
1. Clear rationale for the change
2. Impact assessment on existing configurations
3. Migration plan if breaking changes occur
4. Version increment following semantic versioning

Complexity in scripts or configuration MUST be justified by specific technical requirements. When in doubt, choose the simpler implementation that aligns with declarative and idempotent principles.

**Version**: 1.0.0 | **Ratified**: 2025-01-10 | **Last Amended**: 2025-01-10
