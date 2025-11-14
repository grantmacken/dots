# Implementation Plan: Dotfiles Management System

**Branch**: `main` | **Date**: 2025-11-13 | **Spec**: `.specify/001-dotfiles-management.md`

## Summary

Personal dotfiles management system using GNU Stow for symlink deployment, Makefile for task orchestration, and toolbox isolation (grantmacken/tbx-coding). Primary focus on Neovim configuration with systemd units and podman quadlets support.

## Technical Context

**Language/Version**: Bash 5.x, Lua 5.1 (for Neovim), Make  
**Primary Dependencies**: GNU Stow, systemd, podman, git, neovim  
**Storage**: Git repository with flat file structure  
**Testing**: Manual verification (automated tests deferred)  
**Target Platform**: Fedora Silverblue host + tbx-coding toolbox container (image: ghcr.io/grantmacken/tbx-coding:latest)  
**Project Type**: Configuration management (dotfiles)  
**Performance Goals**: Deployment < 5 seconds, Neovim startup < 500ms  
**Constraints**: Maximum 20 Neovim plugins, 30 second timeout for systemd operations, toolbox-only CLI tools  
**Scale/Scope**: Single user, ~3 directory trees (dot-config, dot-local, dot-bashrc.d), up to 20 systemd units/quadlets

## Constitution Check

✅ **I. Declarative Configuration**: Stow manages symlinks declaratively, scripts are idempotent  
✅ **II. Stow-Based Management**: All deployment via Stow, Makefile orchestrates  
✅ **III. Toolbox Isolation**: All tools run from tbx-coding container (ghcr.io/grantmacken/tbx-coding:latest)  
✅ **IV. Systemd-First Automation**: Systemd units for services, Makefile wraps systemctl  
✅ **Constraints**: No symlinks in dot-config/systemd/user or dot-config/containers, max 20 plugins enforced

## Project Structure

### Documentation

```text
.specify/
├── 001-dotfiles-management.md    # Feature spec
├── memory/
│   └── constitution.md           # Project constitution
└── templates/                    # Spec Kit templates
```

### Source Code

```text
dot-config/                       # Stow package for ~/.config/
├── nvim/
│   ├── init.lua                  # Neovim entry point
│   ├── lua/
│   │   └── {module}/             # Lua modules (e.g., alt/, show/)
│   │       └── init.lua
│   ├── plugin/
│   │   └── {NN}_{name}.lua      # Sequential plugin configs (01-20)
│   └── tests/                    # Neovim test specs
│       └── *_spec.lua
├── systemd/
│   └── user/                     # Systemd user units
│       ├── *.service
│       └── *.timer
└── containers/
    └── systemd/                  # Podman quadlets
        ├── *.container
        ├── *.volume
        └── *.network

dot-local/                        # Stow package for ~/.local/
└── bin/                          # Executable scripts
    └── *.sh

dot-bashrc.d/                     # Bash configuration snippets
└── *.sh

Makefile                          # Task orchestration
├── default target: deploy configs
├── *_enable: enable systemd units/quadlets
├── *_disable: disable systemd units/quadlets
└── *_status: check unit status

.github/
├── copilot-instructions.md       # AI assistant guidance
└── prompts/                      # Spec Kit commands
```

**Structure Decision**: Using Stow's package-based structure where each `dot-*` directory maps to a home directory location. This aligns with Stow conventions and maintains clear separation between different configuration domains (config files, local binaries, bash snippets).

## Phase 0: Research

### 0.1 Toolbox Environment Validation
- **Goal**: Verify execution within tbx-coding toolbox and document environment
- **Output**: Scripts for toolbox detection and tool version verification
- **Acceptance**: Can detect toolbox context and verify required tools available: GNU Stow 2.4.0+, GNU Make 4.0+, Git 2.30+, systemctl (systemd 245+), Neovim 0.9+
- **Status**: ✅ Complete (R001-R002)

**Note**: Makefile target testing (make init, make stow) moved to Phase 6 GitHub Actions. Using workflow_dispatch allows clean environment testing without local disruption.

## Phase 1: Design & Contracts

### 1.1 Toolbox Detection & Guards
- **Deliverable**: Toolbox detection function and documentation
- **Contracts**:
  - Function to detect if running inside toolbox (check `/run/.containerenv` file per Fedora documentation)
  - Parse `/run/.containerenv` to verify container name is "tbx-coding" and image matches
  - Document required toolbox: tbx-coding (ghcr.io/grantmacken/tbx-coding:latest)
  - Optional: Add Makefile guard to warn/fail if not in toolbox

### 1.2 Directory Validation Scripts
- **Deliverable**: Validation helpers for deployment verification
- **Contracts**:
  - Script/function to verify `make init` directory creation
  - Script/function to verify stow symlinks are valid
  - Script/function to detect conflicts (FR-009) and broken symlinks (FR-010)
  - Suitable for GitHub Actions test execution

### 1.3 GitHub Actions Workflow
- **Deliverable**: `.github/workflows/test-deployment.yml`
- **Contracts**:
  - Workflow tests `make init` creates required directories
  - Workflow tests `make` (stow) deploys without errors
  - Workflow validates Neovim config structure (max 20 plugins)
  - Runs on push/PR to verify changes don't break deployment

### 1.4 Error Handling Enhancement
- **Deliverable**: Enhanced Makefile error handling
- **Contracts**:
  - Repository root detection (FR-011) - add if missing
  - Conflict detection before stow (FR-009)
  - Broken symlink detection (FR-010)
  - 30-second timeout for systemd operations (FR-012) - add if missing
  - Clear error messages for all failure modes

## Phase 2: Implementation Tasks

*Tasks will be generated via `/speckit.tasks` after Phase 1 completion*

## Dependencies & Prerequisites

### Host System
- Fedora Silverblue (immutable OS)
- systemd user session
- podman installed
- Toolbox container: tbx-coding created from ghcr.io/grantmacken/tbx-coding:latest

### Toolbox Container (tbx-coding)
- Container image: ghcr.io/grantmacken/tbx-coding:latest
- GNU Stow 2.4.0+ (required for proper symlink handling, see https://github.com/aspiers/stow/issues/33)
- GNU Make 4.0+
- Git 2.30+
- Neovim 0.9+ with Lua support
- systemctl (for --user operations)

### Repository
- Git initialized with main branch
- Constitution at `.specify/memory/constitution.md`
- Spec at `.specify/001-dotfiles-management.md`

## Success Validation

After implementation, verify:

1. **SC-001**: From toolbox, `make` deploys all configs successfully on fresh system
2. **SC-002**: Neovim launches from toolbox with all plugins (≤20) and LSP working
3. **SC-003**: All Makefile targets execute without errors from toolbox
4. **SC-004**: No manual symlink creation needed
5. **SC-005**: No CLI tools required on host

## Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Stow conflicts on existing files | Deployment fails | Implement dry-run verification step (FR-008) |
| Toolbox can't access host systemd | Automation broken | Test systemctl --user from tbx-coding in Phase 0 |
| Neovim plugin count exceeds 20 | Violates constitution | Document count validation in deployment process |
| Makefile run outside repo | Wrong paths deployed | Add repository root guard to all targets (FR-010) |

## Next Steps

1. Execute Phase 0 research tasks (validate toolbox + Stow integration)
2. Complete Phase 1 design (finalize Makefile contracts)
3. Run `/speckit.tasks` to generate implementation task breakdown
4. Begin implementation following task priority order
