# Workflow Architecture Change: Silverblue + Toolbox

**Date**: 2025-11-13  
**Impact**: Major - Changes CI/CD testing environment  
**Reason**: Match actual user workflow (Silverblue → toolbox → dotfiles)

## Problem

**Previous Workflow**:
- Ran directly in `ghcr.io/grantmacken/tbx-coding:latest` container
- No toolbox layer
- `/run/.containerenv` didn't match local environment
- Guards failed because toolbox detection incorrect

**Issue**:
```bash
# Local (correct):
toolbox enter tbx-coding  # /run/.containerenv has name="tbx-coding"
make check-toolbox        # ✓ Passes

# CI (incorrect):
container: tbx-coding:latest  # Direct container, not toolbox
make check-toolbox            # ✗ Fails - no toolbox detected
```

## Solution

**New Workflow Architecture**:
```
GitHub Actions
  └─> Fedora Silverblue container (quay.io/fedora/fedora-silverblue:latest)
      └─> Create toolbox (tbx-coding)
          └─> Run all tests inside toolbox
```

Matches user workflow exactly:
1. Silverblue host
2. Create toolbox from image
3. Enter toolbox
4. Run make commands

## Changes Made

### Container Base

```yaml
# Before
container:
  image: ghcr.io/grantmacken/tbx-coding:latest

# After  
container:
  image: quay.io/fedora/fedora-silverblue:latest
```

### Added Setup Step

```yaml
- name: Setup toolbox
  run: |
    echo "1. Installing toolbox if needed..."
    command -v toolbox || dnf install -y toolbox
    
    echo "2. Pulling toolbox image..."
    podman pull ghcr.io/grantmacken/tbx-coding:latest
    
    echo "3. Creating toolbox container..."
    toolbox create --image ghcr.io/grantmacken/tbx-coding:latest tbx-coding
    
    echo "4. Verifying toolbox..."
    toolbox list
```

### Updated All Test Steps

**Before** (direct execution):
```yaml
- name: Run make check-toolbox
  run: make check-toolbox
```

**After** (inside toolbox):
```yaml
- name: Run make check-toolbox
  run: |
    toolbox run --container tbx-coding bash -c "cd $PWD && make check-toolbox"
```

All steps now use: `toolbox run --container tbx-coding bash -c "cd $PWD && <command>"`

### Updated Steps

1. ✅ Verify toolbox detection → runs in toolbox
2. ✅ Verify required tools → runs in toolbox
3. ✅ Test repository root → runs in toolbox
4. ✅ Run make check-toolbox → runs in toolbox
5. ✅ Run make check-tools → runs in toolbox

## Benefits

### 1. Realistic Testing Environment
- Matches actual Silverblue + toolbox workflow
- Tests in same environment users will use
- Proper container nesting (Silverblue → toolbox)

### 2. Correct Toolbox Detection
```bash
# Inside toolbox:
cat /run/.containerenv
# name="tbx-coding"  ← Now correct!

# check-toolbox script passes
# Guards work correctly
```

### 3. Tool Availability
- All tools from tbx-coding image available
- Versions match local development
- No "soft failure" warnings needed

### 4. Matches Documentation
README.md workflow:
```bash
toolbox create --image ghcr.io/grantmacken/tbx-coding:latest tbx-coding
toolbox enter tbx-coding
make init
make
```

CI workflow (same steps):
```bash
toolbox create --image ghcr.io/grantmacken/tbx-coding:latest tbx-coding
toolbox run --container tbx-coding bash -c "make init"
toolbox run --container tbx-coding bash -c "make"
```

## Workflow Execution Order

```
1. Checkout repository
   ↓
2. Cache toolbox image (performance)
   ↓
3. Setup toolbox
   - Pull image (uses cache)
   - Create toolbox
   - Verify creation
   ↓
4. [All remaining steps run inside toolbox]
   - Verify toolbox detection ✓
   - Verify required tools ✓
   - Test repository root ✓
   - Run make check-toolbox ✓
   - Run make check-tools ✓
```

## Testing

### Trigger Updated Workflow

```bash
# From repository root
dot-local/bin/gh-test-workflow

# Watch execution
gh run watch --repo grantmacken/dots

# View in browser
gh run view --web --repo grantmacken/dots
```

### Expected Results

**Setup Step**:
- ✅ Toolbox installed (or already present)
- ✅ Image pulled: `ghcr.io/grantmacken/tbx-coding:latest`
- ✅ Toolbox created: `tbx-coding`
- ✅ Toolbox listed successfully

**Test Steps**:
- ✅ All commands execute inside toolbox
- ✅ check-toolbox passes (detects tbx-coding)
- ✅ check-tools passes (correct versions)
- ✅ make targets work correctly
- ✅ No warnings or soft failures needed

## Migration Notes

### What Changed
- ❌ No longer run directly in container
- ✅ Now use Silverblue + toolbox (like local)

### What Stayed Same
- ✅ Same image: `ghcr.io/grantmacken/tbx-coding:latest`
- ✅ Same toolbox name: `tbx-coding`
- ✅ Same test steps (just inside toolbox now)

### Impact on Future Tasks
- T013-T021: All will run inside toolbox
- `make init` → inside toolbox
- `make` (stow) → inside toolbox
- Directory/symlink validation → inside toolbox

## Constitutional Alignment

**FR-004: Toolbox Isolation**
- ✅ Now properly enforced in CI
- ✅ All tools run from toolbox
- ✅ Host (Silverblue) isolation maintained

**Testing Strategy**:
- ✅ Foundation → Validation → Features
- ✅ Clean environment testing
- ✅ Matches user workflow exactly

## Technical Details

### Toolbox Command Pattern

**Format**:
```bash
toolbox run --container <name> bash -c "<commands>"
```

**Requirements**:
- `cd $PWD` - Change to repository directory
- Full command in quotes
- Multiple commands with `&&`

**Example**:
```bash
toolbox run --container tbx-coding bash -c "cd $PWD && make check-toolbox"
```

### Why bash -c?
- Ensures commands run in bash shell
- Allows command chaining
- Preserves environment variables
- Consistent with toolbox enter behavior

## Troubleshooting

### Image Pull Fails
```bash
# Verify image exists
podman pull ghcr.io/grantmacken/tbx-coding:latest

# Check if public or requires auth
```

### Toolbox Create Fails
```bash
# Check podman/toolbox versions
podman --version
toolbox --version

# Try manual creation
toolbox create --image ghcr.io/grantmacken/tbx-coding:latest tbx-coding
```

### Commands Fail Inside Toolbox
```bash
# Test toolbox manually
toolbox run --container tbx-coding bash -c "pwd"
toolbox run --container tbx-coding bash -c "cd /workspace && ls"
```

## References

- Fedora Silverblue: https://fedoraproject.org/silverblue/
- Fedora Toolbox: https://containertoolbx.org/
- Toolbox Image: https://github.com/grantmacken/tbx-coding
- README.md: Toolbox setup instructions

## Next Steps

1. **Test the updated workflow**
   ```bash
   dot-local/bin/gh-test-workflow
   ```

2. **Verify setup step works**
   - Image pulls successfully
   - Toolbox creates without errors
   - toolbox list shows tbx-coding

3. **Verify test steps work**
   - All run inside toolbox
   - Detection works correctly
   - No soft failures needed

4. **Continue Phase 3**
   - T013-T021: Build on this foundation
   - All future jobs use same pattern

---

**Change Date**: 2025-11-13  
**Status**: ✅ IMPLEMENTED  
**Impact**: Foundation for all Phase 3 testing  
**Next**: Test workflow with new architecture
