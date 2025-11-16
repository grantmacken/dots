# Specification: Neovim Health Check Issue Tracker

**Feature**: Manual health check to GitHub issue conversion  
**Created**: 2025-11-15  
**Status**: Draft  
**Scope**: Feature branch to be merged back to main when complete

## Purpose

Convert Neovim `:checkhealth` output to a single long-running GitHub issue with markdown checkboxes, enabling systematic tracking of configuration improvements and dependency gaps.

## User Story

As a Neovim user, I want to manually generate a GitHub issue from `:checkhealth` output so I can track and resolve configuration warnings and missing dependencies using GitHub's checkbox interface.

**Why this matters**: Health checks identify config gaps, but tracking fixes manually is tedious. A single persistent issue with checkboxes provides a centralized, actionable TODO list.

## Acceptance Scenarios

1. **Given** Neovim config with health warnings, **When** `make nvim-health-issues` runs, **Then** markdown checkbox list is generated from headless health check
2. **Given** generated markdown checklist, **When** uploaded to GitHub, **Then** a single issue is created or updated with all health warnings as checkboxes
3. **Given** resolved warnings locally, **When** user checks boxes on GitHub issue, **Then** progress is tracked visibly without re-running script

## Functional Requirements

- **FR-H001**: System MUST run `nvim --headless "+checkhealth" +qa` to capture health output
- **FR-H002**: System MUST parse health output and extract WARNING and ERROR items
- **FR-H003**: System MUST generate markdown checkbox format grouped by plugin/module
- **FR-H004**: System MUST create/update ONE long-running GitHub issue (not multiple issues)
- **FR-H005**: System MUST tag issue with label `neovim-health`
- **FR-H006**: System MUST be manually triggered via `make nvim-health-issues`
- **FR-H007**: Generated checkboxes MUST be manually checkable on GitHub as warnings are resolved

## Technical Details

### Health Check Capture

```bash
nvim --headless "+checkhealth" "+redir! > /tmp/health.txt" "+silent checkhealth" "+redir END" +qa
```

### Output Format

Health check produces structured output like:

```
==============================================================================
fzf_lua:                                                                  3 ⚠️

fzf-lua [optional:media] ~
- ⚠️ WARNING 'viu' not found
- ⚠️ WARNING 'chafa' not found
- ⚠️ WARNING 'ueberzugpp' not found

==============================================================================
kulala:                                                             4 ⚠️  2 ❌

Tools: ~
- ❌ ERROR {gRPCurl} not found
- ❌ ERROR {websocat} not found

Formatters: ~
- ⚠️ WARNING {application/javascript} formatter not found
```

### Issue Format

Single issue containing all health warnings grouped by plugin:

```markdown
# Neovim Health Check TODO

Generated: 2025-11-15

## fzf_lua (3 ⚠️)

Optional media tools:
- [ ] Install `viu` for image preview
- [ ] Install `chafa` for image preview  
- [ ] Install `ueberzugpp` for image preview

## kulala (4 ⚠️ 2 ❌)

Tools:
- [ ] Install `grpcurl` for gRPC support
- [ ] Install `websocat` for WebSocket support

Formatters:
- [ ] Configure `application/javascript` formatter
- [ ] Configure `application/json` formatter

---
**Source**: `:checkhealth` | **Label**: `neovim-health`
```

## Development Workflow

**Branch**: `feature/nvim-health-issues`  
**Merge Criteria**: All success criteria met + manual verification of issue creation

### Branch Workflow
1. Create feature branch from main
2. Implement and test on feature branch
3. Verify all acceptance scenarios pass
4. Create PR for review
5. Merge to main after approval

## Implementation Approach

1. **Script**: `dot-local/bin/nvim-health-to-issue`
   - Run headless health check: `nvim --headless "+checkhealth" +qa`
   - Parse output for WARNING/ERROR lines
   - Group by plugin/module
   - Generate single markdown document with all warnings as checkboxes
   - Check if `neovim-health` labeled issue exists via `gh issue list`
   - If exists: Update issue body via `gh issue edit`
   - If not exists: Create new issue via `gh issue create`

2. **Makefile Target**: `nvim-health-issues`
   - Manual execution only (no automation)
   - Invokes script, displays issue URL

3. **Workflow**: Manual local execution when user wants to refresh health check tracking

## Edge Cases

- No warnings/errors found → Close existing issue or create issue stating "All checks passed"
- Health check fails to run → Report error, exit non-zero
- Network failure on issue update → Log failure, exit non-zero  
- No existing issue found → Create new issue with generated markdown
- Existing issue found → Update issue body with fresh health check results

## Success Criteria

- **SC-H001**: Running `make nvim-health-issues` creates/updates ONE GitHub issue
- **SC-H002**: Issue contains all health warnings as markdown checkboxes grouped by plugin
- **SC-H003**: Subsequent runs update existing issue, not create duplicates
- **SC-H004**: Issue tagged with `neovim-health` label for filtering
- **SC-H005**: User can manually check boxes on GitHub as warnings are resolved locally
- **SC-H006**: Script exits 0 on success, non-zero on failure
- **SC-H007**: Feature branch merges to main after manual verification
