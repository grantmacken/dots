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
- [ ] R003 [R0] Document toolbox creation and entry: `toolbox create --image ghcr.io/grantmacken/tbx-coding:latest tbx-coding` then `toolbox enter tbx-coding`
- [ ] R004 [R0] Test toolbox can access host systemd user session

**Acceptance**: Can detect toolbox and verify all required CLI tools available

### 0.2 Makefile Verification in Toolbox

- [ ] R005 [R0] Run `make init` from toolbox and verify directories created in $HOME
- [ ] R006 [R0] Run `make` (default stow) from toolbox and verify symlinks created
- [ ] R007 [R0] Test systemd targets (backup_status, tbx_status) work from toolbox
- [ ] R008 [R0] Document any issues or unexpected behavior with existing targets

**Acceptance**: All existing Makefile targets execute successfully from toolbox

### 0.3 GitHub Actions Compatibility Research

- [ ] R009 [R0] Research GitHub Actions approach for testing dotfiles (existing examples)
- [ ] R010 [R0] Identify how to simulate toolbox environment in GitHub Actions
- [ ] R011 [R0] Draft workflow structure: checkout, setup, run make init, validate directories
- [ ] R012 [R0] Document validation approach for CI (directory checks, symlink validation)

**Acceptance**: Have a clear plan for GitHub Actions workflow implementation

### 0.4 Directory Structure Validation

- [ ] R013 [R0] Create validation script that checks `make init` created required directories
- [ ] R014 [R0] Create validation script that verifies stow symlinks are valid (not broken)
- [ ] R015 [R0] Test validation scripts work both in toolbox and potentially in CI
- [ ] R016 [R0] Document expected directory structure for automated testing

**Acceptance**: Can programmatically verify deployment succeeded

**Checkpoint**: Research complete - ready to enhance existing Makefile with guards and CI

---

## Phase 1: Setup (Documentation & Planning)

**Purpose**: Document existing system and plan enhancements

- [ ] T001 Create `.specify/research.md` documenting Phase 0 findings
- [ ] T002 Document existing Makefile targets in README.md
- [ ] T003 Identify gaps: missing guards, timeout handling, conflict detection

---

## Phase 2: Foundational (Enhancements to Existing Makefile)

**Purpose**: Add safety guards and validation to existing Makefile

**⚠️ CRITICAL**: Enhance, don't replace working Makefile

- [x] T004 Add toolbox detection helper function to Makefile: check `/run/.containerenv` exists and contains `name="tbx-coding"`
- [ ] T005 Add repository root check to Makefile (FR-010)
- [ ] T006 Add `make verify` target: use `stow --simulate` for conflicts (FR-008), check no symlinks in systemd/containers dirs (FR-007)
- [ ] T007 [P] Add broken symlink detection script in `dot-local/bin/check-symlinks`
- [ ] T008 [P] Add 30-second timeout wrapper for systemd operations (FR-011)
- [ ] T009 Test enhanced guards work correctly without breaking existing targets

**Checkpoint**: Makefile has safety guards, existing targets still work

---

## Phase 3: User Story 1 - Deploy Neovim Configuration (Priority: P1) 🎯 MVP

**Goal**: Verify and document existing Neovim deployment from toolbox

**Independent Test**: From toolbox, run `make` and verify `~/.config/nvim/` is symlinked correctly

### Verification for User Story 1

- [ ] T010 [US1] Test existing `make init` creates Neovim directories ($CACHE_HOME/nvim, $STATE_HOME/nvim, etc.)
- [ ] T011 [US1] Test existing `make` (default) deploys `dot-config/nvim/` correctly via stow
- [ ] T012 [US1] Verify Neovim plugin structure: files in `dot-config/nvim/plugin/` match pattern `{01-20}_*.lua` (FR-005)
- [ ] T013 [US1] Count plugins in `dot-config/nvim/plugin/` - enforce max 20 (constitution)
- [ ] T014 [US1] Test Neovim launches from toolbox with plugins loaded correctly
- [ ] T015 [US1] Add `make nvim-verify` target to automate plugin count check
- [ ] T016 [US1] Document Neovim deployment in README.md
- [ ] T017 [US1] Test idempotency: Run `make` twice and verify second run succeeds without errors (FR-002)

**Checkpoint**: Neovim deployment verified and documented

---

## Phase 4: User Story 2 - Orchestrate System Tasks (Priority: P2)

**Goal**: Verify and document existing systemd/quadlet Makefile targets work from toolbox

**Independent Test**: From toolbox, run `make backup_status` and verify output

### Verification for User Story 2

- [ ] T018 [US2] Test existing `backup_enable`, `backup_disable`, `backup_status`, `backup_test` targets
- [ ] T019 [US2] Test existing `tbx_enable`, `tbx_disable`, `tbx_status`, `tbx_test` targets  
- [ ] T020 [US2] Verify systemd operations work from toolbox affecting host
- [ ] T021 [US2] Add timeout wrapper to systemd targets (30s per FR-011) if not present
- [ ] T022 [US2] Test quadlet operations if quadlets exist in `dot-config/containers/systemd/`
- [ ] T023 [US2] Document all systemd/quadlet targets in README.md
- [ ] T024 [US2] Create pattern rule for new systemd units (`%_enable`, `%_disable`, etc.)

**Checkpoint**: Systemd and quadlet orchestration verified and enhanced

---

## Phase 5: User Story 3 - Manage Configuration in Git (Priority: P3)

**Goal**: Verify Git workflow from toolbox (already working, just document)

**Independent Test**: From toolbox, modify config, commit, verify in git log

### Verification for User Story 3

- [ ] T025 [US3] Verify Git operations work from toolbox (commit, push, pull)
- [ ] T026 [US3] Review and update `.gitignore` if needed
- [ ] T027 [US3] Optional: Add `make git-status` convenience target
- [ ] T028 [US3] Test fresh clone workflow: `git clone` → `make init` → `make` → verify
- [ ] T029 [US3] Document Git workflow in README.md

**Checkpoint**: Git workflow verified and documented

---

## Phase 6: GitHub Actions & Validation

**Purpose**: Automate testing and validation

- [ ] T030 [P] Create `.github/workflows/test-deployment.yml` workflow
- [ ] T031 [P] Workflow step: Setup tbx-coding container or use ghcr.io/grantmacken/tbx-coding:latest image
- [ ] T032 Workflow step: Run `make init` and validate directories created
- [ ] T033 Workflow step: Run `make verify` (stow dry-run) to check for conflicts
- [ ] T034 Workflow step: Run validation scripts (directory checks, symlink validation)
- [ ] T035 Workflow step: Verify Neovim plugin count ≤ 20
- [ ] T036 Test workflow runs successfully on push/PR
- [ ] T037 Document CI/CD approach in README.md or `.github/README.md`

---

## Phase 7: Polish & Documentation

**Purpose**: Final improvements and comprehensive documentation

- [ ] T038 Update main README.md with complete usage guide (init, deploy, systemd, git)
- [ ] T039 Create `docs/error-handling.md` documenting all error scenarios and fixes
- [ ] T040 Document toolbox setup: `toolbox create --image ghcr.io/grantmacken/tbx-coding:latest tbx-coding` and `toolbox enter tbx-coding`
- [ ] T041 Add inline comments to Makefile explaining guards and patterns
- [ ] T042 Validate all success criteria (SC-001 through SC-005)
- [ ] T043 Final test: Fresh clone → `make init` → `make` → launch Neovim → verify all works

---

## Dependencies & Execution Order

### Phase Dependencies

- **Research (Phase 0)**: No dependencies - MUST complete first
- **Setup (Phase 1)**: Depends on Research completion
- **Foundational (Phase 2)**: Depends on Setup - BLOCKS all user stories
- **User Stories (Phase 3-5)**: All depend on Foundational completion
  - User stories can proceed sequentially in priority order (P1 → P2 → P3)
  - Or in parallel if working on different aspects
- **Polish (Phase 6)**: Depends on all user stories complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - Independent of US1
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - Independent of US1/US2

### Within Each Phase

- Tasks marked [P] can run in parallel
- Research tasks within subsections must complete before moving to next subsection
- User story tasks should complete in order within the story

### Parallel Opportunities

- Phase 0: R001 can run parallel with R005, R009, R013
- Phase 1: T002 and T003 can run in parallel
- Phase 2: T006 and T007 can run in parallel
- Phase 6: T031, T032, T033, T034 can run in parallel

---

## Implementation Strategy

### MVP First (Research + User Story 1 Only)

1. Complete Phase 0: Research (validate all assumptions)
2. Complete Phase 1: Setup (basic Makefile structure)
3. Complete Phase 2: Foundational (guards and helpers)
4. Complete Phase 3: User Story 1 (Neovim deployment)
5. **STOP and VALIDATE**: Test Neovim deployment independently
6. Commit and review

### Incremental Delivery

1. Complete Research + Setup + Foundational → Foundation ready
2. Add User Story 1 → Test Neovim deployment → Commit (MVP!)
3. Add User Story 2 → Test systemd operations → Commit
4. Add User Story 3 → Test Git workflow → Commit
5. Add Polish → Full system operational → Final commit

---

## Notes

- All operations MUST run from tbx-coding toolbox (image: ghcr.io/grantmacken/tbx-coding:latest) per FR-004
- Maximum 20 Neovim plugins enforced (constitution constraint)
- 30-second timeout for all systemd/quadlet operations (FR-011)
- Abort on conflicts: non-symlink files, broken symlinks, wrong directory (FR-008, FR-009, FR-010)
- No symlinks allowed in `dot-config/systemd/user/` or `dot-config/containers/` (FR-007)
- Commit after each phase or user story completion
- Stop at any checkpoint to validate story independently
