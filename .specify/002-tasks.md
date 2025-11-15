---
description: "Task list for Neovim Health Check Issue Automation"
---

# Tasks: Neovim Health Check Issue Automation

**Input**: Specification from `.specify/spec-neovim-healthcheck.md`
**Branch**: feature/nvim-checkhealth-issues
**Execution**: Manual local execution only (no GitHub Actions)

**Purpose**: Automate conversion of `:checkhealth` output into actionable GitHub issues

## Testing Terminology

- **Local Task Checkpoint**: Verification run on localhost (Fedora Silverblue + tbx-coding toolbox)
- **Manual Execution**: All tasks run manually from toolbox environment

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[H]**: Health check feature story reference
- Include exact file paths in descriptions

---

## Phase 1: Health Check Capture

**Purpose**: Capture Neovim health check output in parseable format

### 1.1 Basic Health Check

- [ ] H001 [H] Create `dot-local/bin/nvim-health-check` script to run `nvim --headless "+checkhealth" "+redir! > /tmp/health.txt" "+silent checkhealth" "+redir END" +qa`
- [ ] H002 [H] Verify script captures health output to `/tmp/health.txt` with WARNING and ERROR markers
- [ ] H003 [H] Add error handling for nvim failures (exit non-zero if nvim fails)

**Checkpoint** (local task): Health check output captured successfully

---

## Phase 2: Parse Health Output

**Purpose**: Extract structured data from health check output

### 2.1 Parser Implementation

- [ ] H004 [H] Create parser function to extract plugin/module sections from health output
- [ ] H005 [H] Extract WARNING lines (⚠️ prefix) with context (plugin name)
- [ ] H006 [H] Extract ERROR lines (❌ prefix) with context (plugin name)
- [ ] H007 [H] Group warnings/errors by plugin/module name

**Checkpoint** (local task): Parser correctly identifies and groups all warnings/errors

---

## Phase 3: Generate Issue Format

**Purpose**: Convert parsed data into GitHub issue markdown format

### 3.1 Markdown Generation

- [ ] H008 [H] Create function to generate issue title from plugin name and warning count
- [ ] H009 [H] Generate markdown checkbox list for each warning/error item
- [ ] H010 [H] Add source reference (`:checkhealth [plugin]`) to each issue
- [ ] H011 [H] Handle edge case: no warnings/errors found (report success, no issues)

**Checkpoint** (local task): Markdown format matches GitHub issue requirements

---

## Phase 4: GitHub Issue Creation

**Purpose**: Upload issues to GitHub repository

### 4.1 Issue Upload

- [ ] H012 [H] Check existing issues with label `neovim-health` to avoid duplicates
- [ ] H013 [H] Create issues using `gh issue create --label neovim-health --body-file`
- [ ] H014 [H] Report count of issues created vs. skipped (duplicates)
- [ ] H015 [H] Handle network failures gracefully (log error, exit non-zero)

**Checkpoint** (local task): Issues created successfully in GitHub without duplicates

---

## Phase 5: Integration

**Purpose**: Integrate into Makefile workflow

### 5.1 Makefile Target

- [ ] H016 [H] Add `nvim-health-issues` target to Makefile that runs from toolbox
- [ ] H017 [H] Ensure script has executable permissions via `make` default target
- [ ] H018 [H] Document target in Makefile help output

**Checkpoint** (local task): `make nvim-health-issues` creates GitHub issues successfully

---

## Phase 6: Documentation

**Purpose**: Document usage and workflow

### 6.1 Documentation

- [ ] H019 [H] Update README.md with nvim-health-issues workflow description
- [ ] H020 [H] Document manual execution steps (when to run, how to verify)
- [ ] H021 [H] Add example of generated issue format to spec document

**Checkpoint** (local task): Documentation complete and accurate

---

## Phase 7: Merge Preparation

**Purpose**: Prepare feature branch for merge to main

### 7.1 Pre-merge Validation

- [ ] H022 [H] Run full workflow end-to-end from toolbox
- [ ] H023 [H] Verify all acceptance scenarios from spec pass
- [ ] H024 [H] Clean up any temporary files or debugging code
- [ ] H025 [H] Review all changes meet Makefile style guide requirements

**Checkpoint** (local task): Feature ready for merge to main

---

## Success Criteria

- **SC-H001**: Running `make nvim-health-issues` creates GitHub issues for each plugin with warnings
- **SC-H002**: Issues contain actionable checkbox items
- **SC-H003**: No duplicate issues created on subsequent runs
- **SC-H004**: All issues tagged with `neovim-health` label
- **SC-H005**: Script exits 0 on success, non-zero on failure

---

## Notes

- All tasks executed manually from tbx-coding toolbox
- No GitHub Actions workflow for this feature
- Merge to main only after manual verification of all success criteria
