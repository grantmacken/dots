# Neovim Lua Module Best Practices

Guidelines for creating well-structured, testable, and maintainable Lua modules in this Neovim configuration.

## Directory Structure Pattern

```
dot-config/nvim/
├── lua/
│   └── {module}/
│       └── init.lua          # Module implementation (pure logic)
├── plugin/
│   └── {nn}_{module}.lua     # Application layer (commands, keybinds, autocmds)
└── tests/
    └── test_{module}.lua     # Test suite (busted/mini.test specs)
```

### Example: Show Module Structure

```
dot-config/nvim/
├── lua/
│   └── show/
│       └── init.lua          # Core show module logic
├── plugin/
│   └── 15_show.lua           # User commands and keybinds for show
└── tests/
    └── test_show.lua         # Test specifications
```

## Core Principles

### 1. Separation of Concerns

<principle>
**Module Layer** (`lua/{module}/init.lua`)
- Pure Lua logic and functions
- No user commands, autocommands, or keybinds
- Reusable, testable functions
- Clear public API

**Application Layer** (`plugin/{nn}_{module}.lua`)
- User commands (`:command`)
- Autocommands (`autocmd`)
- Keybinds (`keymap`)
- Integration with Neovim UI
- Calls module functions

**Test Layer** (`tests/test_{module}.lua`)
- Unit tests for module functions
- Integration tests
- Test fixtures and mocks
</principle>

### 2. Module Structure

```lua
--- Module documentation header
--- @module {module_name}

-- Module table (local)
local M = {}

-- Module metadata
M.version = '0.1.0'

-- Private state (if needed)
local state = {
  -- Internal state variables
}

-- Private helper functions
--- @private
local function helper_function()
  -- Implementation
end

-- Public API functions
--- Public function documentation
--- @param name string Parameter description
--- @return boolean success Success status
--- @return string|number result Result or error message
function M.public_function(name)
  -- Implementation
  -- Return tuple: (success, result_or_error)
end

-- Export module
return M
```

### 3. LuaCATS Type Annotations

Use LuaCATS annotations for better LSP support and documentation.

<annotations>
```lua
--- Buffer management function
--- @param name string Buffer name following naming convention
--- @return number bufnr Buffer number (0 on error)
--- @return string message Success or error message
function M.buffer(name)
  -- Implementation
end

--- Type definitions for complex structures
--- @class WindowConfig
--- @field position 'below'|'above'|'left'|'right' Window position
--- @field size number|fun():number Window size or calculator
--- @field relative 'editor'|'win'|'cursor' Position relative to

--- @type WindowConfig
local default_config = {
  position = 'below',
  size = function() return math.floor(vim.o.lines * 0.3) end,
  relative = 'editor',
}

--- Window creation with config
--- @param bufnr number Buffer number
--- @param config? WindowConfig Optional configuration
--- @return number winID Window ID (0 on error)
function M.window(bufnr, config)
  -- Implementation
end
```
</annotations>

### 5. Avoid Deprecated APIs

Always use current Neovim APIs. Deprecated functions will be removed in future versions.

<deprecated_apis>

**Common Deprecated APIs:**

| ❌ Deprecated | ✅ Use Instead | Notes |
|--------------|----------------|-------|
| `vim.loop.*` | `vim.uv.*` | vim.loop is deprecated alias for libuv |
| `vim.api.nvim_buf_get_option(buf, opt)` | `vim.api.nvim_get_option_value(opt, {buf=buf})` | Unified option API |
| `vim.api.nvim_buf_set_option(buf, opt, val)` | `vim.api.nvim_set_option_value(opt, val, {buf=buf})` | Unified option API |
| `vim.api.nvim_win_get_option(win, opt)` | `vim.api.nvim_get_option_value(opt, {win=win})` | Unified option API |
| `vim.api.nvim_win_set_option(win, opt, val)` | `vim.api.nvim_set_option_value(opt, val, {win=win})` | Unified option API |

**Examples:**

```lua
-- ❌ Deprecated
local cwd = vim.loop.cwd()
local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

-- ✅ Current
local cwd = vim.uv.cwd()
local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
```

**Check for Deprecated APIs:**

Run the deprecation checker script to find deprecated API usage:
```bash
./dot-local/bin/check-nvim-deprecated
```

This will scan all Lua files and report deprecated API calls with file locations.

</deprecated_apis>

### 6. Error Handling Pattern

Return tuples for success/failure with descriptive messages and catch runtime errors gracefully.

<error_handling>

**Basic Pattern: Return Tuples**
```lua
--- @return boolean success True if operation succeeded
--- @return string|number result Result on success, error message on failure
function M.operation(param)
  -- Validate input
  if type(param) ~= 'string' then
    return false, 'Invalid parameter type: expected string'
  end
  
  -- Protected call for operations that might fail
  local ok, result = pcall(vim.api.nvim_buf_get_var, bufnr, 'varname')
  if not ok then
    return false, 'Failed to get buffer variable: ' .. result
  end
  
  -- Success case
  return true, result
end

-- Usage in application layer
local success, result = require('module').operation('param')
if not success then
  vim.notify(result, vim.log.levels.ERROR)
  return
end
-- Use result
```

**Catch Neovim Runtime Errors**

Always wrap Neovim API calls in `pcall()` to catch runtime errors gracefully:

```lua
--- Buffer operations with runtime error handling
--- @param bufnr number Buffer number
--- @return boolean success True if operation succeeded
--- @return string message Error or success message
function M.set_buffer_option(bufnr, option, value)
  -- Validate buffer exists
  local valid_ok, is_valid = pcall(vim.api.nvim_buf_is_valid, bufnr)
  if not valid_ok then
    local msg = 'Runtime error checking buffer validity: ' .. tostring(is_valid)
    vim.notify(msg, vim.log.levels.ERROR)
    return false, msg
  end
  
  if not is_valid then
    local msg = 'Buffer ' .. bufnr .. ' is not valid'
    vim.notify(msg, vim.log.levels.ERROR)
    return false, msg
  end
  
  -- Set option with error handling
  local set_ok, err = pcall(vim.api.nvim_buf_set_option, bufnr, option, value)
  if not set_ok then
    local msg = 'Failed to set buffer option "' .. option .. '": ' .. tostring(err)
    vim.notify(msg, vim.log.levels.ERROR)
    return false, msg
  end
  
  return true, 'Option set successfully'
end
```

**Handle Parameter Mismatches**

```lua
--- Window creation with comprehensive error handling
--- @param bufnr number Buffer number
--- @param config table Window configuration
--- @return number winID Window ID (0 on error)
--- @return string message Description of result
function M.create_window(bufnr, config)
  -- Validate parameters before API call
  if type(bufnr) ~= 'number' then
    local msg = 'Invalid bufnr type: expected number, got ' .. type(bufnr)
    vim.notify(msg, vim.log.levels.ERROR)
    return 0, msg
  end
  
  if type(config) ~= 'table' then
    local msg = 'Invalid config type: expected table, got ' .. type(config)
    vim.notify(msg, vim.log.levels.ERROR)
    return 0, msg
  end
  
  -- Wrap API call to catch runtime errors
  local ok, result = pcall(vim.api.nvim_open_win, bufnr, false, config)
  if not ok then
    local msg = 'Failed to create window: ' .. tostring(result)
    vim.notify(msg, vim.log.levels.ERROR)
    return 0, msg
  end
  
  return result, 'Window created successfully'
end
```

**Pattern for Multiple API Calls**

```lua
--- Complex operation with multiple API calls
--- @param name string Buffer name
--- @return number winID Window ID (0 on error)
--- @return string message Description
function M.setup_buffer_window(name)
  -- Step 1: Get buffer
  local buf_ok, bufnr = pcall(vim.api.nvim_create_buf, false, true)
  if not buf_ok then
    local msg = 'Failed to create buffer: ' .. tostring(bufnr)
    vim.notify(msg, vim.log.levels.ERROR)
    return 0, msg
  end
  
  -- Step 2: Set buffer name
  local name_ok, name_err = pcall(vim.api.nvim_buf_set_name, bufnr, name)
  if not name_ok then
    local msg = 'Failed to set buffer name: ' .. tostring(name_err)
    vim.notify(msg, vim.log.levels.ERROR)
    -- Cleanup: delete buffer
    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
    return 0, msg
  end
  
  -- Step 3: Create window
  local win_ok, winID = pcall(vim.api.nvim_open_win, bufnr, false, {
    split = 'below',
    height = 10,
  })
  if not win_ok then
    local msg = 'Failed to open window: ' .. tostring(winID)
    vim.notify(msg, vim.log.levels.ERROR)
    -- Cleanup: delete buffer
    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
    return 0, msg
  end
  
  return winID, 'Buffer and window created successfully'
end
```

**Error Notification Levels**

Use appropriate notification levels:
```lua
-- ERROR: Operation failed, user action may be needed
vim.notify('Failed to save file', vim.log.levels.ERROR)

-- WARN: Operation succeeded but with issues
vim.notify('File saved with warnings', vim.log.levels.WARN)

-- INFO: Normal operation feedback
vim.notify('File saved successfully', vim.log.levels.INFO)

-- DEBUG: Detailed information for troubleshooting
vim.notify('Buffer ' .. bufnr .. ' created', vim.log.levels.DEBUG)
```

**Alternative: Three-value returns for complex operations**
```lua
--- @return number value Primary return value (0 on error)
--- @return string message Descriptive message
--- @return boolean? success Optional explicit success flag
function M.complex_operation()
  -- Returns: (value, message, success)
  -- Or: (0, error_message, false)
end
```

**Error Handling Checklist**:
- ✓ Wrap all vim.api calls in `pcall()`
- ✓ Validate parameter types before API calls
- ✓ Provide descriptive error messages
- ✓ Use `vim.notify()` for user-facing errors
- ✓ Clean up resources on error (buffers, windows, etc.)
- ✓ Return consistent error indicators (false, 0, nil)
- ✓ Include context in error messages (buffer number, option name, etc.)

</error_handling>

### 5. State Management

<state_management>
**Tab-scoped state** (per-project)
```lua
-- Store per-tab state using vim.t (tab-page variables)
function M.get_buffer(name)
  local tabID = vim.api.nvim_get_current_tabpage()
  local ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, tabID, name)
  
  if ok and vim.api.nvim_buf_is_valid(bufnr) then
    return bufnr
  end
  
  return nil
end

function M.set_buffer(name, bufnr)
  vim.t[name] = bufnr
end
```

**Buffer-scoped state**
```lua
-- Store state associated with specific buffer
function M.get_channel(bufnr)
  local ok, chanID = pcall(vim.api.nvim_buf_get_var, bufnr, 'channel')
  return ok and chanID or nil
end

function M.set_channel(bufnr, chanID)
  vim.api.nvim_buf_set_var(bufnr, 'channel', chanID)
end
```

**Module-local state** (avoid global state)
```lua
-- Use local module state, not global variables
local M = {}

local cache = {}  -- Module-local cache

function M.get_cached(key)
  return cache[key]
end
```
</state_management>

### 6. Naming Conventions

<naming>
**Module names**: Single word, lowercase
- `show`, `task`, `project`, `util`

**File naming**:
- Module: `lua/{module}/init.lua`
- Plugin: `plugin/{nn}_{module}.lua` (nn = load order: 01-99)
- Tests: `tests/test_{module}.lua`

**Function naming**:
- Public API: `module.verb_noun()` - `show.create_buffer()`, `show.send()`
- Private helpers: `local function helper_name()` - `local function validate_name()`
- Boolean returns: `is_*`, `has_*`, `should_*` - `is_valid()`, `has_channel()`

**Variable naming**:
- Buffer numbers: `bufnr`
- Window IDs: `winID`
- Tab IDs: `tabID`
- Channel IDs: `chanID`
- Success flags: `success`, `ok`
- Messages: `message`, `msg`, `result`
</naming>

### 7. Buffer Naming Convention

<buffer_names>
From the show module, establish consistent buffer naming:

```lua
-- Valid buffer name patterns
local valid_patterns = {
  '^bufShell$',         -- Single interactive shell per tab
  '^bufScratch$',       -- General scratch buffer
  '^bufTask%[.+%]$',    -- Task buffers: bufTask[taskname]
}

--- Validate buffer name against conventions
--- @param name string Buffer name to validate
--- @return boolean valid True if name matches convention
local function is_valid_buffer_name(name)
  if type(name) ~= 'string' or name == '' then
    return false
  end
  
  for _, pattern in ipairs(valid_patterns) do
    if name:match(pattern) then
      return true
    end
  end
  
  return false
end
```

**Usage examples**:
- `bufShell` - Interactive shell buffer
- `bufScratch` - Temporary scratch space
- `bufTask[build]` - Build task output
- `bufTask[test]` - Test task output
- `bufTask[lint]` - Lint task output
</buffer_names>

### 8. Testing Structure

<testing>
Use mini.test framework with organized test sets:

```lua
--- Test suite for {module} module
--- @see dot-config/nvim/lua/{module}/init.lua

local MiniTest = require('mini.test')
local expect = MiniTest.expect

-- Main test set
local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      -- Setup: Load module fresh for each test
      package.loaded['{module}'] = nil
      _G.{module} = require('{module}')
    end,
    post_case = function()
      -- Teardown: Clean up resources
    end,
  },
})

-- Version tests (always include)
T['version'] = MiniTest.new_set()

T['version']['has version string'] = function()
  expect.equality(type({module}.version), 'string')
end

T['version']['matches semantic versioning format'] = function()
  local matches = {module}.version:match('^%d+%.%d+%.%d+$') ~= nil
  expect.equality(matches, true)
end

-- Feature test sets
T['M.function_name()'] = MiniTest.new_set({
  hooks = {
    post_case = function()
      -- Feature-specific cleanup
    end,
  },
})

T['M.function_name()']['describes expected behavior'] = function()
  -- Arrange
  local input = 'test'
  
  -- Act
  local result = {module}.function_name(input)
  
  -- Assert
  expect.equality(result, expected)
end

return T
```

**Test organization**:
1. **Version tests** - Verify module metadata
2. **Unit tests** - Test individual functions in isolation
3. **Integration tests** - Test function interactions
4. **Edge cases** - Test error handling and boundaries
5. **Cleanup hooks** - Ensure test isolation
</testing>

### 9. Documentation Standards

<documentation>
**Module header**:
```lua
--- Module Name: Brief description
---
--- Longer description explaining the module's purpose and responsibilities.
--- Describe key concepts and design decisions.
---
--- @module {module_name}
--- @version 0.1.0
--- @see dot-config/nvim/plugin/{nn}_{module}.lua for user commands
--- @see dot-config/nvim/tests/test_{module}.lua for test suite
```

**Function documentation**:
```lua
--- Brief one-line description of what the function does
---
--- Longer explanation if needed, describing behavior, side effects,
--- and important details about the function's operation.
---
--- @param name string Description of parameter
--- @param count? number Optional parameter (note the ?)
--- @param opts? table Optional configuration table
--- @return boolean success True if operation succeeded
--- @return string message Descriptive success or error message
--- @usage
---   local success, msg = module.function_name('test')
---   if not success then
---     vim.notify(msg, vim.log.levels.ERROR)
---   end
function M.function_name(name, count, opts)
  -- Implementation
end
```

**Inline comments**:
- Explain **why**, not **what** (code shows what)
- Document non-obvious behavior
- Note side effects and state changes
- Reference related functions or issues

```lua
-- Create buffer below current window to maintain context
-- Uses 30% of screen height for consistent UX across terminals
local winID = vim.api.nvim_open_win(bufnr, false, {
  split = 'below',
  height = math.floor(vim.o.lines * 0.3),
})
```
</documentation>

### 10. Public API Design

<api_design>
**Principle**: Module should have clear, minimal public API

```lua
-- Good: Clear, focused public API
M.buffer = function(name) end          -- Get/create buffer
M.window = function(bufnr) end         -- Get/create window
M.send = function(name, data) end      -- Send data to buffer
M.kill_buffer = function(name) end     -- Clean up buffer

-- Avoid: Too many similar functions
M.get_buffer = function() end
M.create_buffer = function() end
M.find_buffer = function() end
M.buffer_exists = function() end
-- Better: One function that handles all cases
M.buffer = function(name) end  -- Gets or creates
```

**Convenience functions** for common patterns:
```lua
--- High-level convenience function
--- Combines buffer(), window(), and send() operations
--- @param data string Data to send
function M.scratch_send(data)
  local bufnr, buf_msg = M.buffer('bufScratch')
  if bufnr == 0 then
    vim.notify(buf_msg, vim.log.levels.ERROR)
    return
  end
  
  local winID, win_msg = M.window(bufnr)
  if winID == 0 then
    vim.notify(win_msg, vim.log.levels.ERROR)
    return
  end
  
  M.send('bufScratch', data)
end
```
</api_design>

### 11. Idempotency Pattern

<idempotency>
Functions should be safe to call multiple times:

```lua
--- Get or create buffer - idempotent operation
--- Calling multiple times returns same buffer
--- @param name string Buffer name
--- @return number bufnr Buffer number (0 on error)
function M.buffer(name)
  -- Check if buffer already exists
  local tabID = vim.api.nvim_get_current_tabpage()
  local ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, tabID, name)
  
  if ok and vim.api.nvim_buf_is_valid(bufnr) then
    return bufnr, 'Buffer already exists'
  end
  
  -- Create new buffer only if needed
  bufnr = vim.api.nvim_create_buf(false, true)
  vim.t[name] = bufnr
  
  return bufnr, 'Buffer created'
end
```

**Benefits**:
- Safe to call repeatedly
- No duplicate resources
- Predictable behavior
- Easier to test
</idempotency>

### 12. Plugin Application Layer

<plugin_layer>
The `plugin/{nn}_{module}.lua` file contains UI integration:

```lua
--- @see dot-config/nvim/plugin/15_show.lua for commands that use the show module
--- @see dot-config/nvim/lua/show/init.lua the show module

-- User Commands
vim.api.nvim_create_user_command(
  'ShowScratch',
  function()
    require('show').scratch_send('Scratch buffer opened')
  end,
  { desc = 'Open scratch buffer in show window' }
)

-- Autocommands
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.lua',
  callback = function()
    local show = require('show')
    show.scratch_send('Lua file saved: ' .. vim.fn.expand('%:t'))
  end,
  desc = 'Notify on Lua file save',
})

-- Keybindings
vim.keymap.set('n', '<leader>ss', function()
  require('show').scratch_send('Triggered via keymap')
end, { desc = 'Show scratch buffer' })

-- No module logic here - only UI bindings
```

**Load order** (nn prefix):
- `01-09`: Core utilities and dependencies
- `10-19`: UI and display modules
- `20-29`: LSP and completion
- `30-39`: File navigation
- `40-49`: Git integration
- `50+`: Optional enhancements
</plugin_layer>

### 13. Module Dependencies

<dependencies>
**Lazy loading**: Modules should `require()` at call time, not at module load time:

```lua
-- Bad: Loads dependency immediately
local other_module = require('other_module')

function M.do_something()
  other_module.function()
end

-- Good: Loads dependency when needed
function M.do_something()
  local other_module = require('other_module')
  other_module.function()
end

-- Good: Cache if called frequently in same session
local other_module
function M.do_something()
  other_module = other_module or require('other_module')
  other_module.function()
end
```

**Minimize dependencies**: Keep modules focused and self-contained.
</dependencies>

### 14. Validation Pattern

<validation>
Validate inputs early and provide clear error messages:

```lua
--- Buffer creation with validation
--- @param name string Buffer name
--- @return number bufnr Buffer number (0 on error)
--- @return string message Description
function M.buffer(name)
  -- Type validation
  if type(name) ~= 'string' then
    return 0, 'Error: buffer name must be a string, got ' .. type(name)
  end
  
  -- Empty check
  if name == '' then
    return 0, 'Error: buffer name cannot be empty'
  end
  
  -- Pattern validation
  if not is_valid_buffer_name(name) then
    return 0, 'Error: invalid buffer name "' .. name .. '". ' ..
              'Must be bufShell, bufScratch, or bufTask[name]'
  end
  
  -- Proceed with operation
  -- ...
end
```

**Validation checklist**:
- Type checking
- Nil checking
- Range checking
- Pattern matching
- Resource existence
</validation>

## Complete Example: Counter Module

<example>
```lua
-- lua/counter/init.lua
--- Simple counter module demonstrating best practices
--- @module counter
--- @version 0.1.0

local M = {}

M.version = '0.1.0'

-- Private state
local counts = {}

--- Get current count for named counter
--- @param name string Counter name
--- @return number count Current count value
function M.get(name)
  if type(name) ~= 'string' or name == '' then
    return 0
  end
  return counts[name] or 0
end

--- Increment counter
--- @param name string Counter name
--- @param delta? number Amount to increment (default: 1)
--- @return number count New count value
function M.increment(name, delta)
  delta = delta or 1
  
  if type(name) ~= 'string' or name == '' then
    return 0
  end
  
  counts[name] = (counts[name] or 0) + delta
  return counts[name]
end

--- Reset counter
--- @param name string Counter name
--- @return boolean success True if counter existed
function M.reset(name)
  if type(name) ~= 'string' or name == '' then
    return false
  end
  
  local existed = counts[name] ~= nil
  counts[name] = nil
  return existed
end

return M
```

```lua
-- plugin/20_counter.lua
--- Counter plugin commands
--- @see dot-config/nvim/lua/counter/init.lua

vim.api.nvim_create_user_command('CounterIncrement', function(opts)
  local counter = require('counter')
  local name = opts.args ~= '' and opts.args or 'default'
  local count = counter.increment(name)
  vim.notify('Counter ' .. name .. ': ' .. count)
end, {
  nargs = '?',
  desc = 'Increment named counter',
})

vim.api.nvim_create_user_command('CounterReset', function(opts)
  local counter = require('counter')
  local name = opts.args ~= '' and opts.args or 'default'
  counter.reset(name)
  vim.notify('Counter ' .. name .. ' reset')
end, {
  nargs = '?',
  desc = 'Reset named counter',
})
```

```lua
-- tests/test_counter.lua
--- Test suite for counter module
local MiniTest = require('mini.test')
local expect = MiniTest.expect

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      package.loaded['counter'] = nil
      _G.counter = require('counter')
    end,
  },
})

T['get()']['returns zero for new counter'] = function()
  expect.equality(counter.get('test'), 0)
end

T['increment()']['increases counter by one'] = function()
  local count = counter.increment('test')
  expect.equality(count, 1)
end

T['increment()']['increases counter by delta'] = function()
  local count = counter.increment('test', 5)
  expect.equality(count, 5)
end

T['reset()']['clears counter value'] = function()
  counter.increment('test')
  counter.reset('test')
  expect.equality(counter.get('test'), 0)
end

return T
```
</example>

## Code Review Checkpoint: Runtime Error Detection

<checkpoint>
When reviewing module code, Copilot should actively identify potential runtime errors and provide guidance:

### Detection Criteria

**Identify functions with potential runtime errors**:
1. Unprotected `vim.api.*` calls (not wrapped in `pcall()`)
2. Missing parameter type validation
3. Assumptions about resource existence (buffers, windows, tabs)
4. Unhandled return values from API calls
5. Missing nil checks before using values
6. Array/table indexing without existence checks

### Review Response Format

When potential runtime errors are detected, provide feedback in this format:

```
⚠️ RUNTIME ERROR RISKS DETECTED

Function: M.function_name()
Location: lua/module/init.lua:line_number

Issues:
1. Line X: Unprotected API call `vim.api.nvim_buf_set_option(bufnr, ...)`
   Risk: Buffer may be invalid causing runtime error
   Fix: Wrap in pcall() and handle error

2. Line Y: Missing parameter validation for `bufnr`
   Risk: Function called with wrong type will crash
   Fix: Add type check at function start

3. Line Z: No nil check after `vim.fn.somefunction()`
   Risk: Return value could be nil
   Fix: Validate return before using

Suggested refactor:
[Provide code snippet showing corrected version]

Status: ⚠️ INCOMPLETE - Needs error handling improvements
```

### Marking Functions

**Mark function status based on compliance**:

```lua
--- Function description
--- @status complete ✓ All error handling in place
--- @status incomplete ⚠️ Needs error handling improvements
--- @status review 🔍 Complex logic, needs verification
```

### Example Review Comments

**Before (Non-compliant)**:
```lua
--- Get buffer variable
--- @status incomplete ⚠️ Missing pcall protection
function M.get_var(bufnr, name)
  -- ISSUE: Unprotected API call - can throw runtime error
  return vim.api.nvim_buf_get_var(bufnr, name)
end
```

**After (Compliant)**:
```lua
--- Get buffer variable with error handling
--- @status complete ✓
--- @param bufnr number Buffer number
--- @param name string Variable name
--- @return boolean success True if variable retrieved
--- @return any value Variable value or error message
function M.get_var(bufnr, name)
  -- Validate parameters
  if type(bufnr) ~= 'number' then
    return false, 'Invalid bufnr: expected number, got ' .. type(bufnr)
  end
  
  if type(name) ~= 'string' or name == '' then
    return false, 'Invalid variable name'
  end
  
  -- Protected API call
  local ok, value = pcall(vim.api.nvim_buf_get_var, bufnr, name)
  if not ok then
    return false, 'Failed to get buffer variable: ' .. tostring(value)
  end
  
  return true, value
end
```

### Common Patterns to Flag

**Pattern 1: Direct API calls**
```lua
-- ⚠️ FLAG THIS
local winID = vim.api.nvim_open_win(bufnr, false, opts)

-- ✓ SUGGEST THIS
local ok, winID = pcall(vim.api.nvim_open_win, bufnr, false, opts)
if not ok then
  return 0, 'Failed to open window: ' .. tostring(winID)
end
```

**Pattern 2: Missing validation**
```lua
-- ⚠️ FLAG THIS
function M.set_option(bufnr, opt, val)
  vim.api.nvim_buf_set_option(bufnr, opt, val)
end

-- ✓ SUGGEST THIS
function M.set_option(bufnr, opt, val)
  if type(bufnr) ~= 'number' then
    return false, 'Invalid buffer number'
  end
  
  local ok, err = pcall(vim.api.nvim_buf_set_option, bufnr, opt, val)
  if not ok then
    return false, 'Failed to set option: ' .. tostring(err)
  end
  
  return true, 'Option set'
end
```

**Pattern 3: Assuming resources exist**
```lua
-- ⚠️ FLAG THIS
function M.use_buffer(name)
  local bufnr = vim.t[name]
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {'text'})
end

-- ✓ SUGGEST THIS
function M.use_buffer(name)
  local bufnr = vim.t[name]
  
  if not bufnr then
    return false, 'Buffer not found: ' .. name
  end
  
  local ok, is_valid = pcall(vim.api.nvim_buf_is_valid, bufnr)
  if not ok or not is_valid then
    return false, 'Buffer is invalid'
  end
  
  local set_ok, err = pcall(vim.api.nvim_buf_set_lines, bufnr, 0, -1, false, {'text'})
  if not set_ok then
    return false, 'Failed to set lines: ' .. tostring(err)
  end
  
  return true, 'Lines set'
end
```

### Review Workflow

When asked to review module code:

1. **Scan for runtime risks** - Check each function
2. **Prioritize by severity** - Critical bugs first
3. **Provide specific feedback** - Line numbers and exact issues
4. **Suggest concrete fixes** - Show corrected code
5. **Mark completion status** - Use status annotations
6. **Explain rationale** - Why the error could occur

### Interactive Review Commands

Copilot should respond to:
- "Review this function for runtime errors"
- "Check if this module follows error handling guidelines"
- "Mark incomplete functions in this module"
- "Suggest fixes for runtime errors in this code"

</checkpoint>

## Checklist for New Modules

<checklist>
- [ ] Module in `lua/{module}/init.lua`
- [ ] Plugin application in `plugin/{nn}_{module}.lua`
- [ ] Test suite in `tests/test_{module}.lua`
- [ ] Module has `version` field
- [ ] LuaCATS annotations for all public functions
- [ ] Error handling with descriptive messages
- [ ] Input validation
- [ ] Idempotent operations where applicable
- [ ] No global state (use local or scoped state)
- [ ] Clear separation: logic in module, UI in plugin
- [ ] Documentation: module header and function docs
- [ ] Tests cover happy path and error cases
- [ ] Cross-references in `@see` tags
- [ ] **All vim.api calls wrapped in pcall()**
- [ ] **Parameter types validated before use**
- [ ] **Resource existence verified before access**
- [ ] **All functions marked with @status annotation**
</checklist>

## References

- **LuaCATS**: https://luals.github.io/wiki/annotations
- **Neovim Lua Guide**: `:help lua-guide`
- **mini.test**: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-test.md
- **Busted**: https://olivinelabs.com/busted/

---

*This document reflects patterns from the `show` module and establishes conventions for all Lua modules in this Neovim configuration.*
