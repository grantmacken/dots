# Makefile Style Guide

## Core Characteristics

Based on existing Makefile configuration (lines 1-12):

### Shell Configuration
```makefile
SHELL=/usr/bin/bash
.SHELLFLAGS := -euo pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:
.SECONDARY:

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --silent
```

## Key Principles

### 1. Target Ordering
**Always follow this structure**:
- **First target**: `default` (runs when `make` is invoked without arguments)
- **Middle targets**: All other targets in logical grouping order
- **Last target**: `help` (moved to end to avoid syntax highlighting issues)

```makefile
# ✅ Correct structure
default: ## install dotfiles
    # default behavior...

check-tools: ## verify tools
    # other targets...

# ... more targets ...

help: ## show available make targets
    # help implementation (last!)
```

**Why**:
- `default` must be first to be the default target
- `help` uses shell pipes and regex that can confuse syntax highlighters
- Moving `help` to end keeps editor highlighting clean for main targets

### 2. `.ONESHELL` - Single Shell Execution
All recipe lines execute in one shell session:
- Enables multi-line shell scripts without backslashes
- Variables persist across lines within a recipe
- Exit codes propagate properly

### 3. `--silent` Flag - No Command Echoing
Commands don't print by default:
- **No `@` prefix needed** on recipe lines
- Use explicit `echo` statements for visibility
- Keeps recipes clean and readable

### 4. Explicit Echo Statements
Show progress with deliberate output:
```makefile
target:
    echo '##[ $@ ]##'        # Target name
    # ... do work ...
    echo '✅ completed task'  # Success
```

### 5. Explicit Dependency Chains (Not `$(MAKE)` in recipes)
Use target dependencies instead of calling `$(MAKE)` in recipes:

```makefile
# ✅ Correct - Explicit dependency chain
validate: init-validate stow-validate
    echo '✅ full workflow validation passed'

init-validate: init validate-init

stow-validate: default validate-stow

# ❌ Avoid - Calling $(MAKE) in recipe
validate:
    $(MAKE) init
    $(MAKE) validate-init
    echo '✅ validation passed'
```

**Benefits**:
- Make handles dependency graph properly
- Parallel execution possible (`make -j`)
- Cleaner, more declarative
- Avoids nested make invocations
- Better error propagation

### 6. Call Scripts Directly
Prefer scripts in `dot-local/bin/` over inline shell:
```makefile
# ✅ Good (your style)
check-toolbox: ## Verify running in tbx-coding toolbox
    dot-local/bin/check-toolbox
    echo '✓ Running in tbx-coding toolbox'

# ❌ Avoid (unnecessary)
define check_function
    @if [ test ]; then ...
endef
```

### 7. Conditional Recipe Steps
Use `ifdef`/`ifndef` for conditional recipe steps (not targets):
```makefile
# ✅ Correct - Conditional recipe steps
default:
    dot-local/bin/check-repo-root
ifndef GITHUB_ACTIONS
    dot-local/bin/check-toolbox
endif
    stow --verbose --dotfiles --target ~/ .
```

Common use cases:
- Skip toolbox checks in GitHub Actions
- Skip interactive steps in CI
- Environment-specific behavior

### 8. Toolbox Guards Only Where Needed
Add `dot-local/bin/check-toolbox` to modification targets:
- ✅ Targets that modify files (default, init)
- ✅ Targets that enable/disable services  
- ❌ Status/query targets (*_status, list-*)

## Recipe Pattern

### Standard Target
```makefile
target_name: ## Description for help
    dot-local/bin/check-toolbox  # If modifies system
    echo '##[ $@ ]##'             # Show target name
    # ... actual work ...
    echo '✅ completed task'       # Success indicator
```

### Status/Query Target
```makefile
backup_status: ## check bu_projects timer and service status
    echo '##[ $@ ]##'
    systemctl --no-pager --user status bu_projects.timer || true
    systemctl --no-pager --user list-timers bu_projects.timer
```

### Workflow Target: Run Only On GitHub Actions
```makefile
workflow_checks: ## Run checks only in GitHub Actions
ifdef GITHUB_ACTIONS
    echo '##[ $@ ]##'
    check_toolbox
    check-tools
endif
```

## Scripts in dot-local/bin/

Scripts should be:
1. **Self-contained** - Testable independently
2. **Error-checking** - Handle failures gracefully
3. **Proper exit codes** - 0=success, 1=error
4. **Helpful messages** - Clear output
5. **Safe** - Use `set -euo pipefail`

Makefile just calls them cleanly:
```makefile
check-tools: ## Verify required CLI tools and versions
    dot-local/bin/check-tools
```

## Variables

- Define all path variables at top
- Use `:=` for simple expansion
- Group related variables together

## Comments

- Use `#` for inline comments
- Document non-obvious behavior
- Keep comments brief

## Example from Current Makefile

```makefile
init:
    dot-local/bin/check-toolbox
    echo '##[ $@ ]##'
    mkdir -p $(BIN_HOME)
    mkdir -p $(CACHE_HOME)/nvim
    mkdir -p $(STATE_HOME)/nvim
    chmod +x dot-local/bin/* &>/dev/null || true
```

Clean, readable, and follows all principles!
