---
description: "Task list for Dotfiles Management System implementation"
---

# Tasks: Dotfiles Management System

**Input**: Design documents from `.specify/001-plan.md` and `.specify/001-dotfiles-management.md`
**Prerequisites**: plan.md, spec.md
**Tests**: Deferred - no test framework tasks included per user request

**Organization**: Tasks are grouped by research phase and user story to enable independent implementation.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, R0 for research)
- Include exact file paths in descriptions

## Path Conventions

- Dotfiles structure: `dot-config/`, `dot-local/`, `dot-bashrc.d/` as Stow packages
- Toolbox: tbx-coding container (image: ghcr.io/grantmacken/tbx-coding:latest) for all operations
- Makefile at repository root

---

## Phase 0: Research Tasks

**Purpose**: Validate toolbox environment and existing Makefile works correctly

**⚠️ CRITICAL**: Focus on verification, not building from scratch

### 0.1 Toolbox Environment Validation

- [x] R001 [R0] Check if running inside toolbox by testing for `/run/.containerenv` file (official Fedora method)
- [x] R002 [R0] Verify toolbox is tbx-coding (image: ghcr.io/grantmacken/tbx-coding:latest) by reading `/run/.containerenv` contents

**Acceptance**: Can detect toolbox and verify all required CLI tools available

**Checkpoint**: Phase 0 Research Complete - toolbox validation working

**Note**: Makefile target testing (make init, make stow) moved to Phase 6 GitHub Actions workflow. Testing with workflow_dispatch allows clean environment testing without disturbing local system.

---

## Phase 1: Setup (Documentation & Planning)

**Purpose**: Document existing system and plan enhancements

- [x] T001 Create `.specify/research.md` documenting Phase 0 findings
- [x] T002 Document existing Makefile targets in README.md
- [x] T003 Identify gaps: missing guards, timeout handling, conflict detection

**Checkpoint**: Phase 1 Complete - Documentation and gap analysis done

---

## Phase 2: Foundational (Enhancements to Existing Makefile)

**Purpose**: Add safety guards and validation to existing Makefile

**⚠️ CRITICAL**: Enhance, don't replace working Makefile

- [x] T004 Add toolbox detection helper function to Makefile: check `/run/.containerenv` exists and contains `name="tbx-coding"`
- [x] T005 Add repository root check to Makefile (FR-010)
- [x] T006 Add `make verify` target: use `stow --simulate` for conflicts (FR-008), check no symlinks in systemd/containers dirs (FR-007)
- [x] T007 [P] Add broken symlink detection script in `dot-local/bin/check-symlinks`
- [x] T008 [P] Add 30-second timeout wrapper for systemd operations (FR-011) - **SKIPPED** (systemd has built-in timeouts)
- [x] T009 Test enhanced guards work correctly without breaking existing targets

**Checkpoint**: ✅ Phase 2 Complete - Makefile has safety guards, existing targets still work

---

## Phase 3: GitHub Actions & Validation (Priority: HIGH) 🔧 Foundation Testing

**Purpose**: Automate testing and validation using existing workflow_dispatch workflow

**Goal**: Validate Phase 0-2 foundation work in clean CI environment

**Note**: Implements all deferred testing tasks from Phase 0 (Makefile target verification, validation scripts)

### 3.1 GitHub Actions Workflow Setup
- [x] T010 Update `.github/workflows/default.yaml` workflow_dispatch to use tbx-coding image
- [x] T011 Add workflow job: Run `make check-toolbox` to verify container
- [x] T012 Add workflow job: Run `make check-tools` to verify tool versions

### 3.2 Makefile Target Testing (from Phase 0)
- [x] T013 Workflow job: Run `init-validate` target to verify directories created
- [x] T014 [P] Create validation script `dot-local/bin/validate-init` (checks directories exist)
- [x] T015 Workflow job: Run `stow-validate` target to verify symlinks created  
- [x] T016 [P] Create validation script `dot-local/bin/validate-stow` (checks symlinks valid)
- [x] T017 Workflow job: Test systemd status targets work (backup_status, tbx_status) - **DEFERRED** (systemd not available in GitHub Actions)

### 3.3 Additional Validation
- [x] T018 Workflow job: Run `verify` target to validate all guards work (dry-run conflict check + symlink validation)
- [x] T019 [P] Create validation script `dot-local/bin/validate-nvim` (checks Neovim launches and config symlinked)
- [x] T020 Test workflow runs successfully via workflow_dispatch manual trigger
- [x] T021 Document GitHub Actions usage in README.md or `.github/README.md`

**Checkpoint**: ✅ Phase 3 Complete - Foundation validated in CI, ready for user story implementation

---

## Phase 4: User Story 1 - Deploy Neovim Configuration (Priority: P1) 🎯 MVP

**Goal**: Verify and document existing Neovim deployment from toolbox

**Independent Test**: From toolbox, run `make` and verify `~/.config/nvim/` is symlinked correctly

### Verification for User Story 1

- [x] T024 [US4] Test existing `make init` creates Neovim directories ($CACHE_HOME/nvim, $STATE_HOME/nvim, etc.)
- [x] T025 [US4] Test existing `make` (default) deploys `dot-config/nvim/` correctly via stow
- [x] T026 [US4] Verify Neovim plugin structure: files in `dot-config/nvim/plugin/` match pattern `{01-20}_*.lua` (FR-005)
- [x] T027 [US4] Count plugins in `dot-config/nvim/plugin/` - enforce max 20 (constitution)
- [x] T028 [US4] Test Neovim launches from toolbox with plugins loaded correctly
- [x] T029 [US4] Add `make nvim-verify` target to automate plugin count check
- [x] T030 [US4] Document Neovim deployment in README.md
- [x] T031 [US4] Test idempotency: Run `make` twice and verify second run succeeds without errors (FR-002)

**Checkpoint**: ✅ Phase 4 Complete - Neovim deployment verified, tested, and documented

---

## Phase 5: User Story 2 - Orchestrate System Tasks (Priority: P2)

**Goal**: Verify and document existing systemd/quadlet Makefile targets work from toolbox

**Independent Test**: From toolbox, run `make backup_status` and verify output

### Verification for User Story 2

- [ ] T032 [US5] Test existing `backup_enable`, `backup_disable`, `backup_status`, `backup_test` targets
- [ ] T033 [US5] Test existing `tbx_enable`, `tbx_disable`, `tbx_status`, `tbx_test` targets  
- [ ] T034 [US5] Verify systemd operations work from toolbox affecting host
- [ ] T035 [US5] Test quadlet operations if quadlets exist in `dot-config/containers/systemd/`
- [ ] T036 [US5] Document all systemd/quadlet targets in README.md
- [ ] T037 [US5] Create pattern rule for new systemd units (`%_enable`, `%_disable`, etc.)

**Checkpoint**: Systemd and quadlet orchestration verified and enhanced

---

## Phase 6: User Story 3 - Manage Configuration in Git (Priority: P3)

**Goal**: Verify Git workflow from toolbox (already working, just document)

**Independent Test**: From toolbox, modify config, commit, verify in git log

### Verification for User Story 3

- [ ] T038 [US6] Verify Git operations work from toolbox (commit, push, pull)
- [ ] T039 [US6] Review and update `.gitignore` if needed
- [ ] T040 [US6] Optional: Add `make git-status` convenience target
- [ ] T041 [US6] Test fresh clone workflow: `git clone` → `make init` → `make` → verify
- [ ] T042 [US6] Document Git workflow in README.md

**Checkpoint**: Git workflow verified and documented

---

## Phase 7: Polish & Documentation

**Purpose**: Final improvements and comprehensive documentation

- [ ] T043 Update main README.md with complete usage guide (init, deploy, systemd, git)
- [ ] T044 Create `docs/error-handling.md` documenting all error scenarios and fixes
- [ ] T045 Document toolbox setup in README: `toolbox create --image ghcr.io/grantmacken/tbx-coding:latest tbx-coding` and `toolbox enter tbx-coding`
- [ ] T046 Add inline comments to Makefile explaining guards and patterns
- [ ] T047 Validate all success criteria (SC-001 through SC-005)
- [ ] T048 Final test: Fresh clone → `make init` → `make` → launch Neovim → verify all works

---

## Dependencies & Execution Order

### Phase Dependencies

- **Research (Phase 0)**: No dependencies - MUST complete first ✅ COMPLETE
- **Setup (Phase 1)**: Depends on Research completion ✅ COMPLETE
- **Foundational (Phase 2)**: Depends on Setup ✅ COMPLETE
- **GitHub Actions (Phase 3)**: Depends on Foundational - validates Phase 0-2 work
- **User Stories (Phases 4-6)**: All depend on Phase 3 validation
  - User stories can proceed sequentially in priority order (P1 → P2 → P3)
  - Or in parallel if working on different aspects
- **Polish (Phase 7)**: Depends on user stories complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Phase 3 validation - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Phase 3 validation - Independent of US1
- **User Story 3 (P3)**: Can start after Phase 3 validation - Independent of US1/US2

### Within Each Phase

- Tasks marked [P] can run in parallel
- Research tasks within subsections must complete before moving to next subsection
- User story tasks should complete in order within the story

### Parallel Opportunities

- Phase 0: Completed (R001-R002)
- Phase 1: T002 and T003 can run in parallel
- Phase 2: T006 and T007 can run in parallel
- Phase 3: T014 and T016 can run in parallel (validation script creation), T019 can run in parallel
- Phase 7: T043, T044, T045 can run in parallel (documentation)

---

## Implementation Strategy

### MVP First (Research + User Story 1 Only)

1. Complete Phase 0: Research (toolbox validation - DONE!)
2. Complete Phase 1: Setup (basic documentation)
3. Complete Phase 2: Foundational (guards and helpers)
4. Complete Phase 3: User Story 1 (Neovim deployment)
5. **STOP and VALIDATE**: Test Neovim deployment independently
6. Commit and review

### Incremental Delivery

1. Complete Research + Setup + Foundational → Foundation ready
2. Add User Story 1 → Test Neovim deployment → Commit (MVP!)
3. Add User Story 2 → Test systemd operations → Commit
4. Add User Story 3 → Test Git workflow → Commit
5. Add GitHub Actions testing → Automated validation → Commit
6. Add Polish → Full system documented → Final commit

---

## Notes

- All operations MUST run from tbx-coding toolbox (image: ghcr.io/grantmacken/tbx-coding:latest) per FR-004
- Maximum 20 Neovim plugins enforced (constitution constraint)
- 30-second timeout for all systemd/quadlet operations (FR-011)
- Abort on conflicts: non-symlink files, broken symlinks, wrong directory (FR-008, FR-009, FR-010)
- No symlinks allowed in `dot-config/systemd/user/` or `dot-config/containers/` (FR-007)
- Commit after each phase or user story completion
- Stop at any checkpoint to validate story independently

### 3.4 Workflow Testing
- [x] T022 Create `dot-local/bin/gh-test-workflow` script to trigger and monitor workflow via gh CLI
- [x] T023 Add `make test-workflow` target that invokes `gh-test-workflow` script

