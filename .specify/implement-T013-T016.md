# T013-T016: Validation Scripts & Workflow Target

**Date**: 2025-11-13  
**Phase**: Phase 3 - GitHub Actions & Validation  
**Status**: ✅ COMPLETE

## Tasks Implemented

### T014: Create validate-init script (implemented first)
**Purpose**: Verify `make init` created required directories

**Location**: `dot-local/bin/validate-init`

**Checks**:
- `~/.local/bin` exists
- `~/.cache/nvim` exists
- `~/.local/state/nvim` exists

**Exit Codes**:
- `0` = All directories exist (success)
- `1` = One or more directories missing (failure)

**Output**:
```
=== Validating init directories ===

✓ /home/user/.local/bin exists
✓ /home/user/.cache/nvim exists
✓ /home/user/.local/state/nvim exists

✅ All required directories exist
```

### T016: Create validate-stow script (implemented first)
**Purpose**: Verify `make` (stow) created valid symlinks

**Location**: `dot-local/bin/validate-stow`

**Checks**:
- `~/.bashrc` symlink exists and valid
- `~/.config/nvim` symlink exists and valid
- `~/.config/git` symlink exists and valid
- `~/.local/bin/check-toolbox` symlink exists and valid
- `~/.local/bin/check-tools` symlink exists and valid

**Behavior**:
- ✓ Symlink exists and target valid → success
- ✗ Symlink missing → error
- ✗ Symlink broken (target missing) → error
- ⚠ Path exists but not symlink → warning (doesn't fail)

**Exit Codes**:
- `0` = All symlinks valid (success)
- `1` = One or more symlinks missing/broken (failure)

**Output**:
```
=== Validating stow symlinks ===

✓ /home/user/.bashrc → /home/user/Projects/dots/dot-bashrc
✓ /home/user/.config/nvim → /home/user/Projects/dots/dot-config/nvim
✓ /home/user/.config/git → /home/user/Projects/dots/dot-config/git
✓ /home/user/.local/bin/check-toolbox → /home/user/Projects/dots/dot-local/bin/check-toolbox
✓ /home/user/.local/bin/check-tools → /home/user/Projects/dots/dot-local/bin/check-tools

✅ All required symlinks are valid
```

### T013/T015: Create workflow-validate Makefile target
**Purpose**: Single CI-only target that runs init + stow + validation

**Location**: `Makefile` (after `check-tools` target)

**Pattern**: Workflow Target (from Makefile Style Guide)
```makefile
workflow-validate: ## Run validation checks (GitHub Actions only)
ifdef GITHUB_ACTIONS
    echo '##[ $@ ]##'
    echo 'Running make init...'
    $(MAKE) init
    echo ''
    echo 'Validating init directories...'
    dot-local/bin/validate-init
    echo ''
    echo 'Running make (stow)...'
    $(MAKE) default
    echo ''
    echo 'Validating stow symlinks...'
    dot-local/bin/validate-stow
    echo ''
    echo '✅ Workflow validation completed'
endif
```

**Key Features**:
- `ifdef GITHUB_ACTIONS` → Runs only in CI
- Calls `$(MAKE) init` → Runs init target
- Calls `validate-init` → Verifies directories
- Calls `$(MAKE) default` → Runs stow deployment
- Calls `validate-stow` → Verifies symlinks
- Sequential execution with progress messages

**Local Behavior**:
```bash
# Local (not in GitHub Actions)
make workflow-validate
# Does nothing - target body skipped
```

**CI Behavior**:
```bash
# In GitHub Actions (GITHUB_ACTIONS=true)
make workflow-validate
##[ workflow-validate ]##
Running make init...
# ... init output ...
Validating init directories...
✓ Directories exist
Running make (stow)...
# ... stow output ...
Validating stow symlinks...
✓ Symlinks valid
✅ Workflow validation completed
```

## Workflow Integration

### Updated: `.github/workflows/default.yml`

**Added Step** (after Run make check-tools):
```yaml
- name: Run workflow validation
  run: |
    echo "=== Running workflow-validate target inside toolbox ==="
    toolbox run --container tbx-coding bash -c "cd $PWD && make workflow-validate"
```

**Complete Workflow Steps**:
1. Checkout repository
2. Cache toolbox image (caching layer)
3. Setup toolbox (pull, create, verify)
4. Verify toolbox detection (script)
5. Verify required tools (script)
6. Test repository root (script)
7. Run make check-toolbox
8. Run make check-tools
9. **Run workflow validation** ← NEW
   - make init + validate-init
   - make (stow) + validate-stow

## Design Decisions

### Why Validation Scripts First?

**Reusability**:
- Can be called from Makefile
- Can be run manually for debugging
- Can be used in other workflows
- Independent of Make infrastructure

**Testability**:
```bash
# Test locally
./dot-local/bin/validate-init
./dot-local/bin/validate-stow

# Test in Makefile
make workflow-validate  # (in CI only)
```

### Why Single Makefile Target?

**Simplicity**:
- One target instead of two (T013 + T015)
- Clear workflow: init → validate → stow → validate
- Follows DRY principle

**Workflow Pattern**:
- Uses `ifdef GITHUB_ACTIONS` from style guide
- CI-only execution prevents accidental local runs
- Consistent with project conventions

**Maintainability**:
- Single point of truth for validation flow
- Easy to extend (add more validation steps)
- Clear structure for future additions

### Why Not Separate Workflow Steps?

**Alternative Considered**:
```yaml
# Option A: Separate steps (more verbose)
- name: Run make init
  run: make init
- name: Validate init
  run: validate-init
- name: Run make stow
  run: make
- name: Validate stow
  run: validate-stow

# Option B: Single target (chosen)
- name: Run workflow validation
  run: make workflow-validate
```

**Why Option B Better**:
- ✅ Less workflow YAML duplication
- ✅ Validation logic in Makefile (versioned with code)
- ✅ Easy to run same tests locally (with GITHUB_ACTIONS set)
- ✅ Single failure point vs four separate steps

## Testing

### Local Testing (Scripts)

```bash
# From repository root (in toolbox)

# Test validate-init
make init
dot-local/bin/validate-init

# Test validate-stow
make
dot-local/bin/validate-stow
```

### Local Testing (Makefile Target)

```bash
# Target won't run locally (not in GitHub Actions)
make workflow-validate
# (no output - ifdef GITHUB_ACTIONS is false)

# Force run for testing
GITHUB_ACTIONS=true make workflow-validate
# Runs complete validation flow
```

### CI Testing

```bash
# Trigger workflow
dot-local/bin/gh-test-workflow

# Watch execution
gh run watch --repo grantmacken/dots

# View in browser
gh run view --web --repo grantmacken/dots
```

## Expected CI Behavior

### Success Flow

```
1. Setup toolbox ✅
2. Check toolbox detection ✅
3. Check tools ✅
4. Run workflow validation:
   ├─ make init
   │  ├─ Create directories
   │  └─ ✅ Directories created
   ├─ validate-init
   │  └─ ✅ All directories exist
   ├─ make (stow)
   │  ├─ Create symlinks
   │  └─ ✅ Symlinks created
   └─ validate-stow
      └─ ✅ All symlinks valid
✅ Workflow completed
```

### Failure Scenarios

**Init Fails**:
```
make init → Error creating directory
❌ Workflow fails at init step
```

**Directory Validation Fails**:
```
make init → Success
validate-init → ✗ /home/user/.cache/nvim missing
❌ Workflow fails at validation
```

**Stow Fails**:
```
make init → ✅
validate-init → ✅
make (stow) → Error: conflict with existing file
❌ Workflow fails at stow step
```

**Symlink Validation Fails**:
```
make → ✅
validate-stow → ✗ ~/.bashrc is broken
❌ Workflow fails at validation
```

## Phase 3 Progress

| Task | Status | Deliverable |
|------|--------|-------------|
| T010 | ✅ | Workflow setup + trigger script |
| T011 | ✅ | make check-toolbox job |
| T012 | ✅ | make check-tools job |
| T013 | ✅ | **make init + validation** |
| T014 | ✅ | **validate-init script** |
| T015 | ✅ | **make stow + validation** |
| T016 | ✅ | **validate-stow script** |
| T017 | ⏳ | systemd status testing |
| T018 | ⏳ | make verify testing |
| T019 | ⏳ | Neovim launch test |
| T020 | ⏳ | Workflow dispatch test |
| T021 | ⏳ | Documentation |
| T022-gh | ⏳ | Local testing |

**7/13 tasks complete (54%)**

## Files Modified

- `dot-local/bin/validate-init` - Created
- `dot-local/bin/validate-stow` - Created
- `Makefile` - Added workflow-validate target
- `.github/workflows/default.yml` - Added workflow validation step
- `.specify/001-tasks.md` - Marked T013-T016 complete

## Next Steps

### Immediate (T017-T019):
- T017: Test systemd status targets
- T018: Test `make verify`
- T019: Test Neovim launch

### Pattern for Future Tasks:
1. Create validation script (if needed)
2. Add to workflow-validate or create new workflow target
3. Update workflow YAML
4. Test in CI

## References

- Makefile Style Guide: `.specify/makefile-style-guide.md`
- Workflow Architecture: `.specify/workflow-architecture-change.md`
- Previous tasks: `.specify/implement-T010.md`, `.specify/implement-T011-T012.md`

---

**Implementation Date**: 2025-11-13  
**Tasks Status**: ✅ COMPLETE  
**Next Tasks**: T017-T019 - Additional validation
