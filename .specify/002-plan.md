# Implementation Plan: Neovim Health Check Issue Tracker

**Branch**: `feature/nvim-checkhealth-issues` | **Date**: 2025-11-15 | **Spec**: `.specify/spec-neovim-healthcheck.md`

## Summary

Manual conversion of Neovim `:checkhealth` output to GitHub issue with markdown checkboxes for systematic tracking of configuration improvements and dependency gaps.

## Technical Context

**Language/Version**: Bash 5.x, Neovim 0.12.0-dev  
**Primary Dependencies**: neovim, gh CLI, sed/awk/grep for parsing  
**Storage**: Single long-running GitHub issue with `neovim-health` label  
**Testing**: Manual verification via `make nvim-health-issues`  
**Target Platform**: Fedora Silverblue host + tbx-coding toolbox (ghcr.io/grantmacken/tbx-coding:latest)  
**Project Type**: Developer tooling (config verification tracker)  
**Execution**: Manual local invocation only  
**Constraints**: One issue max, manual checkbox tracking, no automation  
**Scope**: Feature branch, merge to main after manual verification

## Constitution Check

✅ **I. Declarative Configuration**: Health check parsing logic in script  
✅ **II. Stow-Based Management**: Script in dot-local/bin/, deployed via Stow  
✅ **III. Toolbox Isolation**: Neovim and gh CLI run from tbx-coding  
✅ **IV. Systemd-First**: N/A - manual invocation only  
✅ **Makefile Target**: Single target `nvim-health-issues` for manual execution

## Project Structure

### Script Location
```text
dot-local/bin/
└── nvim-health-to-issue      # Main implementation script
```

### Makefile Integration
```text
Makefile
└── nvim-health-issues        # Manual execution target
```

### Specification Documents
```text
.specify/
├── spec-neovim-healthcheck.md    # Feature specification
├── 002-plan.md                    # This plan
└── 002-tasks.md                   # Task breakdown (to be created)
```

## Phase 1: Health Check Capture

### 1.1 Headless Health Check Execution
- **Goal**: Capture raw `:checkhealth` output reliably
- **Output**: Script captures health check to temporary file
- **Acceptance**: `nvim --headless "+checkhealth" +qa` runs successfully, output captured
- **Contracts**:
  - Script creates temporary file in `$XDG_RUNTIME_DIR` or `/tmp`
  - Neovim runs headless without errors
  - Full health check output captured including WARNING and ERROR markers
  - Cleanup temporary file on script exit

### 1.2 Output Parsing
- **Goal**: Extract structured data from health check output
- **Output**: Parsed sections with plugin names, warning/error counts, messages
- **Acceptance**: Script correctly identifies all WARNING (⚠️) and ERROR (❌) items
- **Contracts**:
  - Parse section headers (e.g., `fzf_lua:`, `kulala:`)
  - Extract counts (e.g., `3 ⚠️`, `4 ⚠️  2 ❌`)
  - Extract warning/error messages with context
  - Group by plugin/module
  - Handle edge cases: no warnings, health check failures

## Phase 2: Markdown Generation

### 2.1 Checkbox List Creation
- **Goal**: Generate markdown checkboxes from parsed warnings/errors
- **Output**: Single markdown document with all warnings as actionable checkboxes
- **Acceptance**: Output follows GitHub checkbox format, grouped logically
- **Contracts**:
  - Format: `- [ ] Action item text` for each warning/error
  - Group by plugin/module with headers
  - Include context (e.g., "fzf_lua (3 ⚠️)")
  - Add metadata footer: generation date, source command, label
  - Handle special cases: all checks passed, health check failed

### 2.2 Issue Body Template
- **Goal**: Create complete GitHub issue body
- **Output**: Full markdown document ready for GitHub issue
- **Acceptance**: Template includes title, timestamp, grouped checkboxes, metadata
- **Contracts**:
  - Title: `# Neovim Health Check TODO`
  - Timestamp: `Generated: YYYY-MM-DD`
  - Grouped sections per plugin
  - Footer with source and label
  - Clear, actionable checkbox items

## Phase 3: GitHub Integration

### 3.1 Issue Lookup
- **Goal**: Check if `neovim-health` labeled issue exists
- **Output**: Issue number if exists, empty if not
- **Acceptance**: `gh issue list` correctly identifies existing issue
- **Contracts**:
  - Query: `gh issue list --label neovim-health --state all --json number,state`
  - Handle multiple issues (take first open, or first closed if none open)
  - Return issue number or empty string
  - Exit non-zero if gh CLI fails

### 3.2 Issue Create/Update
- **Goal**: Create new issue or update existing issue with fresh health check
- **Output**: GitHub issue URL
- **Acceptance**: Issue created/updated successfully, URL printed
- **Contracts**:
  - **If no issue exists**: `gh issue create --title "Neovim Health Check TODO" --body "$MARKDOWN" --label neovim-health`
  - **If issue exists**: `gh issue edit $NUMBER --body "$MARKDOWN"`
  - Reopen closed issue if needed: `gh issue reopen $NUMBER`
  - Print issue URL on success
  - Exit non-zero if gh CLI fails
  - Log error message if network/API failure

### 3.3 Edge Case Handling
- **Goal**: Handle failure modes gracefully
- **Output**: Clear error messages, non-zero exit codes
- **Acceptance**: Script fails cleanly with actionable errors
- **Contracts**:
  - Neovim not found → Error message, exit 1
  - Health check fails → Error message, exit 1
  - gh CLI not found → Error message, exit 1
  - Network/API failure → Error message, exit 1
  - No warnings/errors → Create/update issue with "All checks passed", exit 0

## Phase 4: Makefile Integration

### 4.1 Make Target
- **Goal**: Single command for health check to issue conversion
- **Output**: `make nvim-health-issues` target
- **Acceptance**: Target runs script, displays issue URL
- **Contracts**:
  - Target name: `nvim-health-issues`
  - Executes: `dot-local/bin/nvim-health-to-issue`
  - Displays issue URL on success
  - Fails cleanly with error message
  - No dependencies on other targets
  - Manual execution only (no .PHONY: automation)

### 4.2 Help Documentation
- **Goal**: Document target in `make help`
- **Output**: Help text for nvim-health-issues target
- **Acceptance**: `make help` shows target with description
- **Contracts**:
  - Help text: `nvim-health-issues ## Convert Neovim health check to GitHub issue`
  - Follows existing Makefile help pattern
  - Clearly indicates manual execution only

## Phase 5: Manual Verification & Merge

### 5.1 Feature Testing
- **Goal**: Verify all success criteria met on feature branch
- **Output**: Checklist of verified behaviors
- **Acceptance**: All SC-H001 through SC-H007 pass
- **Contracts**:
  - Run `make nvim-health-issues` with warnings present
  - Verify issue created with correct format
  - Run again, verify issue updated (not duplicated)
  - Verify `neovim-health` label applied
  - Verify checkboxes manually checkable on GitHub
  - Fix warnings locally, verify checkboxes checkable
  - Verify script exits 0 on success, non-zero on failure

### 5.2 Merge to Main
- **Goal**: Integrate feature into main branch
- **Output**: PR merged, feature branch deleted
- **Acceptance**: Feature works on main branch
- **Contracts**:
  - Create PR: `feature/nvim-checkhealth-issues` → `main`
  - Manual review and approval
  - Merge PR
  - Delete feature branch
  - Verify on main: `make nvim-health-issues` still works

## Dependencies & Prerequisites

### Toolbox Container (tbx-coding)
- Neovim 0.9+ (current: v0.12.0-dev-1573)
- gh CLI (GitHub CLI) authenticated with repo access
- Standard Unix tools: sed, awk, grep, mktemp

### Repository
- Feature branch: `feature/nvim-checkhealth-issues` (already created)
- Specification: `.specify/spec-neovim-healthcheck.md` (already exists)
- Write access to GitHub repository for issue creation

### Neovim Configuration
- Working Neovim config in `dot-config/nvim/`
- Health checks available via `:checkhealth`

## Success Validation

After implementation, verify:

1. **SC-H001**: Running `make nvim-health-issues` creates/updates ONE GitHub issue
2. **SC-H002**: Issue contains all health warnings as markdown checkboxes grouped by plugin
3. **SC-H003**: Subsequent runs update existing issue, not create duplicates
4. **SC-H004**: Issue tagged with `neovim-health` label for filtering
5. **SC-H005**: User can manually check boxes on GitHub as warnings are resolved locally
6. **SC-H006**: Script exits 0 on success, non-zero on failure
7. **SC-H007**: Feature branch merges to main after manual verification

## Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Health check output format changes | Parsing breaks | Use robust regex, test with multiple Neovim versions |
| gh CLI auth expires | Issue creation fails | Clear error message, exit non-zero |
| Multiple issues with same label | Duplicate tracking | Take first open issue, warn if multiple found |
| Very large health check output | GitHub API limits | Truncate or split into sections if needed |
| Network failure during update | Stale issue | Retry logic or clear error message |

## Implementation Notes

- Keep script simple: focus on reliable parsing and issue management
- Use bash built-ins where possible for portability
- Error messages should guide user to resolution
- No automation: manual `make nvim-health-issues` invocation only
- Single source of truth: one issue per repository
- Checkboxes are for tracking only, not triggering actions

## Next Steps

1. Run `/speckit.tasks` to generate task breakdown from this plan
2. Implement Phase 1-3 (script development)
3. Implement Phase 4 (Makefile integration)
4. Execute Phase 5 (verification and merge)
