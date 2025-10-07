# GitHub Copilot CLI Instructions for Dotfiles Project

This project contains personal dotfiles managed through a structured workflow combining Stow-based deployment, systemd automation, and toolbox isolation for Fedora Silverblue.

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
5. **dconf** - GNOME settings management
6. **systemd** - User units (quadlets, services, timers) for automation
7. **Toolbox/Podman** - Containerized development environment

## Configuration Architecture

### Directory Structure
- `dot-config/` - Stow-managed config files (→ `~/.config/`)
- `dot-local/` - Stow-managed local files (→ `~/.local/`)
- `dot-bashrc.d/` - Bash configuration snippets
- `.specify/` - Feature specification and planning system
- `.github/prompts/` - Spec Kit workflow commands

### Key Principles

When working with this codebase, always follow these constitutional principles from `.specify/memory/constitution.md`:

1. **Declarative Configuration**: Use config files over scripts; make scripts idempotent
2. **Stow-Based Management**: All dotfiles via GNU Stow; Makefile orchestrates operations
3. **Toolbox Isolation**: Dev tools in containers, not on host; minimal host modifications
4. **Systemd-First**: Use systemd user units for automation; Makefile wraps systemctl
5. **Neovim-Centric**: LSP configs support offline operation and reproducible setup
6. **Makefile Targets**: Target are tasks that can be run with `make [target]`

## Spec Kit Workflow Integration

This project uses a structured feature development workflow through the Spec Kit system located in `.specify/` and `.github/prompts/`. When developing new features or making significant changes, use these commands:

### Feature Development Commands

#### `/specify [feature-description]`
Creates a new feature specification in `.specify/[feature-name]/spec.md`
- Creates a new git branch for the feature
- Initializes spec from template
- Captures requirements, user stories, and acceptance criteria
- **Usage**: `/specify Add systemd timer for automatic backup rotation`

#### `/clarify [questions]`
Asks clarifying questions about ambiguous requirements
- Must be run before `/plan` if specification is unclear
- Records clarifications in spec.md
- Prevents rework by resolving vague requirements early
- **Usage**: `/clarify What backup retention policy should we use?`

#### `/analyze`
Performs cross-artifact consistency analysis
- Checks spec.md, plan.md, and tasks.md for conflicts
- Validates constitutional compliance
- Identifies ambiguities and coverage gaps
- **Must run after** `/tasks` completes
- **Usage**: `/analyze` (no arguments needed)

#### `/plan [technical-context]`
Generates detailed implementation plan
- Requires completed specification (and clarifications if needed)
- Creates `.specify/[feature-name]/plan.md`
- May generate: `research.md`, `data-model.md`, `contracts/`, `quickstart.md`
- Validates against constitution principles
- **Usage**: `/plan Use existing backup-rotate script as base`

#### `/tasks [context]`
Creates dependency-ordered task breakdown
- Generates `.specify/[feature-name]/tasks.md`
- Marks parallelizable tasks with `[P]`
- Numbers tasks (T001, T002, etc.)
- Orders by dependencies: Setup → Tests → Core → Integration → Polish
- **Usage**: `/tasks Focus on idempotent cleanup logic`

#### `/implement [guidance]`
Executes the implementation plan
- Processes all tasks from tasks.md in dependency order
- Respects sequential vs parallel execution markers
- Marks completed tasks as `[X]` in tasks.md
- Halts on errors; reports progress
- **Usage**: `/implement Test with make delete && make cycle`

#### `/constitution`
Reviews project principles and architectural guidelines
- Displays constitutional requirements
- Use when unsure if change aligns with principles
- All features must validate against constitution
- **Usage**: `/constitution` (no arguments needed)

### Recommended Workflow

For new features:
1. **`/specify`** - Create feature spec with requirements
2. **`/clarify`** - Resolve any ambiguous requirements (if needed)
3. **`/plan`** - Generate implementation plan and design artifacts
4. **`/tasks`** - Break down work into actionable tasks
5. **`/analyze`** - Validate consistency before implementation
6. **`/implement`** - Execute the task list
7. **Verify** - Run `make delete && make` to test clean install

For existing features:
- **`/constitution`** - Verify alignment before changes
- **`/analyze`** - Check impact on existing specs

## Development Standards

All changes must:
- ✅ Maintain compatibility with Fedora Silverblue atomic OS
- ✅ Preserve existing Makefile targets and behavior
- ✅ Test with `make delete && make` for clean install/uninstall
- ✅ Verify systemd units with `*_status` and `*_test` targets
- ✅ Be idempotent and safe to run multiple times
- ✅ Align with constitutional principles

## Common Tasks

### Adding New Dotfiles
1. Place files in `dot-config/` or `dot-local/` with proper structure
2. Update Makefile targets if needed
3. Test: `make delete && make`

### Adding Systemd Units
1. Create unit file in appropriate `dot-config/` subdirectory
2. Add Makefile targets: `*_enable`, `*_disable`, `*_status`, `*_test`
3. Verify: `make [unit]_status`

### Adding Bash Scripts
1. Ensure idempotency (safe to run multiple times)
2. Handle existing state gracefully
3. Add to Makefile if it's part of install/setup
4. Document in README

### Modifying Configuration
1. Edit files in `dot-*` directories (not in `~` directly)
2. Re-stow: `make` or `make [component]`
3. Verify symlinks point correctly

## File Locations

- **Constitution**: `.specify/memory/constitution.md`
- **Spec Templates**: `.specify/templates/`
- **Spec Kit Scripts**: `.specify/scripts/bash/`
- **Feature Specs**: `.specify/[feature-name]/`
- **Prompt Definitions**: `.github/prompts/*.prompt.md`
- **Main Makefile**: `./Makefile`

## Tips for Copilot CLI

- Always check constitution compliance for new features
- Use spec kit workflow for non-trivial changes
- Test changes with full reinstall cycle
- Keep host system minimal; use toolbox for dev tools
- Make scripts idempotent with proper state checking
- Prefer declarative configs over complex bash scripts

---
*These instructions guide Copilot CLI to work effectively with both the dotfiles structure and the Spec Kit feature development workflow.*
