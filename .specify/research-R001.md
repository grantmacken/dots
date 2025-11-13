# Research Task R001: Toolbox Detection

**Task**: Check if running inside toolbox by testing for `/run/.containerenv` file (official Fedora method)

**Date**: 2025-11-13

**Status**: ✅ COMPLETE

## Implementation

### Detection Method

Based on [Fedora Silverblue documentation](https://docs.fedoraproject.org/en-US/fedora-silverblue/tips-and-tricks/), the official method to detect toolbox execution is checking for the `/run/.containerenv` file.

### File: `dot-local/bin/check-toolbox`

Created bash script that:
1. Tests for existence of `/run/.containerenv`
2. Verifies container name is "tbx-coding"
3. Validates image source is from `ghcr.io/grantmacken/tbx-coding`

### Test Results

```bash
=== Toolbox Detection Test (R001) ===

✓ Running inside a container

Container details from /run/.containerenv:
engine="podman-5.6.2"
name="tbx-coding"
id="4f6559ab2a7178e2a43a1ddb775cd9b7addbc37ebdadb2e3c095be91febdfd52"
image="ghcr.io/grantmacken/tbx-coding:latest"
imageid="0b293e6fa2ac3d0429fa5cc7e7f1a0b9cc8ad59024f4bbce58ae65ff2237771a"
rootless=1
graphRootMounted=1

✓ Container name: tbx-coding
✓ Image: ghcr.io/grantmacken/tbx-coding:latest

=== R001 Test Complete ===
```

### Usage

```bash
# Check if in correct toolbox
./dot-local/bin/check-toolbox

# Use in Makefile targets
check-toolbox: ## Verify running in tbx-coding toolbox
	@./dot-local/bin/check-toolbox || exit 1
```

### Key Findings

- `/run/.containerenv` is more reliable than `$CONTAINER_ID` environment variable
- File contains structured key-value pairs with container metadata
- Parsing is straightforward with grep/cut
- Works consistently across shell sessions and subprocesses

## Acceptance Criteria

✅ Can detect toolbox context via `/run/.containerenv` file  
✅ Can verify container name matches "tbx-coding"  
✅ Can verify image source matches expected registry  
✅ Provides clear error messages when not in toolbox or wrong container

## Next Steps

- Integrate `check-toolbox` into Makefile targets (Task T004)
- Document in README.md
- Add to verification workflow in Phase 2

## References

- Fedora Silverblue Tips and Tricks: https://docs.fedoraproject.org/en-US/fedora-silverblue/tips-and-tricks/
- Podman containerenv documentation
