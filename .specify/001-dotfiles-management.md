# Feature Specification: Dotfiles Management System

**Feature Branch**: `main`  
**Created**: 2025-11-13  
**Status**: Active

## User Scenarios & Testing

### User Story 1 - Neovim Config Loads Correctly (Priority: P1)

As a developer, I want my Neovim configuration to load correctly with all plugins and LSP settings functioning so I can have a productive editing environment.

**Why this priority**: Core functionality - Neovim config quality is the primary focus.

**Independent Test**: Launch Neovim and verify plugins load, keymaps work, LSP attaches, and no errors appear.

**Acceptance Scenarios**:

1. **Given** Neovim config deployed, **When** Neovim launches, **Then** all plugins initialize without errors
2. **Given** Lua modules with LuaCATS annotations, **When** editing code, **Then** LSP provides correct completions and diagnostics
3. **Given** numbered plugin files, **When** Neovim starts, **Then** plugins load in sequential order after init.lua

---

### User Story 2 - Systemd Units Function Correctly (Priority: P2)

As a system administrator, I want my systemd units, timers, and podman quadlets to activate and perform their intended tasks so my automated workflows function reliably.

**Why this priority**: Automation depends on correctly configured units.

**Independent Test**: Enable unit, verify it starts successfully, check logs for errors, confirm expected behavior occurs.

**Acceptance Scenarios**:

1. **Given** systemd unit defined correctly, **When** unit is enabled, **Then** unit starts without errors and performs intended task
2. **Given** timer configured, **When** timer activates, **Then** associated service executes on schedule
3. **Given** podman quadlet defined, **When** quadlet starts, **Then** container runs with correct configuration

---

### User Story 3 - Config Changes Tracked and Deployable (Priority: P3)

As a user, I want to track configuration changes in Git and deploy them reliably so I can maintain version history and sync across machines.

**Why this priority**: Essential for change management and multi-machine setups.

**Independent Test**: Modify config file, commit change, deploy to fresh environment, verify config change is active.

**Acceptance Scenarios**:

1. **Given** config change in `dot-config/`, **When** change is committed, **Then** change is tracked in Git history
2. **Given** cloned repository, **When** configs are deployed, **Then** all configs symlink correctly and function as intended
3. **Given** deployed configs, **When** re-running deployment, **Then** operation is idempotent with no errors

---

## Clarifications

### Session 2025-11-13

- Q: When deployment encounters existing non-symlink files at target locations? → A: Abort with error, require manual resolution
- Q: When broken symlinks are detected? → A: Abort deployment
- Q: When Makefile targets invoked outside repo root? → A: Display error and exit
- Q: Systemd operation timeout? → A: Maximum 30 seconds
- Q: Maximum plugins for Neovim test? → A: max 20

### Session 2025-11-14

- Toolbox (tbx-coding) is development environment constraint, not a primary concern
- Focus is on config quality and fitness-for-purpose, not deployment mechanics
- Tests verify configs work correctly, not where they're executed from

### Edge Cases

- Existing non-symlink files at targets: abort with error
- Broken symlinks detected: abort deployment
- Makefile invoked outside repo root: error and exit

## Requirements

### Functional Requirements

**Deployment & Orchestration**:
- **FR-001**: System MUST deploy config files via GNU Stow symlinks
- **FR-002**: System MUST preserve idempotency - running `make` multiple times is safe
- **FR-003**: System MUST provide Makefile targets for common tasks (enable, disable, status)
- **FR-004**: Development environment is tbx-coding toolbox (ghcr.io/grantmacken/tbx-coding:latest)

**Config Quality**:
- **FR-005**: Neovim config MUST use numbered plugin files `{NN}_name.lua` loading sequentially
- **FR-006**: Neovim Lua modules MUST use LuaCATS annotations
- **FR-007**: Systemd unit and quadlet definitions MUST be actual files, not symlinks
- **FR-008**: Configs MUST be testable for correctness and fitness-for-purpose

**Safety & Validation**:
- **FR-009**: System MUST abort deployment when non-symlink files exist at target locations
- **FR-010**: System MUST abort deployment if broken symlinks are detected
- **FR-011**: Makefile targets MUST verify execution from repository root
- **FR-012**: Systemd operations MUST timeout after 30 seconds maximum

### Key Entities

- **Dotfile Source**: Files in `dot-config/`, `dot-local/`, `dot-bashrc.d/` managed by Stow
- **Symlink Target**: User home directory locations like `~/.config/`, `~/.local/`
- **Makefile Target**: Task definitions for orchestration (enable, disable, status, test)
- **Systemd Unit**: Service/timer definitions in `dot-config/systemd/user/`
- **Podman Quadlet**: Container/volume/network quadlet definitions in `dot-config/containers/systemd/`
- **Neovim Config**: Lua files in `dot-config/nvim/` (init.lua, plugin/*.lua, lua/*/init.lua)
- **Toolbox Container**: tbx-coding container from image ghcr.io/grantmacken/tbx-coding:latest

## Success Criteria

### Measurable Outcomes

- **SC-001**: User can deploy full config to fresh system with single `make` command
- **SC-002**: Neovim launches with all plugins (max 20) loading correctly, LSP functioning, no errors
- **SC-003**: Systemd units and quadlets activate and perform intended tasks successfully
- **SC-004**: All Makefile targets execute without errors
- **SC-005**: No manual symlink creation required - Stow handles all deployment
- **SC-006**: Configs are testable and verifiable for correctness
