# Research Task R002: Toolbox Tool Verification

**Task**: Verify toolbox is tbx-coding (image: ghcr.io/grantmacken/tbx-coding:latest) by reading `/run/.containerenv` contents

**Date**: 2025-11-13

**Status**: ✅ COMPLETE

## Implementation

### Verification Approach

Created `dot-local/bin/check-tools` script that:
1. Verifies running in tbx-coding container (via `/run/.containerenv`)
2. Checks presence of required CLI tools
3. Validates tool versions meet minimum requirements
4. Uses version comparison to ensure compatibility

### Required Tools & Minimum Versions

From `.specify/001-plan.md` Phase 0.1 acceptance criteria:

| Tool | Minimum | Found | Status |
|------|---------|-------|--------|
| GNU Stow | 2.3+ | 2.4.1 | ✅ |
| GNU Make | 4.0+ | 4.4 | ✅ |
| Git | 2.30+ | 2.51.1 | ✅ |
| systemd | 245+ | 258 | ✅ |
| Neovim | 0.9+ | 0.12.0 | ✅ |

### Container Image Validation

```bash
Container Details from /run/.containerenv:
engine="podman-5.6.2"
name="tbx-coding"
id="4f6559ab2a7178e2a43a1ddb775cd9b7addbc37ebdadb2e3c095be91febdfd52"
image="ghcr.io/grantmacken/tbx-coding:latest"
imageid="0b293e6fa2ac3d0429fa5cc7e7f1a0b9cc8ad59024f4bbce58ae65ff2237771a"
```

✅ Image matches expected: `ghcr.io/grantmacken/tbx-coding:latest`

### Test Results

```bash
$ ./dot-local/bin/check-tools

=== Toolbox Tool Verification ===

✓ Container: tbx-coding
  Image: ghcr.io/grantmacken/tbx-coding:latest

✓ GNU Stow: 2.4 (>= 2.3)
✓ GNU Make: 4.4 (>= 4.0)
✓ Git: 2.51 (>= 2.30)
✓ systemctl (systemd): 258 (>= 245)
✓ Neovim: 0.12 (>= 0.9)

✓ All required tools present with minimum versions
```

### Additional Tools Available

Not required by specification but useful:
- **Bash**: 5.3.0 (shell)
- **Podman**: 5.6.2 (container management from within toolbox)
- **Busted**: 2.2.0 (Lua testing framework for Neovim tests)

### Usage

```bash
# Check tools manually
./dot-local/bin/check-tools

# Integrate into Makefile
check-tools: ## Verify required tools and versions
	@./dot-local/bin/check-tools || exit 1
```

### Key Findings

1. **All tools exceed minimums** - tbx-coding image is well-maintained
2. **Version parsing reliable** - Using grep/head combination for version extraction
3. **Color output helpful** - Green checkmarks, red X's improve readability
4. **Version comparison needed** - Simple `sort -V` handles semantic versioning
5. **Neovim very current** - 0.12.0 is latest stable (minimum was 0.9+)

## Acceptance Criteria

✅ Can verify toolbox is tbx-coding by reading `/run/.containerenv`  
✅ Can validate image source is `ghcr.io/grantmacken/tbx-coding:latest`  
✅ Can check all required tools are present  
✅ Can verify tool versions meet or exceed minimums  
✅ Provides clear pass/fail output with version information

## Tool Version Strategy

The tbx-coding image provides:
- **Current stable versions** - All tools are recent releases
- **Fedora packages** - Using Fedora repository packages where possible
- **Sufficient for requirements** - All exceed constitutional minimums

No version pinning needed - image maintainer ensures compatibility.

## Next Steps

- Integrate `check-tools` into Makefile (optional convenience target)
- Document tool versions in README.md
- Mark R002 complete in task list

## References

- Plan requirements: `.specify/001-plan.md` Phase 0.1
- Container image: https://github.com/grantmacken/tbx-coding
- Fedora toolbox docs: https://docs.fedoraproject.org/en-US/fedora-silverblue/toolbox/
