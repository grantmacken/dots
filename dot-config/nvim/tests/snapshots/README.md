# Snapshot Test Files

This directory contains snapshot files for Neovim plugin tests. Snapshots capture expected output from user commands and plugin interactions.

## Show Module Snapshots

### `show/scratch_example_content.txt`
**Command:** `:ShowScratchExample`  
**What it tests:** Buffer content after running ShowScratchExample command  
**Captures:**
- Buffer metadata (number, name, type)
- Line count
- Actual buffer content (message displayed)

### `show/scratch_example_window.txt`
**Command:** `:ShowScratchExample`  
**What it tests:** Window state after command execution  
**Captures:**
- Window ID and buffer association
- Window dimensions (height, width)
- Window configuration

## Updating Snapshots

When you intentionally change command output or behavior:

1. Run tests to see differences:
   ```bash
   nvim --headless -u tests/minimal_init.lua -c "lua MiniTest.run_file('tests/snapshot_show.lua')"
   ```

2. Review the diff between actual output and snapshot

3. If changes are correct, update snapshots:
   ```bash
   nvim --headless -u tests/minimal_init.lua \
     -c "lua MiniTest.run_file('tests/snapshot_show.lua', { update_snapshots = true })"
   ```

4. Commit updated snapshots with code changes

## Best Practices

- ✅ Review snapshot diffs carefully before updating
- ✅ Keep snapshots small and focused on one aspect
- ✅ Document what each snapshot tests in this README
- ✅ Commit snapshots together with code changes
- ❌ Don't snapshot system-specific data (paths, PIDs)
- ❌ Don't snapshot timestamps or random data
- ❌ Don't update snapshots without reviewing changes

## Snapshot Test Guide

For detailed information on writing snapshot tests, see:
`.github/instructions/nvim-snapshots.md`
