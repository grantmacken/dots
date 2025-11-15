# Error Handling Guide

This document describes error scenarios in the dotfiles management system and their solutions.

## Deployment Errors

### Stow Conflicts

**Error**: `stow: ERROR: Conflicts detected during stow operation`

**Cause**: Non-symlink files exist at target locations where Stow wants to create symlinks

**Solution**:
```sh
# Identify conflicting files
make verify  # runs stow --simulate to show conflicts

# Manually resolve each conflict:
# Option 1: Backup and remove existing file
mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.backup
make  # retry deployment

# Option 2: If you want to keep existing config
# Don't deploy this repo - it will overwrite your configs
```

### Broken Symlinks

**Error**: `ERROR: Broken symlinks detected`

**Cause**: Symlinks point to non-existent files

**Solution**:
```sh
# Find broken symlinks
find ~ -maxdepth 3 -xtype l

# Remove broken symlinks
find ~/.config -xtype l -delete
find ~/.local -xtype l -delete

# Redeploy
make
```

### Repository Root Error

**Error**: `ERROR: Must run from repository root`

**Cause**: Makefile invoked from wrong directory

**Solution**:
```sh
# Change to repository root
cd ~/Projects/dots

# Verify location
pwd  # should show /home/user/Projects/dots

# Retry command
make init
```

### Toolbox Detection Error

**Error**: `ERROR: Must run inside tbx-coding toolbox`

**Cause**: Command run on host system instead of toolbox

**Solution**:
```sh
# Enter toolbox
toolbox enter tbx-coding

# Verify you're in toolbox
cat /run/.containerenv | grep tbx-coding

# Retry command
make
```

## Systemd Errors

### Service Start Failure

**Error**: `Failed to start unit.service: Unit not found`

**Cause**: Unit files not deployed or systemd not reloaded

**Solution**:
```sh
# Deploy unit files
make  # stow will symlink them

# Reload systemd
systemctl --user daemon-reload

# Verify unit file exists
ls -l ~/.config/systemd/user/*.service

# Retry
make backup_enable
```

### Timer Not Running

**Error**: Timer listed but service never triggers

**Cause**: Timer enabled but service has errors

**Solution**:
```sh
# Check timer status
make backup_status

# Check service logs
journalctl --user -u bu_projects.service --no-pager -n 50

# Test service manually
make backup_test

# Fix script errors
vim dot-local/bin/bu_projects
```

### Permission Denied

**Error**: `Failed to execute script: Permission denied`

**Cause**: Script not executable

**Solution**:
```sh
# Make scripts executable
chmod +x dot-local/bin/*

# Redeploy
make

# Verify permissions
ls -l ~/.local/bin/bu_projects
```

### Systemd Operation Timeout

**Error**: `Timeout waiting for systemd operation`

**Cause**: Operation exceeded 30 second limit (FR-012)

**Solution**:
```sh
# Check system load
systemctl --user status

# Kill hung processes
systemctl --user stop bu_projects.service

# Restart systemd user session
systemctl --user daemon-reexec

# Retry operation
make backup_enable
```

## Neovim Errors

### Plugin Count Exceeded

**Error**: `ERROR: Plugin count exceeds maximum (20)`

**Cause**: More than 20 plugin files violates constitution

**Solution**:
```sh
# Count current plugins
ls -1 dot-config/nvim/plugin/*.lua | wc -l

# Remove unnecessary plugins
# Edit or remove plugin files in dot-config/nvim/plugin/

# Verify count
make nvim-verify
```

### Neovim Won't Launch

**Error**: `nvim: command not found`

**Cause**: Neovim not installed in toolbox or version too old

**Solution**:
```sh
# Check Neovim installation
which nvim

# Check version (requires 0.9+)
nvim --version | head -n 1

# If missing, install in toolbox
# (consult tbx-coding container documentation)

# Verify
make check-tools
```

### Plugin Naming Error

**Error**: `ERROR: Plugin files must match pattern {NN}_*.lua`

**Cause**: Plugin files don't follow naming convention (FR-005)

**Solution**:
```sh
# Check current naming
ls -1 dot-config/nvim/plugin/

# Rename to proper format: NN_name.lua
# Examples:
#   01_options.lua
#   02_keymaps.lua
#   10_lsp.lua

# Fix naming
mv dot-config/nvim/plugin/options.lua dot-config/nvim/plugin/01_options.lua

# Verify
make nvim-verify
```

## Git Errors

### Symlink in Git

**Error**: Symlinks detected in `dot-config/systemd/user/` or `dot-config/containers/`

**Cause**: Violation of FR-007 - these directories must contain only actual files

**Solution**:
```sh
# Find symlinks
find dot-config/systemd/user -type l
find dot-config/containers -type l

# Replace symlinks with actual files
# For each symlink:
target=$(readlink dot-config/systemd/user/myunit.service)
rm dot-config/systemd/user/myunit.service
cp "$target" dot-config/systemd/user/myunit.service

# Verify
make verify
```

### Dirty Working Tree

**Error**: Cannot deploy - uncommitted changes

**Cause**: Git working tree has modifications

**Solution**:
```sh
# Check status
make git-status

# Option 1: Commit changes
git add .
git commit -m "update configs"

# Option 2: Stash changes
git stash

# Option 3: Discard changes (CAUTION!)
git reset --hard HEAD
```

## GitHub Actions Errors

### Stow Version Too Old

**Error**: GitHub Actions workflow fails with Stow errors

**Cause**: Ubuntu default Stow version < 2.4.0 (required per FR-001, see https://github.com/aspiers/stow/issues/33)

**Solution**: Workflow automatically builds Stow 2.4.1 from source - this is expected and handled

### Workflow Validation Failure

**Error**: `validate-stow` or `validate-init` fails in Actions

**Cause**: Deployment issue not caught locally

**Solution**:
```sh
# Test locally first
make verify
make validate-setup

# Fix issues locally, then push
git add .
git commit -m "fix deployment issues"
git push upstream main
```

## Tool Version Errors

### Tool Not Found or Wrong Version

**Error**: `ERROR: Required tool not found or version too old`

**Cause**: Missing or outdated tools in environment

**Solution**:
```sh
# Check all tools
make check-tools

# Expected versions:
# - GNU Stow: 2.4.0+
# - GNU Make: 4.0+
# - Git: 2.30+
# - systemd: 245+
# - Neovim: 0.9+

# Fix: Ensure running in tbx-coding toolbox
toolbox enter tbx-coding
make check-tools
```

## Prevention Tips

1. **Always verify before deploying**: Run `make verify` before `make`
2. **Test in toolbox**: Never run deployment commands on host
3. **Check tool versions**: Run `make check-tools` after toolbox updates
4. **Keep plugin count low**: Check `make nvim-verify` regularly
5. **Follow naming conventions**: Use proper file naming patterns
6. **No manual symlinks**: Let Stow manage all symlinks
7. **Test locally before pushing**: Run validations before git push

## Getting Help

If errors persist:

1. Check logs: `journalctl --user -n 100 --no-pager`
2. Verify environment: `make check-toolbox && make check-tools`
3. Review recent changes: `make git-status`
4. Start fresh: Clone to new directory and test deployment
5. Check GitHub Actions logs for CI-specific issues

## Related Documents

- [README.md](../README.md) - Main documentation
- [Makefile](../Makefile) - Target definitions
- [.specify/000-constitution.md](../.specify/000-constitution.md) - Project principles
- [.specify/001-dotfiles-management.md](../.specify/001-dotfiles-management.md) - Feature specification
