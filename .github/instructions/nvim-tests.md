---
title: Neovim Mini.test Testing Guide
description: Guide for writing tests using mini.test for Neovim Lua modules
category: testing
applies_to: neovim, lua, testing
version: 1.0.0
last_updated: 2025-11-19
---

# Neovim Mini.test Testing Guide

<purpose>
This guide defines patterns and practices for writing tests using mini.test for Neovim Lua modules.
Tests are located in `dot-config/nvim/tests/` and test modules from `dot-config/nvim/lua/`.
</purpose>

## Overview

<overview>
**mini.test** is a Neovim-native testing framework from the mini.nvim ecosystem.

**Key advantages:**
- Native Neovim integration with full API access
- No external dependencies or compatibility issues
- Synchronous execution model (no callbacks needed)
- Built-in test discovery and running
- Integrated with Neovim's vim.api and vim namespace

**Test location:** `dot-config/nvim/tests/`
**Module location:** `dot-config/nvim/lua/`
</overview>

## Test File Structure

<test_file_structure>
### Naming Convention

- **Module location:** `dot-config/nvim/lua/{name}/init.lua`
- **Test location:** `dot-config/nvim/tests/test_{name}.lua`
- **Examples:**
  - Module: `lua/show/init.lua` → Test: `tests/test_show.lua`
  - Module: `lua/projects/init.lua` → Test: `tests/test_projects.lua`
  - Module: `lua/util/init.lua` → Test: `tests/test_util.lua`

### Basic Template

```lua
--- Test suite for {name} module
--- @see dot-config/nvim/lua/{module_name}/init.lua

local MiniTest = require('mini.test')
local expect = MiniTest.expect

-- Test suite setup
local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      -- Setup before each test case
    end,
    post_case = function()
      -- Cleanup after each test case
    end,
  },
})

-- Load module under test
local module = require('{module_name}')

-- Test cases
T['module functionality'] = MiniTest.new_set()

T['module functionality']['test case description'] = function()
  local result = module.function_name()
  expect.equality(result, expected_value)
end

return T
```
</test_file_structure>

## Test Set Organization

<test_set_organization>
### Hierarchical Structure

Use nested test sets for logical grouping:

```lua
local T = MiniTest.new_set()

-- Top-level: module or feature area
T['buffer management'] = MiniTest.new_set()

-- Sub-level: specific functions
T['buffer management']['M.buffer()'] = MiniTest.new_set()

-- Test cases
T['buffer management']['M.buffer()']['creates new buffer'] = function()
  -- Test implementation
end

T['buffer management']['M.buffer()']['returns existing buffer'] = function()
  -- Test implementation
end
```

### Naming Conventions

- **Test sets:** Descriptive noun phrases (e.g., 'buffer management', 'window operations')
- **Test cases:** Descriptive sentences starting with verbs (e.g., 'creates new buffer', 'returns error on invalid input')
- **Use single quotes** for test names consistently
</test_set_organization>

## Assertions

<assertions>
### Built-in Expectations

mini.test provides **only four basic expectations**:

```lua
local expect = MiniTest.expect

-- Equality checks (deep comparison for tables)
expect.equality(actual, expected)
expect.no_equality(actual, not_expected)

-- Error checking
expect.error(function() error('msg') end)
expect.no_error(function() some_operation() end)
```

### Type Checking Pattern

For type checks, use `type()` with `equality`:

```lua
-- Check types
expect.equality(type(value), 'string')
expect.equality(type(value), 'number')
expect.equality(type(value), 'table')
expect.equality(type(value), 'function')
```

### Boolean/Truthy Checks Pattern

For boolean/truthy checks, compare directly:

```lua
-- Truthy checks
expect.equality(value ~= nil, true)
expect.equality(#value > 0, true)
expect.equality(condition, true)

-- Falsy checks
expect.equality(value, false)
expect.equality(value, nil)
expect.equality(ok, false)  -- where ok from pcall

-- Boolean comparisons
expect.equality(vim.api.nvim_buf_is_valid(bufnr), true)
expect.equality(vim.bo[bufnr].buflisted, false)
```

### Pattern Matching

For pattern matching, use Lua's `string:match()`:

```lua
-- Check if string matches pattern
local version = '0.1.0'
local matches = version:match('^%d+%.%d+%.%d+$') ~= nil
expect.equality(matches, true)
```

### Custom Expectations

Create helper functions for complex assertions:

```lua
-- Define helper at module level
local function assert_valid_buffer(bufnr)
  expect.equality(type(bufnr), 'number')
  expect.equality(bufnr > 0, true)
  expect.equality(vim.api.nvim_buf_is_valid(bufnr), true)
end

-- Use in tests
T['test case'] = function()
  local buf = create_buffer()
  assert_valid_buffer(buf)
end
```

### Creating New Expectations

For reusable custom expectations, use `MiniTest.new_expectation()`:

```lua
-- Create custom expectation
local expect_match = MiniTest.new_expectation(
  'string matching',
  function(str, pattern) return str:find(pattern) ~= nil end,
  function(str, pattern)
    return string.format('Pattern: %s\nString: %s', pattern, str)
  end
)

-- Use it
T['test'] = function()
  expect_match('hello world', 'world')
end
```
</assertions>
</assertions>

## Setup and Teardown

<setup_teardown>
### Hook Types

```lua
local T = MiniTest.new_set({
  hooks = {
    -- Before entire test set
    pre_once = function()
      -- One-time setup (e.g., create temp directory)
    end,
    
    -- Before each test case
    pre_case = function()
      -- Reset state, create fresh resources
    end,
    
    -- After each test case
    post_case = function()
      -- Cleanup resources, delete buffers
    end,
    
    -- After entire test set
    post_once = function()
      -- One-time cleanup (e.g., remove temp directory)
    end,
  },
})
```

### Nested Set Hooks

Child sets inherit parent hooks and can add their own:

```lua
local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      -- Runs before every test in this set and child sets
    end,
  },
})

T['child set'] = MiniTest.new_set({
  hooks = {
    pre_case = function()
      -- Runs AFTER parent pre_case, before each test in child set
    end,
  },
})
```
</setup_teardown>

## Testing Neovim APIs

<testing_neovim_apis>
### Buffer Management

```lua
T['buffer tests'] = MiniTest.new_set({
  hooks = {
    post_case = function()
      -- Cleanup: delete all test buffers
      local test_prefix = 'test_buf_'
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(buf)
        if name:match(test_prefix) and vim.api.nvim_buf_is_valid(buf) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end,
  },
})

T['buffer tests']['creates scratch buffer'] = function()
  local bufnr = vim.api.nvim_create_buf(false, true)
  
  expect.truthy(vim.api.nvim_buf_is_valid(bufnr))
  expect.falsy(vim.bo[bufnr].buflisted)
  expect.equality(vim.bo[bufnr].buftype, 'nofile')
  
  -- Cleanup
  vim.api.nvim_buf_delete(bufnr, { force = true })
end
```

### Window Management

```lua
T['window tests']['creates split window'] = function()
  local initial_win = vim.api.nvim_get_current_win()
  
  vim.cmd('split')
  local new_win = vim.api.nvim_get_current_win()
  
  expect.no_equality(initial_win, new_win)
  expect.truthy(vim.api.nvim_win_is_valid(new_win))
  
  -- Cleanup
  vim.cmd('close')
end
```

### Tab-scoped Variables

```lua
T['tab variable tests']['stores and retrieves value'] = function()
  local tabID = vim.api.nvim_get_current_tabpage()
  local var_name = 'test_var'
  local test_value = 42
  
  vim.t[var_name] = test_value
  
  local retrieved = vim.api.nvim_tabpage_get_var(tabID, var_name)
  expect.equality(retrieved, test_value)
  
  -- Cleanup
  vim.api.nvim_tabpage_del_var(tabID, var_name)
end
```

### Autocommands

```lua
T['autocommand tests']['triggers on event'] = function()
  local triggered = false
  
  local aug = vim.api.nvim_create_augroup('TestGroup', { clear = true })
  vim.api.nvim_create_autocmd('BufEnter', {
    group = aug,
    callback = function()
      triggered = true
    end,
  })
  
  -- Trigger event
  vim.cmd('enew')
  
  expect.truthy(triggered)
  
  -- Cleanup
  vim.api.nvim_del_augroup_by_id(aug)
end
```
</testing_neovim_apis>

## Module Testing Patterns

<module_testing_patterns>
### Testing Module Functions

```lua
T['module.function()'] = MiniTest.new_set()

T['module.function()']['returns expected value'] = function()
  local result = module.function(arg1, arg2)
  expect.equality(result, expected)
end

T['module.function()']['handles nil input'] = function()
  local result = module.function(nil)
  expect.equality(result, default_value)
end

T['module.function()']['raises error on invalid input'] = function()
  expect.error(function()
    module.function(invalid_arg)
  end, 'Invalid argument')
end
```

### Testing with Dependencies

```lua
T['module with dependencies'] = MiniTest.new_set({
  hooks = {
    pre_case = function()
      -- Mock or stub dependencies if needed
      _G.test_dependency = { mock = true }
    end,
    post_case = function()
      -- Restore
      _G.test_dependency = nil
    end,
  },
})
```

### Testing Async Operations

```lua
T['async operation']['completes successfully'] = function()
  local completed = false
  local result = nil
  
  module.async_function(function(res)
    completed = true
    result = res
  end)
  
  -- Wait for completion (use vim.wait or manual scheduling)
  vim.wait(1000, function() return completed end)
  
  expect.truthy(completed)
  expect.equality(result, expected_result)
end
```
</module_testing_patterns>

## Running Tests

<running_tests>
### Command-Line Execution

```lua
-- In Neovim, run from command line:
:lua MiniTest.run()                    -- Run all tests
:lua MiniTest.run_file()               -- Run current file tests
:lua MiniTest.run_file('path/to/test.lua')  -- Run specific file

-- With options:
:lua MiniTest.run({ execute = { reporter = MiniTest.gen_reporter.stdout() } })
```

### Makefile Integration

```makefile
test-mini: ## run mini.test tests for neovim modules
	echo '##[ $@ ]##'
	pushd dot-config/nvim &>/dev/null
	nvim --headless -u tests/minimal_init.lua \
		-c "lua MiniTest.run()" -c "qa!"
	popd &>/dev/null
	echo '✅ mini.test completed'
```

### Custom TAP Reporter

For CI/CD integration, use TAP (Test Anything Protocol) format:

```lua
-- In minimal_init.lua
local function create_tap_reporter()
  local all_cases = {}
  local reported = {}
  
  local write = function(text)
    io.stdout:write(text .. '\n')
    io.stdout:flush()
  end
  
  return {
    start = function(cases)
      all_cases = cases
      write('TAP version 13')
      write('1..' .. #cases)
    end,
    
    update = function(case_num)
      -- Only report each case once (update is called multiple times)
      if reported[case_num] then return end
      
      local case = all_cases[case_num]
      local exec = case.exec
      
      if not exec then return end
      reported[case_num] = true
      
      local desc = type(case.desc) == 'table' 
        and table.concat(case.desc, ' | ') 
        or tostring(case.desc)
      
      -- Failures have exec.notes, passes don't
      local has_errors = exec.notes and #exec.notes > 0
      
      if has_errors then
        write(string.format('not ok %d - %s', case_num, desc))
        write('  ---')
        write('  message: |')
        for _, note in ipairs(exec.notes) do
          for line in note:gmatch('[^\n]+') do
            write('    ' .. line)
          end
        end
        write('  ...')
      else
        write(string.format('ok %d - %s', case_num, desc))
      end
    end,
    
    finish = function()
      local n_pass, n_fail = 0, 0
      for _, case in ipairs(all_cases) do
        if case.exec then
          if case.exec.notes and #case.exec.notes > 0 then
            n_fail = n_fail + 1
          else
            n_pass = n_pass + 1
          end
        end
      end
      
      write(string.format('# tests %d', #all_cases))
      write(string.format('# pass %d', n_pass))
      write(string.format('# fail %d', n_fail))
      
      vim.cmd(string.format('silent! %scquit', n_fail > 0 and 1 or 0))
    end,
  }
end

-- Use in setup
MiniTest.setup({
  execute = { reporter = create_tap_reporter() },
})
```

**Key points:**
- mini.test doesn't use `state` fields; failures are identified by `exec.notes`
- `update()` is called multiple times per test; track reported cases
- TAP format: `ok N - desc` or `not ok N - desc` with YAML diagnostics
- Exit code: 0 for success, 1 for any failures

### Test Discovery

Place test files in `dot-config/nvim/tests/` with `test_*.lua` pattern for automatic discovery.
Test files must return their test set (`return T`) at the end.
</running_tests>

## Best Practices

<best_practices>
### Test Independence

**Each test should be independent:**

```lua
-- BAD: Tests depend on execution order
T['test 1'] = function()
  _G.shared_state = 42
end

T['test 2'] = function()
  expect.equality(_G.shared_state, 42)  -- Depends on test 1
end

-- GOOD: Tests are self-contained
T['test 1'] = function()
  local state = 42
  expect.equality(state, 42)
end

T['test 2'] = function()
  local state = setup_state()
  expect.equality(state, 42)
end
```

### Cleanup Resources

**Always cleanup in post_case hooks:**

```lua
local T = MiniTest.new_set({
  hooks = {
    post_case = function()
      -- Delete test buffers
      local buffers = vim.api.nvim_list_bufs()
      for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_valid(buf) then
          local name = vim.api.nvim_buf_get_name(buf)
          if name:match('test_') then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end
      
      -- Clear test tab variables
      local tabID = vim.api.nvim_get_current_tabpage()
      for _, var in ipairs({'test_var1', 'test_var2'}) do
        pcall(vim.api.nvim_tabpage_del_var, tabID, var)
      end
    end,
  },
})
```

### Test Description Clarity

```lua
-- BAD: Vague descriptions
T['test 1'] = function() ... end
T['works'] = function() ... end

-- GOOD: Clear, descriptive names
T['M.buffer()']['creates unlisted scratch buffer'] = function() ... end
T['M.buffer()']['returns existing buffer on repeated calls'] = function() ... end
```

### Use Helper Functions

```lua
-- Define helpers at module level
local function create_test_buffer(name)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(bufnr, 'test_' .. name)
  return bufnr
end

local function cleanup_test_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match('^test_') and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

-- Use in tests
T['test case'] = function()
  local buf = create_test_buffer('example')
  -- ... test logic ...
  cleanup_test_buffers()
end
```

### Test Edge Cases

```lua
T['M.function()'] = MiniTest.new_set()

-- Happy path
T['M.function()']['works with valid input'] = function() ... end

-- Edge cases
T['M.function()']['handles nil input'] = function() ... end
T['M.function()']['handles empty string'] = function() ... end
T['M.function()']['handles negative numbers'] = function() ... end
T['M.function()']['handles invalid buffer number'] = function() ... end
```
</best_practices>

## Example: Complete Test File

<example_complete>
```lua
--- Test suite for show module
--- @see dot-config/nvim/lua/show/init.lua

local MiniTest = require('mini.test')
local expect = MiniTest.expect

local T = MiniTest.new_set({
  hooks = {
    post_case = function()
      -- Cleanup all test resources
      local test_vars = {'buf_test', 'buf_test2', 'winID'}
      local tabID = vim.api.nvim_get_current_tabpage()
      
      for _, var in ipairs(test_vars) do
        local ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, tabID, var)
        if ok and vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
        pcall(vim.api.nvim_tabpage_del_var, tabID, var)
      end
    end,
  },
})

local show = require('show')

-- Version tests
T['version'] = MiniTest.new_set()

T['version']['exists and is string'] = function()
  expect.equality(type(show.version), 'string')
end

T['version']['follows semver format'] = function()
  local version = show.version
  local matches = version:match('^%d+%.%d+%.%d+$') ~= nil
  expect.equality(matches, true)
end

-- Buffer management tests
T['M.buffer()'] = MiniTest.new_set()

T['M.buffer()']['creates new buffer when not exists'] = function()
  local bufnr = show.buffer('buf_test')
  
  expect.equality(type(bufnr), 'number')
  expect.equality(bufnr > 0, true)
  expect.equality(vim.api.nvim_buf_is_valid(bufnr), true)
  expect.equality(vim.t.buf_test, bufnr)
end

T['M.buffer()']['returns existing buffer'] = function()
  local bufnr1 = show.buffer('buf_test')
  local bufnr2 = show.buffer('buf_test')
  
  expect.equality(bufnr1, bufnr2)
end

T['M.buffer()']['creates unlisted scratch buffer'] = function()
  local bufnr = show.buffer('buf_test')
  
  expect.equality(vim.bo[bufnr].buflisted, false)
  expect.equality(#vim.bo[bufnr].buftype > 0, true)
end

return T
```
</example_complete>

## Migration from Busted

<migration_from_busted>
### Syntax Comparison

| Busted | mini.test |
|--------|-----------|
| `describe('name', function() end)` | `T['name'] = MiniTest.new_set()` |
| `it('test', function() end)` | `T['test'] = function() end` |
| `before_each(function() end)` | `hooks = { pre_case = function() end }` |
| `after_each(function() end)` | `hooks = { post_case = function() end }` |
| `assert.equals(a, b)` | `expect.equality(a, b)` |
| `assert.is_true(x)` | `expect.equality(x, true)` |
| `assert.is_false(x)` | `expect.equality(x, false)` |
| `assert.is_nil(x)` | `expect.equality(x, nil)` |

### Key Differences

1. **Structure:** mini.test uses table-based test organization vs. function-based in Busted
2. **Hooks:** Hooks defined in `new_set()` options vs. global functions
3. **Nesting:** Natural table nesting vs. function nesting
4. **Assertions:** Only 4 basic expectations (equality, no_equality, error, no_error)
5. **Execution:** Native Neovim integration, no external runner needed
</migration_from_busted>

## Troubleshooting

<troubleshooting>
### Common Issues

**Error: `module 'mini.test' not found`**

Solution: Ensure mini.nvim is installed and add to runtimepath in minimal_init.lua:

```lua
local mini_path = vim.fn.stdpath('data') .. '/site/pack/core/opt/mini.nvim'
vim.opt.runtimepath:append(mini_path)
```

**Error: `attempt to call field 'type' (a nil value)`**

Solution: mini.test doesn't have `expect.type()`. Use `expect.equality(type(value), 'string')` instead.

**Error: `attempt to call field 'truthy' (a nil value)`**

Solution: mini.test doesn't have `expect.truthy()`. Use `expect.equality(condition, true)` instead.

**Error: `attempt to call field 'falsy' (a nil value)`**

Solution: mini.test doesn't have `expect.falsy()`. Use `expect.equality(value, false)` or `expect.equality(value, nil)`.

**Tests not discovered**

Solution: Ensure test files:
1. Are in `tests/` directory
2. Follow `test_*.lua` naming pattern (e.g., `test_show.lua`)
3. Return the test set with `return T`

**Minimal init configuration:**

```lua
--- Minimal init for running mini.test
local config_path = vim.fn.getcwd()
package.path = config_path .. '/lua/?.lua;' .. config_path .. '/lua/?/init.lua;' .. package.path

local mini_path = vim.fn.stdpath('data') .. '/site/pack/core/opt/mini.nvim'
vim.opt.runtimepath:append(mini_path)

_G.MiniTest = require('mini.test')
MiniTest.setup({
  collect = {
    find_files = function()
      return vim.fn.globpath('tests', 'test_*.lua', false, true)
    end,
  },
})
```

**Makefile target:**

```makefile
test-mini: ## run mini.test tests for neovim modules
	echo '##[ $@ ]##'
	pushd dot-config/nvim &>/dev/null
	nvim --headless -u tests/minimal_init.lua \
		-c "lua MiniTest.run()" -c "qa!"
	popd &>/dev/null
	echo '✅ mini.test completed'
```
</troubleshooting>

## References

<references>
- [mini.test Documentation](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-test.md)
- [mini.nvim Examples](https://github.com/echasnovski/mini.nvim/tree/main/tests)
- Neovim API: `:help api`
- LuaCATS annotations: `:help luacats`
</references>
