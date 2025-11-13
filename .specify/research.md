# Phase 0 Research Findings

**Date**: 2025-11-13  
**Status**: Complete  
**Tasks**: R001-R002

## Summary

Phase 0 research validated the toolbox environment and established detection/verification mechanisms. All required tools in tbx-coding container exceed minimum version requirements.

## R001: Toolbox Detection

**Task**: Check if running inside toolbox by testing for `/run/.containerenv` file (official Fedora method)

### Implementation

Created `dot-local/bin/check-toolbox` script using official Fedora Silverblue method:
- Tests for `/run/.containerenv` file existence
- Validates container name is "tbx-coding"
- Verifies image source: `ghcr.io/grantmacken/tbx-coding:latest`

### Key Findings

1. **Detection Method**: `/run/.containerenv` is more reliable than `$CONTAINER_ID` environment variable
2. **File Format**: Contains structured key-value pairs (engine, name, id, image, etc.)
3. **Always Present**: File exists in all toolbox/podman containers
4. **Official Method**: Documented in Fedora Silverblue tips and tricks

### Container Metadata Example

```bash
engine="podman-5.6.2"
name="tbx-coding"
id="4f6559ab2a7178e2a43a1ddb775cd9b7addbc37ebdadb2e3c095be91febdfd52"
image="ghcr.io/grantmacken/tbx-coding:latest"
imageid="0b293e6fa2ac3d0429fa5cc7e7f1a0b9cc8ad59024f4bbce58ae65ff2237771a"
rootless=1
graphRootMounted=1
```

### Usage in Makefile

```makefile
check-toolbox: ## Verify running in tbx-coding toolbox
    dot-local/bin/check-toolbox
    echo '✓ Running in tbx-coding toolbox'

default: ## install dotfiles (runs init, stow)
    dot-local/bin/check-toolbox
    echo '##[ stow dotfiles ]##'
    # ... rest of recipe
```

**Result**: ✅ Successfully detects toolbox and provides clear error messages when not in correct environment.

## R002: Tool Version Verification

**Task**: Verify toolbox is tbx-coding (image: ghcr.io/grantmacken/tbx-coding:latest) by reading `/run/.containerenv` contents

### Implementation

Created `dot-local/bin/check-tools` script that:
1. Verifies container identity (reuses R001 check)
2. Checks presence of all required CLI tools
3. Validates versions meet minimum requirements
4. Uses semantic version comparison (`sort -V`)
5. Provides color-coded output (green ✓, red ✗, yellow ⚠)

### Required Tools & Versions

From `.specify/001-plan.md` Phase 0.1 acceptance criteria:

| Tool | Minimum Required | Found in tbx-coding | Status | Margin |
|------|-----------------|---------------------|--------|---------|
| GNU Stow | 2.3+ | 2.4.1 | ✅ | +0.1.1 |
| GNU Make | 4.0+ | 4.4 | ✅ | +0.4 |
| Git | 2.30+ | 2.51.1 | ✅ | +21.1 |
| systemd | 245+ | 258 | ✅ | +13 |
| Neovim | 0.9+ | 0.12.0 | ✅ | +0.3 |

### Key Findings

1. **All Tools Exceed Minimums**: tbx-coding image is well-maintained and current
2. **Neovim Very Current**: 0.12.0 is latest stable release (Feb 2024)
3. **Git Modern**: 2.51.1 includes latest security and performance updates
4. **systemd Recent**: 258 is Fedora 41 version with latest features
5. **Version Parsing Reliable**: Using `grep -oP '\d+\.\d+'` pattern works consistently

### Additional Tools Available

Not in requirements but useful:
- **Bash**: 5.3.0 (shell environment)
- **Podman**: 5.6.2 (container management)
- **Busted**: 2.2.0 (Lua testing framework for Neovim tests)

### Version Comparison Strategy

Script uses `sort -V` for semantic version comparison:
```bash
version_gte() {
  printf '%s\n%s\n' "$2" "$1" | sort -V -C
}
```

This handles major.minor.patch correctly without complex parsing.

**Result**: ✅ All tools present and versions exceed minimum requirements. No upgrades needed.

## Makefile Style Guide

During implementation, documented Makefile conventions in `.specify/makefile-style-guide.md`:

### Core Principles

1. **`.ONESHELL`** - All recipe lines execute in single shell
2. **`--silent` flag** - No command echoing, use explicit `echo`
3. **No `@` prefix** - Redundant with `--silent`
4. **Call scripts directly** - Prefer `dot-local/bin/*` over `define` blocks
5. **Toolbox guards** - Only on modification targets, not status queries

### Recipe Pattern

```makefile
target: ## Description
    dot-local/bin/check-toolbox  # If modifies system
    echo '##[ $@ ]##'             # Show target name
    # ... actual work ...
    echo '✅ completed task'       # Success
```

**Impact**: Simplified Makefile by removing unnecessary `check_toolbox` define and `@` prefixes.

## Deferred Items

### Moved to Phase 6 (GitHub Actions)

The following research tasks were intentionally moved to Phase 6:
- **Makefile target testing** (make init, make stow)
- **Directory validation scripts** (validate-init, validate-stow)
- **GitHub Actions workflow implementation**

**Rationale**: Testing deployment requires clean environment. Using existing `.github/workflows/default.yml` workflow_dispatch allows manual triggering without disrupting local system.

## Phase 0 Acceptance Criteria

✅ **Can detect toolbox context** - Via `/run/.containerenv` file  
✅ **Can verify container identity** - Name and image validation  
✅ **Can check tool presence** - All 5 required tools found  
✅ **Can verify tool versions** - All exceed minimums by comfortable margins  
✅ **Provides clear error messages** - Helpful output for troubleshooting

## Next Steps

**Phase 1 Tasks:**
- T001: Create this research.md document ✅ (current task)
- T002: Document existing Makefile targets in README.md
- T003: Identify gaps in current Makefile implementation

**Phase 2 Tasks:**
- T004: Toolbox detection in Makefile ✅ (already implemented)
- T005-T009: Add guards and validation helpers

## References

- Research R001 details: `.specify/research-R001.md`
- Research R002 details: `.specify/research-R002.md`
- Makefile style guide: `.specify/makefile-style-guide.md`
- Plan document: `.specify/001-plan.md`
- Tasks document: `.specify/001-tasks.md`
- Fedora Silverblue toolbox docs: https://docs.fedoraproject.org/en-US/fedora-silverblue/toolbox/
