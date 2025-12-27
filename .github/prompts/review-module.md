---
description: 'Review Neovim Lua module functions for runtime error risks and guideline compliance. Takes {module_name}.{function_name} argument and provides detailed analysis following error handling checkpoints.'
tools: ['view', 'grep']
model: claude-sonnet-4
---

# Review Module Function

<description>
This prompt performs comprehensive code review of Neovim Lua module functions, identifying potential runtime errors and verifying compliance with error handling guidelines. Given a function reference in the form `{module_name}.{function_name}`, it analyzes the code for unprotected API calls, missing validation, and other runtime risks.
</description>

## Usage

<usage>
Provide the function to review in dot notation format:

```
{module_name}.{function_name}
```

**Examples:**
- `show.buffer` - Reviews the `buffer` function in the `show` module
- `show.window` - Reviews the `window` function in the `show` module
- `projects.init` - Reviews the `init` function in the `projects` module
- `util.format` - Reviews the `format` function in the `util` module

The prompt will:
1. Parse `{module_name}` and `{function_name}` from the argument
2. Read module from `dot-config/nvim/lua/{module_name}/init.lua`
3. Locate the specific function definition
4. Scan for runtime error risks following checkpoint guidelines
5. Provide detailed feedback with line numbers and suggested fixes
6. Mark function status (complete ✓, incomplete ⚠️, or review 🔍)
</usage>

## Instructions

<instructions>
Follow these steps to review a module function:

1. **Parse argument:**
   - Extract `module_name` from before the dot
   - Extract `function_name` from after the dot
   - Validate format is `{module_name}.{function_name}`

2. **Load guidelines:**
   - Reference `.github/instructions/nvim-lua-modules.md`
   - Focus on "Error Handling Pattern" and "Code Review Checkpoint" sections
   - Apply detection criteria and patterns

3. **Examine function:**
   - Read `dot-config/nvim/lua/{module_name}/init.lua`
   - Locate the function definition for `{function_name}`
   - Note line numbers for the function's start and end
   - Analyze each line for potential runtime errors

4. **Scan for runtime risks:**
   - Unprotected `vim.api.*` calls (not wrapped in `pcall()`)
   - Missing parameter type validation
   - Assumptions about resource existence (buffers, windows, tabs)
   - Unhandled return values from API calls
   - Missing nil checks before using values
   - Array/table indexing without existence checks

5. **Generate review report:**
   - List all detected issues with specific line numbers
   - Explain risk for each issue
   - Suggest concrete fixes
   - Provide refactored code snippet if needed
   - Mark overall function status

6. **Interactive issue resolution:**
   - Present summary of all issues found
   - Prompt user to work through issues as a checklist
   - For each issue, present options:
     - **[A]pply suggested fix** - Implement the recommended solution
     - **[S]kip** - Move to next issue without changes
     - **[M]odify** - Let user describe alternative approach
     - **[Q]uit** - Stop processing remaining issues
   - After each issue is resolved, update code and continue
   - Provide final summary of changes made

7. **Provide feedback:**
   - Use structured review format (see template below)
   - Prioritize issues by severity
   - Include code examples showing corrections
   - Explain rationale for each suggestion
</instructions>

## Review Report Template

<review_template>
```
⚠️ RUNTIME ERROR RISKS DETECTED

Module: {module_name}
Function: M.{function_name}()
Location: dot-config/nvim/lua/{module_name}/init.lua:line_start-line_end

Issues Found: {count}

1. Line {X}: Unprotected API call
   Code: `vim.api.nvim_buf_set_option(bufnr, ...)`
   Risk: Buffer may be invalid causing runtime error
   Severity: HIGH
   Fix: Wrap in pcall() and handle error

2. Line {Y}: Missing parameter validation
   Code: `function M.{function_name}(bufnr)`
   Risk: Function called with wrong type will crash
   Severity: HIGH
   Fix: Add type check at function start

3. Line {Z}: Unverified resource access
   Code: `local bufnr = vim.t[name]`
   Risk: Variable may not exist or buffer may be invalid
   Severity: MEDIUM
   Fix: Use pcall() and validate buffer before use

Suggested Refactor:
---
[Provide corrected code snippet here]
---

Status: ⚠️ INCOMPLETE - Needs error handling improvements
Priority: HIGH - Critical runtime errors possible

Recommendations:
- Add parameter validation at function entry
- Wrap all vim.api calls in pcall()
- Verify resource existence before access
- Add descriptive error messages
- Use vim.notify() for user-facing errors
```
</review_template>

## Detection Patterns

<detection_patterns>
### Pattern 1: Unprotected vim.api Calls

**Flag this:**
```lua
local winID = vim.api.nvim_open_win(bufnr, false, opts)
local value = vim.api.nvim_buf_get_var(bufnr, 'name')
vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
```

**Should be:**
```lua
local ok, winID = pcall(vim.api.nvim_open_win, bufnr, false, opts)
if not ok then
  vim.notify('Failed to open window: ' .. tostring(winID), vim.log.levels.ERROR)
  return 0, 'Window creation failed'
end
```

### Pattern 2: Missing Parameter Validation

**Flag this:**
```lua
function M.set_option(bufnr, opt, val)
  vim.api.nvim_buf_set_option(bufnr, opt, val)
end
```

**Should be:**
```lua
function M.set_option(bufnr, opt, val)
  if type(bufnr) ~= 'number' then
    return false, 'Invalid buffer number'
  end
  if type(opt) ~= 'string' or opt == '' then
    return false, 'Invalid option name'
  end
  
  local ok, err = pcall(vim.api.nvim_buf_set_option, bufnr, opt, val)
  if not ok then
    vim.notify('Failed to set option: ' .. tostring(err), vim.log.levels.ERROR)
    return false, 'Option set failed'
  end
  
  return true, 'Option set'
end
```

### Pattern 3: Unverified Resource Access

**Flag this:**
```lua
function M.use_buffer(name)
  local bufnr = vim.t[name]
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {'text'})
end
```

**Should be:**
```lua
function M.use_buffer(name)
  local bufnr = vim.t[name]
  
  if not bufnr then
    vim.notify('Buffer not found: ' .. name, vim.log.levels.ERROR)
    return false, 'Buffer not found'
  end
  
  local ok, is_valid = pcall(vim.api.nvim_buf_is_valid, bufnr)
  if not ok or not is_valid then
    vim.notify('Buffer is invalid', vim.log.levels.ERROR)
    return false, 'Buffer invalid'
  end
  
  local set_ok, err = pcall(vim.api.nvim_buf_set_lines, bufnr, 0, -1, false, {'text'})
  if not set_ok then
    vim.notify('Failed to set lines: ' .. tostring(err), vim.log.levels.ERROR)
    return false, 'Set lines failed'
  end
  
  return true, 'Lines set'
end
```

### Pattern 4: Missing Nil Checks

**Flag this:**
```lua
function M.get_config()
  local config = vim.g.my_config
  return config.setting
end
```

**Should be:**
```lua
function M.get_config()
  local config = vim.g.my_config
  
  if not config then
    return nil, 'Config not found'
  end
  
  if type(config) ~= 'table' then
    return nil, 'Config is not a table'
  end
  
  return config.setting, 'Config retrieved'
end
```

### Pattern 5: Array Indexing Without Checks

**Flag this:**
```lua
function M.get_first_line(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  return lines[1]
end
```

**Should be:**
```lua
function M.get_first_line(bufnr)
  if type(bufnr) ~= 'number' then
    return nil, 'Invalid buffer number'
  end
  
  local ok, lines = pcall(vim.api.nvim_buf_get_lines, bufnr, 0, -1, false)
  if not ok then
    vim.notify('Failed to get lines: ' .. tostring(lines), vim.log.levels.ERROR)
    return nil, 'Failed to get lines'
  end
  
  if not lines or #lines == 0 then
    return nil, 'Buffer is empty'
  end
  
  return lines[1], 'Line retrieved'
end
```
</detection_patterns>

## Severity Levels

<severity_levels>
**HIGH** - Will cause runtime error/crash:
- Unprotected vim.api calls that can throw
- Missing type checks before API calls
- Nil dereference (accessing fields on nil)

**MEDIUM** - May cause runtime error in edge cases:
- Missing validation of optional parameters
- Unverified resource existence
- Unhandled edge cases (empty tables, etc.)

**LOW** - Doesn't follow best practices:
- Missing descriptive error messages
- Inconsistent return patterns
- No vim.notify() for user feedback
</severity_levels>

## Status Annotations

<status_annotations>
Mark functions with appropriate status:

**✓ COMPLETE** - Criteria:
- All vim.api calls wrapped in pcall()
- All parameters validated
- Resources verified before access
- Descriptive error messages
- Consistent return patterns

**⚠️ INCOMPLETE** - Criteria:
- Missing pcall() on some API calls
- Partial parameter validation
- Some unverified resource access
- Needs error handling improvements

**🔍 REVIEW** - Criteria:
- Complex logic that's hard to analyze
- Multiple nested API calls
- Unclear error handling flow
- Requires human review
</status_annotations>

## Examples

<examples>
### Example 1: Reviewing show.buffer()

**Input:** `show.buffer`

**Review Output:**
```
⚠️ RUNTIME ERROR RISKS DETECTED

Module: show
Function: M.buffer()
Location: dot-config/nvim/lua/show/init.lua:45-78

Issues Found: 3

1. Line 58: Unprotected API call
   Code: `bufnr = vim.api.nvim_create_buf(false, true)`
   Risk: Buffer creation can fail, causing runtime error
   Severity: HIGH
   Fix: Wrap in pcall() and handle error

2. Line 48: Minimal parameter validation
   Code: Type check exists but pattern validation is separate
   Risk: Invalid buffer names could cause issues later
   Severity: MEDIUM
   Fix: Combine validation and provide clear error early

3. Line 62: Direct API call for buffer name
   Code: `vim.api.nvim_buf_set_name(bufnr, name)`
   Risk: Setting name can fail if name already in use
   Severity: HIGH
   Fix: Wrap in pcall() and handle collision

Suggested Refactor:
---
function M.buffer(name)
  -- Validate parameter type
  if type(name) ~= 'string' then
    local msg = 'Invalid buffer name type: expected string, got ' .. type(name)
    vim.notify(msg, vim.log.levels.ERROR)
    return 0, msg
  end
  
  -- Validate buffer name pattern
  if not is_valid_buffer_name(name) then
    local msg = 'Invalid buffer name: ' .. name
    vim.notify(msg, vim.log.levels.ERROR)
    return 0, msg
  end
  
  -- Check if buffer already exists
  local tabID = vim.api.nvim_get_current_tabpage()
  local ok, bufnr = pcall(vim.api.nvim_tabpage_get_var, tabID, name)
  
  if ok and bufnr then
    local valid_ok, is_valid = pcall(vim.api.nvim_buf_is_valid, bufnr)
    if valid_ok and is_valid then
      return bufnr, 'Buffer exists'
    end
  end
  
  -- Create new buffer with error handling
  local create_ok, new_bufnr = pcall(vim.api.nvim_create_buf, false, true)
  if not create_ok then
    local msg = 'Failed to create buffer: ' .. tostring(new_bufnr)
    vim.notify(msg, vim.log.levels.ERROR)
    return 0, msg
  end
  
  -- Set buffer name with error handling
  local name_ok, name_err = pcall(vim.api.nvim_buf_set_name, new_bufnr, name)
  if not name_ok then
    pcall(vim.api.nvim_buf_delete, new_bufnr, { force = true })
    local msg = 'Failed to set buffer name: ' .. tostring(name_err)
    vim.notify(msg, vim.log.levels.ERROR)
    return 0, msg
  end
  
  vim.t[name] = new_bufnr
  return new_bufnr, 'Buffer created'
end
---

Status: ⚠️ INCOMPLETE - Needs error handling improvements
Priority: HIGH - Function is core to module, needs robust error handling

Recommendations:
1. Add pcall() wrappers for all API calls
2. Clean up resources on partial failure
3. Provide specific error messages for each failure mode
4. Consider adding @status annotation to function doc
```

### Example 2: Reviewing a compliant function

**Input:** `util.validate`

**Review Output:**
```
✓ NO RUNTIME ERROR RISKS DETECTED

Module: util
Function: M.validate()
Location: dot-config/nvim/lua/util/init.lua:12-35

Analysis:
- All parameters validated with type checks
- No vim.api calls (pure Lua function)
- Handles nil and edge cases
- Returns consistent tuple pattern
- Clear error messages

Status: ✓ COMPLETE - Follows all guidelines
Priority: NONE - No issues found

The function demonstrates excellent practices:
- Early parameter validation
- No external API dependencies
- Predictable behavior
- Well documented

No changes recommended.
```
</examples>

## Review Workflow

<workflow>
1. **Parse input:**
   - Extract module and function names from `{module_name}.{function_name}`
   - Validate format

2. **Locate function:**
   - Read `dot-config/nvim/lua/{module_name}/init.lua`
   - Find function definition line numbers
   - Extract function code

3. **Analyze line by line:**
   - Check each line against detection patterns
   - Note line numbers of issues
   - Categorize by severity

4. **Generate report:**
   - List all issues with context
   - Provide specific fixes for each
   - Create refactored code example
   - Assign status and priority

5. **Interactive resolution:**
   - Present summary: "Found {count} issues. Work through them?"
   - For each issue in order of severity (HIGH → MEDIUM → LOW):
     ```
     Issue {n}/{total}: {description}
     Line {X}: {code_snippet}
     Risk: {explanation}
     Severity: {level}
     
     Suggested fix:
     {fix_code_snippet}
     
     Options:
     [A]pply - Implement this fix
     [S]kip - Move to next issue
     [M]odify - Describe alternative approach
     [Q]uit - Stop and show summary
     
     Your choice:
     ```
   - Wait for user response before proceeding
   - Apply changes immediately if user chooses [A]pply
   - Continue until all issues addressed or user quits

6. **Final summary:**
   - Show all changes made
   - List skipped issues
   - Update function status
   - Provide next steps if incomplete
</workflow>

## Checklist

<checklist>
Before completing review, verify:

- [ ] Function located and analyzed completely
- [ ] All vim.api calls identified
- [ ] Parameter validation checked
- [ ] Resource access patterns examined
- [ ] Line numbers provided for all issues
- [ ] Severity assigned to each issue
- [ ] Fixes suggested for all issues
- [ ] Refactored code provided if needed
- [ ] Status annotation assigned
- [ ] Priority level determined
</checklist>

## References

<references>
- Error handling guidelines: `.github/instructions/nvim-lua-modules.md` (Error Handling Pattern)
- Review checkpoint: `.github/instructions/nvim-lua-modules.md` (Code Review Checkpoint)
- Module structure: `.github/instructions/nvim-lua-modules.md` (Module Structure)
- Example module: `dot-config/nvim/lua/show/init.lua`
</references>
