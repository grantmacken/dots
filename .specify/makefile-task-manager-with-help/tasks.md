# Tasks: Makefile Task Manager with Help Target

**Input**: Design documents from `.specify/makefile-task-manager-with-help/`
**Prerequisites**: plan.md ✅, quickstart.md ✅

## Execution Flow (main)
```
1. Load plan.md from feature directory
   → ✅ Plan loaded successfully
   → Tech stack: GNU Make 4.x, Bash 5.x, GNU Stow, bash-completion
   → Structure: Dotfiles management (single project)
2. Load optional design documents:
   → quickstart.md: ✅ Loaded - 8 verification scenarios defined
   → research.md: N/A - research incorporated in plan.md
   → data-model.md: N/A - no data models for this feature
   → contracts/: N/A - no API contracts for this feature
3. Generate tasks by category:
   → Setup: Create completion.sh configuration file
   → Core: Modify Makefile target order and descriptions
   → Integration: Deploy via Stow
   → Verification: Manual testing per quickstart.md
   → Polish: Update documentation
4. Apply task rules:
   → Different files = mark [P] for parallel
   → Makefile changes = sequential (same file)
   → Tests before implementation = N/A (configuration feature)
5. Number tasks sequentially (T001, T002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
   → All design decisions have tasks? ✅
   → All quickstart scenarios covered? ✅
   → Constitutional compliance maintained? ✅
9. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact file paths in descriptions

## Path Conventions
- Dotfiles project structure (Stow-based)
- Configuration files: `dot-bashrc.d/`, `Makefile` at repository root
- Deployment via GNU Stow to `~/`

---

## Phase 3.1: Setup
- [ ] **T001** [P] Create `dot-bashrc.d/completion.sh` with bash-completion loader
- [ ] **T002** [P] Verify all existing Makefile targets have appropriate `##` descriptions

## Phase 3.2: Core Implementation
- [ ] **T003** Reorder Makefile: move `help:` target before `default:` target (make help first non-special target)
- [ ] **T004** Update `help:` target description from "show this help" to "show available make targets"
- [ ] **T005** Update `default:` target description from "stow dotfiles" to "install dotfiles (runs init, stow)"

## Phase 3.3: Deployment
- [ ] **T006** Deploy changes via `make delete && make` (stow dotfiles to home directory)
- [ ] **T007** Verify symlinks created: `~/.bashrc.d/completion.sh` exists and points to dotfiles

## Phase 3.4: Verification (from quickstart.md)
- [ ] **T008** Test default target shows help: run `make` with no arguments, verify help output displayed
- [ ] **T009** Test explicit help target: run `make help`, verify identical output to T008
- [ ] **T010** Test tab completion: in toolbox, type `make <TAB><TAB>`, verify target suggestions appear
- [ ] **T011** Test partial completion: type `make bac<TAB>`, verify completes to `backup_` prefix
- [ ] **T012** Test help output format: verify all user-facing targets listed with aligned descriptions
- [ ] **T013** Test persistence in new shell: open new toolbox terminal, verify completion works without manual setup
- [ ] **T014** Test default still executes stow: run `make delete`, then `make`, verify stow operations complete

## Phase 3.5: Polish & Documentation
- [ ] **T015** [P] Update README.md if Makefile usage section needs clarification about help as default
- [ ] **T016** Verify constitution compliance: confirm changes align with all 5 constitutional principles
- [ ] **T017** Git commit with message: "feat: make help default target, add bash completion for make commands"

---

## Dependencies

### Sequential Flow
```
T001, T002 (setup - parallel)
    ↓
T003 (reorder Makefile)
    ↓
T004, T005 (update descriptions - sequential, same file)
    ↓
T006 (deploy via stow)
    ↓
T007 (verify deployment)
    ↓
T008-T014 (verification tests - can run sequentially)
    ↓
T015, T016 (polish - parallel)
    ↓
T017 (commit)
```

### Blocking Relationships
- T003-T005 block T006 (must modify Makefile before deploying)
- T006 blocks T007-T014 (must deploy before testing)
- T008-T014 block T017 (must verify before committing)
- No blockers for T001, T002, T015, T016 (can parallelize)

---

## Parallel Execution Examples

### Round 1: Setup
```bash
# Create completion.sh and audit Makefile simultaneously
Task T001: "Create dot-bashrc.d/completion.sh with bash-completion loader"
Task T002: "Verify all existing Makefile targets have appropriate ## descriptions"
```

### Round 2: Makefile Modifications
```bash
# Must be sequential (same file)
Task T003: "Reorder Makefile: move help: target before default: target"
Task T004: "Update help: target description"
Task T005: "Update default: target description"
```

### Round 3: Polish
```bash
# Final polish tasks can parallelize
Task T015: "Update README.md if needed"
Task T016: "Verify constitution compliance"
```

---

## Task Details

### T001: Create completion.sh [P]
**File**: `dot-bashrc.d/completion.sh`
**Content**:
```bash
# Load bash completion for make and other tools
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi
```
**Why**: Enables bash completion for make commands in toolbox environment
**Constitutional Alignment**: Declarative configuration (Principle I), Toolbox isolation (Principle III)

### T002: Audit Makefile Descriptions [P]
**File**: `Makefile`
**Action**: Review all targets, confirm user-facing ones have `##` descriptions
**Expected**: All targets already compliant (verified in plan.md)
**Why**: Ensures help output completeness

### T003: Reorder Makefile Targets
**File**: `Makefile` (lines 26-36)
**Action**: Cut `help:` target block (lines 32-36), paste before `default:` target (line 26)
**Result**: `help:` becomes first non-special target → becomes default
**Why**: Makes help display the default action when running `make` with no arguments

### T004: Update Help Description
**File**: `Makefile` (line 32 after reordering)
**Change**: `help: ## show this help` → `help: ## show available make targets`
**Why**: More descriptive, clearer purpose statement

### T005: Update Default Description
**File**: `Makefile` (line after help block)
**Change**: `default: # init fonts ## stow dotfiles` → `default: ## install dotfiles (runs init, stow)`
**Why**: Accurately describes what default target actually does (not just stow)

### T006: Deploy via Stow
**Command**: `make delete && make`
**Action**: Remove existing symlinks, re-stow with updated dotfiles
**Result**: `~/.bashrc.d/completion.sh` symlinked from `~/Projects/dots/dot-bashrc.d/completion.sh`
**Why**: Activates changes in user environment

### T007: Verify Deployment
**Commands**:
```bash
ls -la ~/.bashrc.d/completion.sh
readlink ~/.bashrc.d/completion.sh
```
**Expected**: Symlink exists, points to dotfiles directory
**Why**: Confirms stow deployment successful

### T008-T014: Verification Tests
**Source**: `quickstart.md` sections 1-8
**Method**: Manual execution of each verification scenario
**Success Criteria**: All 8 scenarios pass as documented in quickstart.md
**Why**: Validates feature requirements from spec.md

### T015: Update README [P]
**File**: `README.md`
**Action**: Check if Makefile usage section needs updates, add help-as-default note if helpful
**Conditional**: Only update if current README is unclear
**Why**: Keep documentation accurate

### T016: Constitution Compliance [P]
**Document**: `.specify/memory/constitution.md`
**Action**: Final review against all 5 principles
**Expected**: ✅ PASS (already validated in plan.md Constitution Check)
**Why**: Constitutional gate before commit

### T017: Git Commit
**Command**: `git add -A && git commit -m "feat: make help default target, add bash completion for make commands"`
**Action**: Commit all changes with conventional commit message
**Files Changed**: `Makefile`, `dot-bashrc.d/completion.sh`
**Why**: Preserve work in version control

---

## Notes

### Idempotency
- Creating completion.sh is idempotent (file create is atomic)
- Makefile changes are declarative (no scripts to make idempotent)
- Stow operations are inherently idempotent (safe to re-run)

### Rollback Plan
If verification fails:
```bash
git checkout main
make delete && make
```

### Toolbox Considerations
- Completion only works in toolbox (where make commands run)
- Host system unaffected (constitutional compliance)
- Survives toolbox resets (stowed config reloaded on shell init)

### Testing Environment
- Requires toolbox entry: `toolbox enter`
- Test from dotfiles directory: `cd ~/Projects/dots`
- bash-completion package must be installed (already confirmed)

---

## Validation Checklist
*GATE: Checked before marking tasks complete*

- [x] All design decisions from plan.md have corresponding tasks
- [x] All quickstart.md scenarios covered in verification tasks (T008-T014)
- [x] Parallel tasks truly independent (T001, T002 different files; T015, T016 non-conflicting)
- [x] Each task specifies exact file path or command
- [x] No task modifies same file as another [P] task
- [x] Constitutional principles maintained throughout
- [x] Deployment via Stow (constitutional requirement)
- [x] Makefile remains primary orchestration layer (constitutional requirement)

---

**Generated**: 2025-01-10  
**Total Tasks**: 17  
**Estimated Completion Time**: 30-45 minutes  
**Complexity**: Low (configuration changes only)
