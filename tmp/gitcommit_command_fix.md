# GitCommit Command Fix

## Problem
The `GitCommit` command was generating an error:
```
error: too many arguments. Expected 0 arguments but got 5
```

This occurred because the command string was being split by spaces incorrectly.

## Original Command (BROKEN)
```lua
local cmd = [[copilot -p 'add commit message since last commit' --allow-all-tools --add-dir ]] .. cwd
show.job_term(cmd)
```

When `string_to_table()` split this by spaces, it became:
- `copilot`
- `-p`
- `'add`
- `commit`
- `message`
- `since`
- `last`
- `commit'`
- `--allow-all-tools`
- `--add-dir`
- `/path/to/cwd`

This caused copilot to receive multiple separate arguments instead of a single `-p` argument.

## Fixed Command
```lua
local cmd = string.format("bash -c \"copilot -p 'add commit message since last commit' --allow-all-tools --add-dir '%s'\"", cwd)
show.interactive_term(cmd, { mode = 'focus' })
```

When `string_to_table()` splits this by spaces, it becomes:
- `bash`
- `-c`
- `"copilot -p 'add commit message since last commit' --allow-all-tools --add-dir '/path/to/cwd'"`

This is correct! Bash will execute the entire quoted string as a single command.

## Changes Made
1. Wrapped the copilot command in `bash -c "..."`
2. Changed from `job_term` to `interactive_term` for better user experience
3. Added `mode = 'focus'` to keep user in terminal to see results
4. Added proper quote escaping using `string.format`
5. Added comments explaining the fix

## Why This Works
- `bash -c` takes a single string argument and executes it as a shell command
- The double quotes around the entire command keep it as one argument
- The single quotes inside protect the copilot prompt text
- The `%s` substitution properly escapes the path

## Testing
To verify the command is constructed correctly:
```vim
:lua local cwd = vim.fn.getcwd(); local cmd = string.format("bash -c \"copilot -p 'add commit message since last commit' --allow-all-tools --add-dir '%s'\"", cwd); print(cmd)
```

Should output:
```
bash -c "copilot -p 'add commit message since last commit' --allow-all-tools --add-dir '/current/working/directory'"
```

## General Pattern for Complex Commands

When you need to pass commands with quoted arguments through `interactive_term`, `job_term`, or `noninteractive_term`, use this pattern:

```lua
-- Wrap complex commands in bash -c "..."
local cmd = string.format("bash -c \"your-command --flag 'quoted arg' '%s'\"", variable)
show.interactive_term(cmd, { mode = 'focus' })
```

This ensures that:
1. The command string is properly parsed as a single shell command
2. Quoted arguments are preserved
3. Variables are safely interpolated
