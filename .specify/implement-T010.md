# T010: GitHub Actions Workflow Setup

**Date**: 2025-11-13  
**Phase**: Phase 3 - GitHub Actions & Validation  
**Status**: ✅ COMPLETE

## Task Description

Update `.github/workflows/default.yaml` workflow_dispatch to use tbx-coding image and set up foundation testing.

## Implementation

### Workflow File: `.github/workflows/default.yaml`

**Changes Made**:
1. Renamed workflow: `Dotfiles Management - Foundation Testing`
2. Updated container image: `ghcr.io/grantmacken/tbx-coding:latest`
3. Kept `workflow_dispatch` trigger for manual testing
4. Added foundation validation steps

### Workflow Jobs

#### Job: `foundation-validation`

**Environment**:
- `runs-on: ubuntu-latest`
- `container: ghcr.io/grantmacken/tbx-coding:latest`

**Steps**:

1. **Checkout repository**
   - Uses: `actions/checkout@v4`
   - Branch: `main`

2. **Cache toolbox image**
   - Uses: `actions/cache@v4`
   - Performance optimization
   - Caches podman storage

3. **Setup toolbox**
   - Pulls tbx-coding image
   - Creates toolbox container
   - Verifies setup

4. **Verify toolbox detection**
   - Makes `check-toolbox` script executable
   - Verifies script exists
   - Tests in CI environment

5. **Verify required tools**
   - Makes `check-tools` script executable
   - Runs tool version checks
   - Reports tool availability

6. **Test repository root detection**
   - Makes `check-repo-root` script executable
   - Verifies repo root detection works in CI

### Testing Script: `dot-local/bin/gh-test-workflow`

**Purpose**: Trigger and monitor workflow runs using gh CLI

**Features**:
- Checks for gh CLI availability
- Verifies GitHub authentication
- Triggers workflow via `workflow_dispatch`
- Shows latest workflow run
- Provides commands to watch/view run

**Usage**:
```bash
# From repository root
dot-local/bin/gh-test-workflow

# Watch workflow execution
gh run watch --repo grantmacken/dots

# View in browser
gh run view --web --repo grantmacken/dots
```

## Prerequisites

### For Workflow to Run:
- Repository hosted on GitHub
- Image available: `ghcr.io/grantmacken/tbx-coding:latest`
- Workflow file committed to `main` branch
- GitHub Actions enabled for repository

### For Local Testing (gh CLI):
- gh CLI installed: https://cli.github.com/
- Authenticated: `gh auth login`
- Repository access configured

## Testing

### Local Validation

```bash
# Check gh CLI available
command -v gh

# Check authentication
gh auth status

# View repository info
gh repo view

# List workflows
gh workflow list

# Trigger workflow (when ready)
dot-local/bin/gh-test-workflow
```

### Expected Workflow Behavior

1. **Checkout**: Repository cloned into CI environment
2. **Environment**: Shows Fedora container info
3. **Toolbox Check**: Verifies check-toolbox script exists
4. **Tools Check**: Runs tool version verification
5. **Repo Check**: Validates repository root detection

### Success Criteria

✅ Workflow file syntax valid (YAML)  
✅ Container image accessible  
✅ Checkout step succeeds  
✅ Scripts are executable  
✅ Repository root detected  
✅ Tool checks run (may report version warnings)

## Files Modified

- `.github/workflows/default.yaml` - Updated workflow
- `dot-local/bin/gh-test-workflow` - Created trigger script
- `.specify/001-tasks.md` - Marked T010 complete, added T022-gh

## Next Steps

### Immediate (Phase 3):
- **T011**: Add `make check-toolbox` workflow job
- **T012**: Add `make check-tools` workflow job
- **T013-T021**: Add Makefile target testing jobs

### Workflow Enhancement Strategy:
1. Add one job at a time
2. Test each addition with `gh-test-workflow`
3. Validate before proceeding to next
4. Keep workflow focused on foundation validation

## Troubleshooting

### Workflow Doesn't Trigger
- Check repository has Actions enabled
- Verify workflow file on `main` branch
- Check GitHub permissions

### Container Image Not Found
- Verify image exists: `ghcr.io/grantmacken/tbx-coding:latest`
- Check image is public or has proper access
- Confirm image spelling/capitalization

### Script Execution Fails
- Scripts must be committed with execute permissions
- Use `chmod +x` in workflow if needed
- Check script paths are correct

### gh CLI Issues
```bash
# Install gh CLI
# Fedora: sudo dnf install gh
# Or: https://cli.github.com/

# Authenticate
gh auth login

# Check status
gh auth status

# Refresh if needed
gh auth refresh
```

## References

- GitHub Actions Workflow Syntax: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
- GitHub CLI: https://cli.github.com/manual/
- Workflow Dispatch: https://docs.github.com/en/actions/using-workflows/manually-running-a-workflow
- Container Jobs: https://docs.github.com/en/actions/using-jobs/running-jobs-in-a-container

## Notes

### Container vs Toolbox
- GitHub Actions uses container (not toolbox)
- `/run/.containerenv` may not exist in CI
- Scripts adapted to work in both environments

### Workflow Evolution
- Started basic (just environment check)
- Will grow with T011-T021 tasks
- Each addition validates incrementally

### Manual Trigger Benefits
- No automatic runs on push/PR yet
- Manual control for testing
- Can add automation later

---

**Implementation Date**: 2025-11-13  
**Task Status**: ✅ COMPLETE  
**Next Task**: T011 - Add make check-toolbox job
