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

### 1.1 Script Skeleton

- [x] T-H001 Create `dot-local/bin/nvim-health-to-issue` with bash shebang, error handling (`set -euo pipefail`), cleanup trap
- [x] T-H002 Implement headless health check capture to temp file: `nvim --headless "+checkhealth" "+redir! > <tempfile>" "+silent checkhealth" "+redir END" +qa`
- [ ] T-H003 Parse health check output: extract WARNING (⚠️) and ERROR (❌) items grouped by plugin/module
- [ ] T-H004 Handle edge cases: no warnings/errors, health check failure, malformed output

**Checkpoint** (local task): Health check output parsed successfully with all warnings/errors extracted

---

## Phase 2: Markdown Generation

**Purpose**: Convert parsed data into single GitHub issue body with checkboxes

### 2.1 Issue Body Template

- [ ] T-H005 Generate markdown checkbox list: `- [ ] <actionable item>` for each warning/error grouped by plugin
- [ ] T-H006 Add metadata footer: generation timestamp, source (`:checkhealth`), label (`neovim-health`)
- [ ] T-H007 Handle "all checks passed" scenario: generate success message when no warnings/errors

**Checkpoint** (local task): Markdown document generated with proper GitHub checkbox format

---

## Phase 3: GitHub Integration

**Purpose**: Create or update single long-running GitHub issue

### 3.1 Issue Management

- [ ] T-H008 Implement issue lookup: `gh issue list --label neovim-health --state all --json number,state` (return issue number or empty)
- [ ] T-H009 Implement issue create: `gh issue create --title "Neovim Health Check TODO" --body "$MARKDOWN" --label neovim-health`
- [ ] T-H010 Implement issue update: `gh issue edit <number> --body "$MARKDOWN"` (reopen if closed)
- [ ] T-H011 Main execution flow: capture → parse → generate → lookup → create/update → print issue URL
- [ ] T-H012 Error handling: validate nvim exists, gh CLI authenticated, network failures, non-zero exit codes

**Checkpoint** (local task): Single GitHub issue created/updated successfully with fresh health check data

---

## Phase 4: Makefile Integration

**Purpose**: Integrate into Makefile workflow

### 4.1 Make Target

- [ ] T-H013 Add `nvim-health-issues` target to Makefile: calls `$(HOME)/.local/bin/nvim-health-to-issue`
- [ ] T-H014 Update `make help` documentation: `nvim-health-issues ## Convert Neovim health check to GitHub issue`

**Checkpoint** (local task): `make nvim-health-issues` executes successfully and displays issue URL

---

## Phase 5: Manual Verification & Documentation

**Purpose**: Verify all success criteria and document usage

### 5.1 Testing & Documentation

- [ ] T-H015 Test with real Neovim config: verify issue created, checkboxes render, manually check box persists
- [ ] T-H016 Test update workflow: verify existing issue updated (not duplicated), timestamp refreshed
- [ ] T-H017 Test edge cases: no warnings, health check failure, no gh auth, outside git repo
- [ ] T-H018 Verify success criteria SC-H001 through SC-H007 all pass
- [ ] T-H019 Update documentation: README.md usage example, note manual execution only

**Checkpoint** (local task): All success criteria verified, documentation complete

---

## Phase 6: Merge to Main

**Purpose**: Integrate feature into main branch

### 6.1 Pre-merge & Merge

- [ ] T-H020 Create PR `feature/nvim-checkhealth-issues` → `main`, review, merge, verify on main

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

**Total Tasks**: 20 (T-H001 through T-H020)  
**Completed**: 2  
**Remaining**: 18

**Next Action**: Start with T-H003 (parse health check output for warnings/errors)

---

## Notes

- All tasks executed manually from tbx-coding toolbox
- No GitHub Actions workflow for this feature (manual execution only)
- Single long-running issue approach (one issue per repository)
- Merge to main only after manual verification of all success criteria
