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

### 1. `.ONESHELL` - Single Shell Execution
All recipe lines execute in one shell session:
- Enables multi-line shell scripts without backslashes
- Variables persist across lines within a recipe
- Exit codes propagate properly

### 2. `--silent` Flag - No Command Echoing
Commands don't print by default:
- **No `@` prefix needed** on recipe lines
- Use explicit `echo` statements for visibility
- Keeps recipes clean and readable

### 3. Explicit Echo Statements
Show progress with deliberate output:
```makefile
target:
    echo '##[ $@ ]##'        # Target name
    # ... do work ...
    echo '✅ completed task'  # Success
```

### 4. Call Scripts Directly
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

### 5. Toolbox Guards Only Where Needed
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
