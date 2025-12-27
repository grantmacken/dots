---
description: 'Create tests for Neovim Lua module functions using mini.test framework. Takes {module_name}.{function_name} argument and generates appropriate test cases following project conventions.'
tools: ['view', 'edit', 'create', 'grep']
model: claude-sonnet-4.5
---

# Test Module Function

<description>
This prompt helps create comprehensive tests for Neovim Lua module functions using the mini.test framework.
Given a function reference in the form `{module_name}.{function_name}`, it examines the module structure,
understands the function's purpose, and generates appropriate test cases following the project's testing conventions.
</description>

## Usage

<usage>
Provide the function to test in dot notation format:

```
{module_name}.{function_name}
```

**Examples:**
- `show.buffer` - Tests the `buffer` function in the `show` module
- `projects.init` - Tests the `init` function in the `projects` module  
- `util.format` - Tests the `format` function in the `util` module

The prompt will:
1. Parse `{module_name}` and `{function_name}` from the argument
2. Read module from `dot-config/nvim/lua/{module_name}/init.lua`
3. Establish the module's intent and purpose
4. Locate the specific function definition
5. Generate comprehensive tests
6. Append to or create test file at `dot-config/nvim/tests/test_{module_name}.lua`
</usage>

## Instructions

<instructions>
Follow these steps to create tests for a module function:

1. **Parse argument:**
   - Extract `module_name` from before the dot
   - Extract `function_name` from after the dot
   - Validate format is `{module_name}.{function_name}`

2. **Examine module structure:**
   - Read `dot-config/nvim/lua/{module_name}/init.lua`
   - Understand the module's overall intent and purpose (from header comments)
   - Locate the function definition for `{function_name}`
   - Understand function parameters, return values, and behavior
   - Note any LuaCATS annotations (@param, @return, etc.)

3. **Check for existing test file:**
   - Look for `dot-config/nvim/tests/test_{module_name}.lua`
   - If exists: read structure and append new tests
   - If not exists: create new test file following template

4. **Generate test cases covering:**
   - Happy path (normal usage)
   - Edge cases (nil, empty, boundary values)
   - Error conditions (invalid input)
   - Side effects (buffer creation, state changes)
   - Integration points (API calls, dependencies)

5. **Follow testing conventions:**
   - Use mini.test framework (not Busted)
   - Use only 4 basic expectations: `equality`, `no_equality`, `error`, `no_error`
   - Hierarchical test organization: `T['{function_name}()']['test case'] = function()`
   - Add cleanup in `post_case` hooks
   - Return test set with `return T`
</instructions>

## Test File Naming Convention

<naming_convention>
- **Module:** `dot-config/nvim/lua/{module_name}/init.lua`
- **Test:** `dot-config/nvim/tests/test_{module_name}.lua`
- **One test file per module** - append new function tests to existing file
</naming_convention>

## Test Template Structure

<test_template>
```lua
--- Test suite for {module_name} module
--- @see dot-config/nvim/lua/{module_name}/init.lua

local MiniTest = require('mini.test')
local expect = MiniTest.expect

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      -- Load module fresh for each test
      package.loaded['{module_name}'] = nil
      _G.{module_name} = require('{module_name}')
    end,
  },
})

-- Test group for function
T['{function_name}()'] = MiniTest.new_set({
  hooks = {
    post_case = function()
      -- Cleanup resources created by tests
    end,
  },
})

T['{function_name}()']['test case description'] = function()
  -- Test implementation
  local result = {module_name}.{function_name}(args)
  expect.equality(result, expected)
end

return T
```
</test_template>

## Assertion Patterns

<assertion_patterns>
mini.test provides only 4 expectations. Use these patterns:

**Type checks:**
```lua
expect.equality(type(value), 'string')
expect.equality(type(value), 'number')
```

**Boolean checks:**
```lua
expect.equality(condition, true)
expect.equality(condition, false)
expect.equality(value ~= nil, true)
```

**Nil checks:**
```lua
expect.equality(value, nil)
```

**Table comparison:**
```lua
expect.equality(actual_table, expected_table)  -- deep equality
```

**Error checking:**
```lua
expect.error(function() module.func(bad_input) end)
expect.no_error(function() module.func(good_input) end)
```
</assertion_patterns>

## Test Organization

<test_organization>
### Hierarchical Structure

```lua
-- Top level: module tests
T['{function_name}()'] = MiniTest.new_set()

-- Test cases: descriptive action phrases
T['{function_name}()']['returns valid result'] = function() end
T['{function_name}()']['handles nil input'] = function() end
T['{function_name}()']['creates expected side effect'] = function() end
```

### Cleanup Pattern

```lua
T['{function_name}()'] = MiniTest.new_set({
  hooks = {
    post_case = function()
      -- Delete test buffers
      local test_vars = {'test_buf1', 'test_buf2'}
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
```
</test_organization>

## Examples

<examples>
### Example 1: Testing a Buffer Creation Function

Module function:
```lua
--- Create buffer by name if it does not exist
---@param name string buffer name
---@return integer bufnr buffer number
M.buffer = function(name)
  local ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, vim.api.nvim_get_current_tabpage(), name)
  if ok then return bufnr end
  
  vim.t[name] = vim.api.nvim_create_buf(false, true)
  return vim.t[name]
end
```

Generated tests:
```lua
T['buffer()'] = MiniTest.new_set({
  hooks = {
    post_case = function()
      local tabID = vim.api.nvim_get_current_tabpage()
      local test_vars = {'test_buf'}
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

T['buffer()']['creates new buffer when not exists'] = function()
  local bufnr = show.buffer('test_buf')
  
  expect.equality(type(bufnr), 'number')
  expect.equality(bufnr > 0, true)
  expect.equality(vim.api.nvim_buf_is_valid(bufnr), true)
end

T['buffer()']['returns existing buffer on second call'] = function()
  local bufnr1 = show.buffer('test_buf')
  local bufnr2 = show.buffer('test_buf')
  
  expect.equality(bufnr1, bufnr2)
end

T['buffer()']['stores buffer in tab variable'] = function()
  local bufnr = show.buffer('test_buf')
  expect.equality(vim.t.test_buf, bufnr)
end
```

### Example 2: Testing a String Processing Function

Module function:
```lua
--- Format string with placeholders
---@param template string template with {key} placeholders
---@param values table key-value pairs
---@return string formatted string
M.format = function(template, values)
  if type(template) ~= 'string' then return '' end
  if type(values) ~= 'table' then return template end
  
  return template:gsub('{(%w+)}', function(key)
    return tostring(values[key] or '')
  end)
end
```

Generated tests:
```lua
T['format()'] = MiniTest.new_set()

T['format()']['replaces placeholders with values'] = function()
  local result = util.format('Hello {name}!', { name = 'World' })
  expect.equality(result, 'Hello World!')
end

T['format()']['handles multiple placeholders'] = function()
  local result = util.format('{a} {b} {c}', { a = '1', b = '2', c = '3' })
  expect.equality(result, '1 2 3')
end

T['format()']['returns empty string for non-string template'] = function()
  expect.equality(util.format(nil, {}), '')
  expect.equality(util.format(123, {}), '')
end

T['format()']['returns template unchanged if values not table'] = function()
  local template = 'Hello {name}'
  expect.equality(util.format(template, nil), template)
  expect.equality(util.format(template, 'string'), template)
end

T['format()']['handles missing keys'] = function()
  local result = util.format('{a} {b}', { a = '1' })
  expect.equality(result, '1 ')
end
```
</examples>

## Checklist

<checklist>
Before submitting tests, verify:

- [ ] Test file named correctly: `test_{module_name}.lua`
- [ ] Tests appended to existing file (if it exists)
- [ ] All tests use mini.test framework
- [ ] Only basic expectations used (`equality`, `no_equality`, `error`, `no_error`)
- [ ] Proper cleanup in `post_case` hooks
- [ ] Test descriptions are clear and descriptive
- [ ] Tests cover happy path, edge cases, and errors
- [ ] File ends with `return T`
- [ ] No busted-style syntax (`describe`, `it`, `assert.*`)
</checklist>

## Workflow

<workflow>
1. **Parse input argument:**
   - Receive argument in format: `{module_name}.{function_name}`
   - Example: `show.buffer` → module_name='show', function_name='buffer'
   - Validate format and extract both parts

2. **Establish module intent:**
   - Read `dot-config/nvim/lua/{module_name}/init.lua`
   - Review header comments to understand module purpose
   - Identify module responsibilities and scope

3. **Examine function:**
   - Locate `{function_name}` definition in module
   - Analyze parameters, return values, behavior
   - Note LuaCATS annotations and inline comments

4. **Check existing tests:**
   - Look for `dot-config/nvim/tests/test_{module_name}.lua`
   - If exists, read to understand structure

5. **Generate tests:**
   - Create test set for function: `T['{function_name}()']`
   - Write test cases for various scenarios
   - Add appropriate cleanup hooks

6. **Append or create:**
   - If test file exists: append new tests before `return T`
   - If test file doesn't exist: create new file with full structure

7. **Verify:**
   - Run tests with `make test-mini`
   - Confirm all tests pass
</workflow>

## References

<references>
- Test naming convention: `.github/instructions/nvim-tests.md` (Naming Convention section)
- mini.test patterns: `.github/instructions/nvim-tests.md` (Assertions section)
- Example tests: `dot-config/nvim/tests/test_show.lua`
</references>
