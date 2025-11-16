---
description: "Task list for Neovim Health Check Issue Tracker"
---

# Tasks: Neovim Health Check Issue Tracker

**Input**: Specification from `.specify/spec-neovim-healthcheck.md`  
**Branch**: `feature/nvim-checkhealth-issues`  
**Plan**: `.specify/002-plan.md`  
**Execution**: Manual local execution only (no GitHub Actions)

**Purpose**: Convert `:checkhealth` output to single long-running GitHub issue with markdown checkboxes

## Testing Terminology

- **Local Task Checkpoint**: Verification run on localhost (Fedora Silverblue + tbx-coding toolbox)
- **Manual Execution**: All tasks run manually via `make nvim-health-issues`

## Format: `[ID] Description`

- Tasks align with Makefile patterns and feature branch workflow
- Single GitHub issue per repository (not multiple issues)

---

## Phase 1: Health Check Capture

**Purpose**: Capture Neovim health check output in parseable format

### 1.1 Script Skeleton & Output Capture

- [x] T-H001 Update `dot-local/bin/nvim-health-to-issue`: Use `tmp/` directory (relative to repo root) for temporary health check output file
- [x] T-H002 Implement headless health check capture: `nvim --headless "+checkhealth" "+qa"` with output redirected to `tmp/nvim-health-raw.txt`
- [x] T-H003 Add cleanup trap: ensure `tmp/nvim-health-raw.txt` removed on script exit (success or failure)

**Checkpoint** (local task): Health check output captured to `tmp/nvim-health-raw.txt`

### 1.2 Output Parsing

- [ ] T-H004 Parse health check output: extract WARNING (⚠️) and ERROR (❌) items grouped by plugin/module from `tmp/nvim-health-raw.txt`
- [ ] T-H005 Handle edge cases: no warnings/errors, health check failure, malformed output

**Checkpoint** (local task): Health check output parsed successfully with all warnings/errors extracted

---

## Phase 2: Markdown Generation

**Purpose**: Convert parsed data into single GitHub issue body with checkboxes

### 2.1 Issue Body Template

- [ ] T-H006 Generate markdown checkbox list: `- [ ] <actionable item>` for each warning/error grouped by plugin
- [ ] T-H007 Add metadata footer: generation timestamp, source (`:checkhealth`), label (`neovim-health`)
- [ ] T-H008 Handle "all checks passed" scenario: generate success message when no warnings/errors

**Checkpoint** (local task): Markdown document generated with proper GitHub checkbox format

---

## Phase 3: GitHub Integration

**Purpose**: Create or update single long-running GitHub issue

### 3.1 Issue Management

- [ ] T-H009 Implement issue lookup: `gh issue list --label neovim-health --state all --json number,state` (return issue number or empty)
- [ ] T-H010 Implement issue create: `gh issue create --title "Neovim Health Check TODO" --body "$MARKDOWN" --label neovim-health`
- [ ] T-H011 Implement issue update: `gh issue edit <number> --body "$MARKDOWN"` (reopen if closed)
- [ ] T-H012 Main execution flow: capture → parse → generate → lookup → create/update → print issue URL
- [ ] T-H013 Error handling: validate nvim exists, gh CLI authenticated, network failures, non-zero exit codes

**Checkpoint** (local task): Single GitHub issue created/updated successfully with fresh health check data

---

## Phase 4: Makefile Integration

**Purpose**: Integrate into Makefile workflow

### 4.1 Make Target

- [x] T-H014 Add `nvim-health-issues` target to Makefile: calls `$(HOME)/.local/bin/nvim-health-to-issue`
- [x] T-H015 Update `make help` documentation: `nvim-health-issues ## Convert Neovim health check to GitHub issue`

**Checkpoint** (local task): `make nvim-health-issues` executes successfully and displays issue URL

---

## Phase 5: Manual Verification & Documentation

**Purpose**: Verify all success criteria and document usage

### 5.1 Testing & Documentation

- [ ] T-H016 Test with real Neovim config: verify issue created, checkboxes render, manually check box persists
- [ ] T-H017 Test update workflow: verify existing issue updated (not duplicated), timestamp refreshed
- [ ] T-H018 Test edge cases: no warnings, health check failure, no gh auth, outside git repo
- [ ] T-H019 Verify success criteria SC-H001 through SC-H007 all pass
- [ ] T-H020 Update documentation: README.md usage example, note manual execution only

**Checkpoint** (local task): All success criteria verified, documentation complete

---

## Phase 6: Merge to Main

**Purpose**: Integrate feature into main branch

### 6.1 Pre-merge & Merge

- [ ] T-H021 Create PR `feature/nvim-checkhealth-issues` → `main`, review, merge, verify on main

**Checkpoint** (local task): Feature integrated into main branch, works as expected

---

## Success Criteria

- **SC-H001**: Running `make nvim-health-issues` creates/updates ONE GitHub issue
- **SC-H002**: Issue contains all health warnings as markdown checkboxes grouped by plugin
- **SC-H003**: Subsequent runs update existing issue, not create duplicates
- **SC-H004**: Issue tagged with `neovim-health` label for filtering
- **SC-H005**: User can manually check boxes on GitHub as warnings are resolved locally
- **SC-H006**: Script exits 0 on success, non-zero on failure
- **SC-H007**: Feature branch merges to main after manual verification

---

## Task Summary

**Total Tasks**: 21 (T-H001 through T-H021)  
**Completed**: 5 (T-H001, T-H002, T-H003, T-H014, T-H015)  
**Remaining**: 16

**Next Action**: Start with T-H004 (parse health check output for warnings/errors)

---

## Notes

- All tasks executed manually from tbx-coding toolbox
- No GitHub Actions workflow for this feature (manual execution only)
- Single long-running issue approach (one issue per repository)
- Merge to main only after manual verification of all success criteria
