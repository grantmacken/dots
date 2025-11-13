# Feature Specification: Dotfiles Management System

**Feature Branch**: `main`  
**Created**: 2025-11-13  
**Status**: Active

## User Scenarios & Testing

### User Story 1 - Deploy Neovim Configuration (Priority: P1)

As a developer, I want to deploy my Neovim configuration files from this repository to my home directory so I can use my personalized editor setup from within my toolbox.

**Why this priority**: Core functionality - Neovim is the primary focus of this dotfiles project.

**Independent Test**: From toolbox, run `make` to deploy configs, then launch Neovim and verify plugins and settings load correctly.

**Acceptance Scenarios**:

1. **Given** fresh system with toolbox, **When** `make` is executed from toolbox, **Then** Neovim config files are symlinked from `dot-config/nvim/` to `~/.config/nvim/`
2. **Given** existing config changes, **When** `make` is run again from toolbox, **Then** changes propagate without breaking existing symlinks

---

### User Story 2 - Orchestrate System Tasks (Priority: P2)

As a system administrator, I want to use Makefile targets from within my toolbox to manage systemd services, timers, and podman quadlets so I can automate my workflow.

**Why this priority**: Provides automation layer on top of deployed configs.

**Independent Test**: From toolbox, run `make <target>_status` and verify service/timer/quadlet state is reported correctly.

**Acceptance Scenarios**:

1. **Given** systemd unit or quadlet defined in `dot-config/systemd/user/` or `dot-config/containers/`, **When** `make <unit>_enable` runs from toolbox, **Then** unit is enabled and started on host
2. **Given** enabled service or quadlet, **When** `make <unit>_status` runs from toolbox, **Then** current state is displayed

---

### User Story 3 - Manage Configuration in Git (Priority: P3)

As a user, I want to version control my dotfiles and track changes over time from within my toolbox so I can revert mistakes and sync across machines.

**Why this priority**: Essential for multi-machine setup and change history.

**Independent Test**: From toolbox, modify config, commit, push, then pull on another machine and verify changes applied.

**Acceptance Scenarios**:

1. **Given** config change in `dot-config/`, **When** committed and pushed from toolbox, **Then** change is tracked in Git history
2. **Given** new machine with toolbox, **When** repository is cloned and `make` runs from toolbox, **Then** all configs deploy successfully

---

## Clarifications

### Session 2025-11-13

- Q: Edge case - When `make` encounters existing non-symlink files at target locations (e.g., `~/.config/nvim/` already exists), what should the deployment behavior be? → A: Abort deployment with error message and require manual resolution
- Q: When system detects broken symlinks (pointing to deleted source files in `dot-*` directories), what should the handling behavior be? → A: Abort deployment if any broken symlinks detected
- Q: When Makefile targets are invoked outside the repository root directory, what should the behavior be? → A: Display error message and exit without executing target
- Q: When Makefile targets interact with systemd (enable/disable/status), what should the maximum timeout be before considering the operation failed? → A: Maximum 30 seconds timeout
- Q: For Neovim configuration success criteria (SC-002), what is the maximum number of plugins that should load successfully to be considered a valid test? → A: max 20

### Edge Cases

- When existing non-symlink files exist at symlink targets, system MUST abort deployment with error message and require manual resolution
- System MUST abort deployment if broken symlinks are detected pointing to deleted source files
- Makefile targets invoked outside repository root MUST display error and exit without execution

## Requirements

### Functional Requirements

- **FR-001**: System MUST deploy config files via GNU Stow symlinks from toolbox
- **FR-002**: System MUST preserve idempotency - running `make` multiple times from toolbox is safe
- **FR-003**: System MUST provide Makefile targets executable from toolbox for common tasks (enable, disable, status) for systemd units and quadlets
- **FR-004**: All CLI tools (Stow, Git, Make) MUST run from within toolbox, not host
- **FR-005**: Neovim config MUST use numbered plugin files `{NN}_name.lua` loading sequentially
- **FR-006**: Neovim Lua modules MUST use LuaCATS annotations
- **FR-007**: System MUST NOT allow symlinks inside `dot-config/systemd/user/` or `dot-config/containers/`
- **FR-008**: System MUST isolate development tools in toolbox containers, not host
- **FR-009**: System MUST abort deployment and display error when non-symlink files exist at target locations
- **FR-010**: System MUST abort deployment if broken symlinks are detected
- **FR-011**: Makefile targets MUST verify execution from repository root and exit with error if invoked elsewhere
- **FR-012**: Systemd operations (enable/disable/status) and quadlet operations MUST timeout after 30 seconds maximum

### Key Entities

- **Dotfile Source**: Files in `dot-config/`, `dot-local/`, `dot-bashrc.d/` managed by Stow
- **Symlink Target**: User home directory locations like `~/.config/`, `~/.local/`
- **Makefile Target**: Task definitions for orchestration (enable, disable, status, test)
- **Systemd Unit**: Service/timer definitions in `dot-config/systemd/user/`
- **Podman Quadlet**: Container/volume/network quadlet definitions in `dot-config/containers/systemd/`
- **Neovim Config**: Lua files in `dot-config/nvim/` (init.lua, plugin/*.lua, lua/*/init.lua)

## Success Criteria

### Measurable Outcomes

- **SC-001**: User can deploy full config to fresh system with single `make` command from toolbox
- **SC-002**: Neovim launches successfully from toolbox with all plugins (maximum 20) and LSP configs working
- **SC-003**: All Makefile targets execute without errors from toolbox on clean system
- **SC-004**: No manual symlink creation required - Stow handles all deployment from toolbox
- **SC-005**: No CLI tools installed on host - all operations run from toolbox environment
