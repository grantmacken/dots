# Neovim Snapshot Testing with mini.test

Guide for creating and maintaining UI snapshot tests for Neovim plugins using mini.test.

## Overview

Snapshot tests verify UI output by capturing "screenshots" (text representations of the screen) and comparing them to reference files. This is perfect for testing user commands, UI layouts, and visual plugin behavior.

## Key Concepts

### Screenshot Format

Screenshots are text files with two sections:

1. **Text section**: Actual screen content with line numbers
2. **Attribute section**: Highlight group IDs for each character

Example:
```
--|---------|---------|---------|---------|
01|Hello World                            
02|~                                      
03|~                                      

--|---------|---------|---------|---------|
01|00000011111122222222222222222222222222
02|33333333333333333333333333333333333333
```

### First Run Behavior

**Important**: The first time you run snapshot tests, they will create screenshot files and report NOTES (not failures). This is expected behavior!

```
Fails (0) and Notes (3)
NOTE: Created reference screenshot at path "tests/screenshots/..."
```

### Subsequent Runs

After screenshots exist, tests compare current output to screenshots:
- **Pass**: Output matches screenshot (0 fails, 0 notes)
- **Fail**: Output differs from screenshot (shows diff)

## File Structure

```
dot-config/nvim/
├── tests/
│   ├── assert_init.lua        # For unit/assertion tests
│   ├── snapshot_init.lua      # For snapshot tests (THIS ONE)
│   ├── test_show.lua          # Unit tests
│   ├── snapshot_show.lua      # Snapshot tests
│   └── screenshots/           # Generated screenshot files
│       └── tests-snapshot_show.lua---TestName---test-description
```

## Creating Snapshot Tests

### 1. Create Test File

Create `tests/snapshot_MODULE.lua`:

```lua
--- Snapshot tests for MODULE plugin
--- @see dot-config/nvim/plugin/NN_MODULE.lua
--- @see dot-config/nvim/lua/MODULE/init.lua

local helpers = _G.helpers
local child = helpers.new_child_neovim()

local T = MiniTest.new_set({
  hooks = {
    pre_once = function()
      child.setup()  -- Setup child Neovim
    end,
    post_once = function()
      child.stop()  -- Cleanup
    end,
  },
})

-- CRITICAL: Use child.lua() for any vim.* functions!
local function wait_for_ui()
  child.lua([[vim.wait(200, function() return false end)]])
  child.cmd('redraw')
end

T['YourCommand'] = MiniTest.new_set()

T['YourCommand']['test description'] = function()
  -- Execute command in child
  child.cmd('YourCommand')
  
  -- Wait for UI to update IN CHILD
  wait_for_ui()
  
  -- Capture screenshot
  child.expect_screenshot()
end

return T
```

### 2. Critical: Child Context

**Always use `child.lua()` for vim.* functions that should run in the child!**

```lua
-- ❌ WRONG - Runs in parent Neovim, will block!
local function wait_for_ui()
  vim.wait(200, function() return false end)
  child.cmd('redraw')
end

-- ✅ CORRECT - Runs in child Neovim
local function wait_for_ui()
  child.lua([[vim.wait(200, function() return false end)]])
  child.cmd('redraw')
end
```

### 3. Add Makefile Target (Optional)

```makefile
snapshot-MODULE: ## run snapshot tests for MODULE
echo '##[ $@ ]##'
pushd dot-config/nvim &>/dev/null
TEST_FILE=tests/snapshot_MODULE.lua nvim --headless -u tests/snapshot_init.lua \
-c "lua MiniTest.run()" -c "qa!"
popd &>/dev/null
echo '✅ snapshot tests completed'

snapshot-MODULE-update: ## update snapshots for MODULE
echo '##[ $@ ]##'
pushd dot-config/nvim &>/dev/null
rm -rf tests/screenshots/tests-snapshot_MODULE.lua*
TEST_FILE=tests/snapshot_MODULE.lua nvim --headless -u tests/snapshot_init.lua \
-c "lua MiniTest.run()" -c "qa!"
popd &>/dev/null
echo '✅ snapshots updated'
```

## Running Tests

### First Run (Create Screenshots)

```bash
make snapshot-show
```

Output:
```
Total number of cases: 3
tests/snapshot_show.lua: ooo
Fails (0) and Notes (3)
NOTE: Created reference screenshot at path "tests/screenshots/..."
```

### Review Screenshots

```bash
ls tests/screenshots/
cat tests/screenshots/tests-snapshot_show.lua---ShowScratchExample---displays-scratch-buffer-with-message
```

### Subsequent Runs (Verify)

```bash
make snapshot-show
```

Output (if passing):
```
Total number of cases: 3
tests/snapshot_show.lua: ooo
Fails (0) and Notes (0)
✅ snapshot tests completed
```

### Update After UI Changes

```bash
# Delete old screenshots and regenerate
make snapshot-show-update

# Review changes
git diff tests/screenshots/

# If correct, commit
git add tests/screenshots/
git commit -m "Update snapshots after UI changes"
```

## Customizing Child Setup

The `child.setup()` function in `snapshot_init.lua` configures the child Neovim:

```lua
child.setup = function()
  -- Minimal Neovim with no plugins
  child.restart({ '-u', 'NONE', '--noplugin' })
  child.o.loadplugins = false
  
  -- Set lua paths
  local cwd = vim.fn.getcwd()
  child.lua(string.format([[package.path = '%s/lua/?.lua;%s/lua/?/init.lua;' .. package.path]], cwd, cwd))
  
  -- Set reproducible dimensions
  child.o.lines = 15
  child.o.columns = 80
  child.o.laststatus = 0
  child.o.cmdheight = 1
  
  -- Load ONLY your module
  child.lua([[require('show')]])
  
  -- Define commands manually (avoid loading full plugin files)
  child.cmd([[
    command! ShowScratchExample lua require('show').buffer('bufScratchExample', 'Example content')
  ]])
end
```

## Common Patterns

### Testing Window Layouts

```lua
T['Command']['creates split window'] = function()
  child.cmd('YourSplitCommand')
  wait_for_ui()
  
  -- Screenshot captures entire UI including splits
  child.expect_screenshot()
end
```

### Testing Buffer Content

```lua
T['Command']['displays correct content'] = function()
  child.cmd('YourCommand')
  wait_for_ui()
  
  -- Optionally check specific content before screenshot
  local lines = child.get_lines()
  MiniTest.expect.equality(lines[1], 'Expected first line')
  
  -- Then capture full UI
  child.expect_screenshot()
end
```

### Testing Reused State

```lua
T['Command']['reuses buffer on second call'] = function()
  -- Fresh start
  child.restart({ '-u', 'NONE', '--noplugin' })
  child.setup()
  
  -- First call
  child.cmd('YourCommand')
  wait_for_ui()
  
  -- Second call
  child.cmd('YourCommand')
  wait_for_ui()
  
  -- Screenshot shows final state
  child.expect_screenshot()
end
```

## Troubleshooting

### Tests Hang/Block

**Problem**: Using `vim.wait()` or other vim.* functions directly
**Solution**: Wrap in `child.lua([[...]])`

```lua
-- ❌ Hangs
vim.wait(100, function() return false end)

-- ✅ Works
child.lua([[vim.wait(100, function() return false end)]])
```

### Plugin Loading Errors

**Problem**: Other plugins load and cause errors
**Solution**: Use `--noplugin` flag and minimal config

### Screenshots Not Created

**Problem**: `MiniTest.current.case` not set
**Solution**: Ensure tests run through `MiniTest.run()`, not directly

### Different Output Each Run

**Problem**: Non-deterministic content (timestamps, random data)
**Solution**: Mock or stub dynamic content in child

## Best Practices

1. **Minimal Child Config**: Only load what you're testing
2. **Use child.lua()**: For any vim.* functions
3. **Descriptive Test Names**: They become screenshot filenames
4. **Fresh State**: Use `child.restart()` between tests if needed
5. **Wait for UI**: Always wait and redraw before screenshots
6. **Review Screenshots**: Manually verify initial screenshots are correct
7. **Commit Screenshots**: They're part of your test suite

## Makefile Targets

```bash
make snapshot-show          # Run show module snapshot tests
make snapshot-show-update   # Regenerate show module screenshots
make snapshot-all           # Run all snapshot tests
make snapshot-all-update    # Regenerate all screenshots
make snapshot-help          # Show help
```

## References

- mini.test documentation: `:h mini.test`
- mini.nvim tests: `~/.local/share/nvim/site/pack/core/start/mini.nvim/tests/`
- Example: `tests/snapshot_show.lua`
