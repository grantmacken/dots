---
title: Makefile Style Guide
description: Style guide for creating and maintaining Makefiles with GitHub Copilot CLI
category: development
applies_to: makefile
version: 1.0.0
last_updated: 2025-11-18
---

# Makefile Style Guide

<purpose>
This guide defines the coding style and patterns for creating and maintaining Makefiles
in projects managed by GitHub Copilot CLI. Follow these conventions to ensure
consistency, readability, and maintainability across all Makefile-based automation.
</purpose>

## Audience

<audience>
This guide is intended for:
- GitHub Copilot CLI agents creating or modifying Makefiles
- Developers contributing to projects with Makefile-based workflows
- Anyone maintaining build and deployment automation
</audience>

## Core Principles

<principles>
1. **Defensive Configuration**: Use strict shell flags and make settings to catch errors early
2. **Self-Documenting**: Every target must have inline documentation via `##` comments
3. **Idempotency**: Targets should be safe to run multiple times without side effects
4. **Modularity**: Use pattern rules and variables to reduce duplication
5. **User-Friendly**: Provide helpful output with clear status messages and emoji indicators
6. **Error Handling**: Fail fast with appropriate error messages; use `|| true` only when intentional
</principles>

## File Structure

<file_structure>
### Standard Order

1. **File header comment** - Brief description of purpose and scope
2. **Shell configuration** - SHELL, SHELLFLAGS, special targets
3. **Make configuration** - MAKEFLAGS settings
4. **Variables** - Project-specific paths and configuration
5. **Default target** - Primary workflow entry point
6. **Composite targets** - High-level orchestration targets
7. **Primary targets** - Core functionality targets
8. **Pattern rules** - Generic templates (e.g., systemd unit management)
9. **Test targets** - Testing and verification
10. **Validation targets** - Check and verify operations
11. **Utility targets** - Helper and convenience targets
12. **Help target** - Must be last or near last
</file_structure>

## Header and Configuration

<header_configuration>
### File Header

```makefile
# Project Name Makefile
# Brief description of orchestration purpose
# Special environment notes (e.g., toolbox requirements, CI considerations)
```

### Shell Configuration

**Required shell settings for safety:**

```makefile
SHELL=/usr/bin/bash
.SHELLFLAGS := -euo pipefail -c
# -e Exit immediately if a pipeline fails
# -u Error if there are unset variables and parameters
# -o option-name Set the option corresponding to option-name
.ONESHELL:
.DELETE_ON_ERROR:
.SECONDARY:
```

### Make Configuration

**Required make flags:**

```makefile
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --silent
```

**Purpose:**
- `--warn-undefined-variables`: Catch typos in variable references
- `--no-builtin-rules`: Disable implicit rules for predictable behavior
- `--silent`: Suppress recipe echoing (use explicit echo for output)
</header_configuration>

## Variables

<variables>
### Naming Conventions

- **ALL_CAPS**: For user-configurable or important path variables
- **snake_case**: Avoid; use ALL_CAPS for consistency
- **Group related variables**: Together with blank line separation

### Common Patterns

```makefile
# XDG Base Directory paths
CONFIG_HOME := $(HOME)/.config
CACHE_HOME  := $(HOME)/.cache
DATA_HOME   := $(HOME)/.local/share
STATE_HOME  := $(HOME)/.local/state
BIN_HOME    := $(HOME)/.local/bin

# Project-specific paths
PROJECT_DIR := $(HOME)/Projects
SYSTEMD     := $(CONFIG_HOME)/systemd/user
QUADLET     := $(CONFIG_HOME)/containers/systemd
```

### Assignment Operators

- Use `:=` (simple expansion) by default for predictable behavior
- Use `=` (recursive expansion) only when delayed evaluation is explicitly needed
- Align assignment operators for readability when defining related variables
</variables>

## Target Definitions

<target_definitions>
### Target Syntax

```makefile
target-name: dependencies ## Short description for help output
	echo '##[ $@ ]##'
	# Recipe comments explain the "why", not the "what"
	command-one
	command-two
	echo '✅ target completed successfully'
```

### Naming Conventions

- **lowercase-with-hyphens**: Primary convention (e.g., `check-tools`)
- **lowercase_with_underscores**: For systemd/service-related targets (e.g., `backup_enable`)
- **Descriptive names**: Use verb-noun pairs (e.g., `validate-setup`, `list-workflows`)

### Target Documentation

**Every target MUST have inline documentation:**

```makefile
target-name: ## Brief description shown in help output
```

- Keep descriptions under 60 characters
- Start with lowercase verb (e.g., "enable and start", "check status")
- Be specific about what the target does

### Pattern Rules

Use pattern rules to reduce duplication:

```makefile
%_enable: ## enable and start systemd timer (e.g., make myunit_enable)
	echo '##[ $@ ]##'
	systemctl --no-pager --user daemon-reload
	systemctl --no-pager --user enable --now $*.timer
	systemctl --no-pager --user status $*.timer
	echo '✅ $* timer enabled and started'
```

**Pattern rule guidelines:**
- Include example usage in documentation comment
- Use `$*` to reference the stem (matched part)
- Use `$@` for the full target name
- Provide clear success messages with the stem name
</target_definitions>

## Recipe Best Practices

<recipe_best_practices>
### Output Messages

**Start each target with a header:**

```makefile
echo '##[ $@ ]##'
```

This uses `$@` (automatic variable for target name) for consistency.

**End successful targets with a completion message:**

```makefile
echo '✅ target completed successfully'
```

### Comments in Recipes

- Place comments **above** the command they explain
- Explain **why** something is done, not what (code is self-documenting)
- Use blank comment lines to separate logical sections

```makefile
target-name:
	# Reload systemd to pick up unit file changes
	systemctl --no-pager --user daemon-reload
	
	# Enable and start timer immediately
	systemctl --no-pager --user enable --now service.timer
```

### Error Handling

**Intentional error suppression with `|| true`:**

```makefile
# Allow command to fail without stopping make
systemctl --no-pager --user status service.timer || true
```

**Use when:**
- Checking status of potentially non-existent services
- Removing files/directories that may not exist
- Operations that are informational only

**Always document why error suppression is intentional.**

### Command Flags

**Use flags that support non-interactive automation:**

```makefile
# systemd: Use --no-pager to avoid interactive pager
systemctl --no-pager --user status service

# git: Use --no-pager for scriptable output
git --no-pager status

# stow: Use --verbose for informative output
stow --verbose --dotfiles --target ~/ .

# chmod: Use || true when files may not exist yet
chmod +x dot-local/bin/* || true
```

### Conditional Execution

**Use Make conditionals for environment-specific behavior:**

```makefile
target-name:
ifndef GITHUB_ACTIONS
	dot-local/bin/check-toolbox
else
	echo 'Skipping toolbox check in GitHub Actions environment'
endif
```

**Guidelines:**
- Use `ifdef`/`ifndef` for environment variable checks
- Provide clear skip messages for disabled operations
- Indent recipe lines inside conditionals normally
</recipe_best_practices>

## Default and Help Targets

<default_help_targets>
### Default Target

The `default` target should:
- Be the first target defined (after variables)
- Implement the primary workflow
- Be well-documented
- Call other targets as dependencies

```makefile
default: ## install dotfiles (runs init, stow)
	# Verify running from correct location and environment
	dot-local/bin/check-repo-root
ifndef GITHUB_ACTIONS
	dot-local/bin/check-toolbox
endif
	echo '##[ stow dotfiles ]##'
	# Deploy using stow
	stow --verbose --dotfiles --target $${HOME} .
	echo '✅ completed task'
```

### Help Target

**Required implementation pattern:**

```makefile
help: ## show available make targets
	cat $(MAKEFILE_LIST) |
	grep -oP '^[a-zA-Z_-]+:.*?## .*$$' |
	sort |
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
```

**Characteristics:**
- Parses inline `##` documentation from all targets
- Sorts targets alphabetically
- Colorizes target names (cyan) for readability
- Adjust column width (`%-10s`) based on longest target name
</default_help_targets>

## Common Patterns

<common_patterns>
### Composite Targets

**Use dependencies for high-level orchestration:**

```makefile
validate-setup: init-validate stow-validate ## Run full workflow validation (init + stow + validations)
	echo '✅ full workflow validation passed'

init-validate: init validate-init

stow-validate: default validate-stow
```

### Verification Targets

**Create check-* targets for validation:**

```makefile
check-tools: ## Verify required CLI tools and versions
	dot-local/bin/check-tools

check-root: ## Verify running in repo root
	dot-local/bin/check-repo-root

check-symlinks: ## Check for broken symlinks
	dot-local/bin/check-no-symlinks dot-config/systemd/user
	dot-local/bin/check-no-symlinks dot-config/containers/systemd
```

### Service Management Pattern

**For systemd services, provide four targets:**

```makefile
service_enable: ## enable and start service systemd timer
	echo '##[ $@ ]##'
	systemctl --no-pager --user daemon-reload
	systemctl --no-pager --user enable --now service.timer
	systemctl --no-pager --user status service.timer
	echo '✅ service timer enabled and started'

service_disable: ## disable and stop service systemd timer
	echo '##[ $@ ]##'
	systemctl --no-pager --user disable --now service.timer
	echo '✅ service timer disabled and stopped'

service_status: ## check service timer and service status
	echo '##[ $@ ]##'
	systemctl --no-pager --user status service.timer || true
	systemctl --no-pager --user list-timers service.timer
	echo ''
	systemctl --no-pager --user status service.service || true

service_test: ## manually run service
	echo '##[ $@ ]##'
	systemctl --no-pager --user start service.service
	systemctl --no-pager --user status service.service || true
```

### Directory Creation

**Use mkdir -p for idempotent directory creation:**

```makefile
init: ## create required directories
	echo '##[ $@ ]##'
	mkdir -p $(BIN_HOME)
	mkdir -p $(CACHE_HOME)/project
	mkdir -p $(STATE_HOME)/project
	mkdir -p $(DATA_HOME)/project
```
</common_patterns>

## Style Conventions

<style_conventions>
### Indentation

- **Recipes**: Use TAB character (required by Make)
- **Conditional blocks**: Use TAB for recipe lines inside conditionals
- **Variables**: Use spaces for alignment
- **Comments**: Align with TAB for recipe comments

### Spacing

- **Blank lines**: Use ONE blank line between targets
- **Section separators**: Use comments with blank lines before/after

```makefile
#### Verification tasks

check-tools: ## Verify required CLI tools
	dot-local/bin/check-tools

check-root: ## Verify running in repo root
	dot-local/bin/check-repo-root
```

### Comment Style

**Section headers:**

```makefile
#### Pattern rules for systemd units
```

**Inline documentation (for help):**

```makefile
target: ## Brief description
```

**Recipe comments:**

```makefile
	# Explain why this command is necessary
	command-to-run
```

### Quotes

- Use single quotes for shell strings: `echo 'message'`
- Use double quotes only when variable expansion is needed: `echo "var: $VAR"`
- Use `$$` to escape `$` for shell variables in recipes: `$${HOME}`

### Emoji Usage

**Use emoji for visual status indicators:**

- ✅ Success: `echo '✅ completed task'`
- ✓ Verification: `echo '✓ Running in toolbox'`
- ⚠️ Warning: For informational messages
- ❌ Error: For error messages (though Make should fail fast)

**Guidelines:**
- One emoji per message maximum
- Place at start of message
- Use consistently throughout the Makefile
</style_conventions>

## Anti-Patterns

<anti_patterns>
### Avoid These Patterns

**❌ Don't use shell variables without escaping:**

```makefile
# BAD - Make will interpret $HOME at parse time
target:
	echo "Home: $HOME"

# GOOD - Escape for shell evaluation
target:
	echo "Home: $${HOME}"
```

**❌ Don't hardcode paths that could be variables:**

```makefile
# BAD
target:
	mkdir -p ~/.config/project

# GOOD
target:
	mkdir -p $(CONFIG_HOME)/project
```

**❌ Don't silence errors without documentation:**

```makefile
# BAD - Why is this allowed to fail?
target:
	risky-command || true

# GOOD - Document the reason
target:
	# Service may not exist yet on first run
	systemctl --no-pager --user status service || true
```

**❌ Don't use undocumented targets:**

```makefile
# BAD - No help documentation
target:
	command

# GOOD - Always document
target: ## Brief description
	command
```

**❌ Don't chain commands with semicolons:**

```makefile
# BAD - Harder to read and debug
target:
	command-one; command-two; command-three

# GOOD - One command per line
target:
	command-one
	command-two
	command-three
```

**❌ Don't use recursive make without good reason:**

```makefile
# BAD - Unnecessary recursion
target:
	$(MAKE) other-target

# GOOD - Use dependencies
target: other-target
	# Additional commands if needed
```
</anti_patterns>

## Testing Makefiles

<testing>
### Verification Checklist

Before committing a Makefile, verify:

1. **Syntax**: `make --dry-run --warn-undefined-variables`
2. **Help output**: `make help` shows all targets
3. **Default target**: `make` runs the primary workflow
4. **Idempotency**: Running `make` multiple times is safe
5. **Error handling**: Intentional failures use `|| true` with documentation
6. **Dependencies**: Target dependencies are correct
7. **Variables**: All variables are defined before use
8. **Documentation**: Every target has `##` documentation

### Common Issues

**Undefined variables:**
```bash
make --warn-undefined-variables target-name
```

**Dry-run to see what would execute:**
```bash
make --dry-run target-name
```

**Debug variable expansion:**
```bash
make --print-data-base | grep VARIABLE_NAME
```
</testing>

## Examples

<examples>
### Minimal Makefile Template

```makefile
# Project Name Makefile
# Brief description of purpose

SHELL=/usr/bin/bash
.SHELLFLAGS := -euo pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:
.SECONDARY:

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --silent

# Project variables
PROJECT_DIR := $(shell pwd)
BUILD_DIR   := $(PROJECT_DIR)/build

default: build ## build the project

build: ## compile source code
	echo '##[ $@ ]##'
	mkdir -p $(BUILD_DIR)
	# Compile commands here
	echo '✅ build completed'

clean: ## remove build artifacts
	echo '##[ $@ ]##'
	rm -rf $(BUILD_DIR)
	echo '✅ cleaned build directory'

test: build ## run test suite
	echo '##[ $@ ]##'
	# Test commands here
	echo '✅ tests passed'

help: ## show available make targets
	cat $(MAKEFILE_LIST) |
	grep -oP '^[a-zA-Z_-]+:.*?## .*$$' |
	sort |
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
```

### Service Management Example

```makefile
# Service-specific variables
SERVICE_NAME := myservice
SYSTEMD_DIR  := $(HOME)/.config/systemd/user

$(SERVICE_NAME)_enable: ## enable and start myservice timer
	echo '##[ $@ ]##'
	systemctl --no-pager --user daemon-reload
	systemctl --no-pager --user enable --now $(SERVICE_NAME).timer
	systemctl --no-pager --user status $(SERVICE_NAME).timer
	echo '✅ $(SERVICE_NAME) timer enabled'

$(SERVICE_NAME)_disable: ## disable and stop myservice timer
	echo '##[ $@ ]##'
	systemctl --no-pager --user disable --now $(SERVICE_NAME).timer
	echo '✅ $(SERVICE_NAME) timer disabled'

$(SERVICE_NAME)_status: ## check myservice status
	echo '##[ $@ ]##'
	systemctl --no-pager --user status $(SERVICE_NAME).timer || true
	systemctl --no-pager --user list-timers $(SERVICE_NAME).timer
	echo ''
	systemctl --no-pager --user status $(SERVICE_NAME).service || true

$(SERVICE_NAME)_test: ## manually trigger myservice
	echo '##[ $@ ]##'
	systemctl --no-pager --user start $(SERVICE_NAME).service
	systemctl --no-pager --user status $(SERVICE_NAME).service || true
```
</examples>

## Summary

<summary>
When creating or modifying Makefiles with GitHub Copilot CLI:

1. **Always start** with proper shell and make configuration
2. **Define variables** at the top using `:=` assignment
3. **Document every target** with inline `##` comments
4. **Use consistent naming** (lowercase-with-hyphens or lowercase_with_underscores)
5. **Start recipes** with `echo '##[ $@ ]##'` header
6. **End successful recipes** with `echo '✅ completion message'`
7. **Comment the why**, not the what in recipes
8. **Suppress errors intentionally** with `|| true` and documentation
9. **Use pattern rules** to reduce duplication
10. **Provide a help target** that auto-generates from `##` comments
11. **Test thoroughly** with dry-run and verification targets
12. **Make targets idempotent** - safe to run multiple times
</summary>

## References

<references>
- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [Make Best Practices](https://tech.davis-hansson.com/p/make/)
- [Self-Documenting Makefiles](https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
</references>
