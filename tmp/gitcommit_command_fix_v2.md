# GitCommit Command Fix v2

## Problem Evolution

### Initial Problem
The `GitCommit` command was generating an error:
```
error: too many arguments. Expected 0 arguments but got 5
```

### First Fix Attempt (DIDN'T WORK)
Wrapped command in `bash -c "..."` and used `interactive_term()`:
```lua
local cmd = string.format("bash -c \"copilot -p 'add commit message since last commit' --allow-all-tools --add-dir '%s'\"", cwd)
show.interactive_term(cmd, { mode = 'focus' })
```

**Problem**: `interactive_term()` uses `string_to_table()` to split the command by spaces, then sends it as a table to `chansend()`. This broke the carefully constructed bash -c wrapper.

Result was the terminal showing:
```
'add
commit  
message
since
last
commit'
--allow-all-tools
--add-dir
'/var/home/gmack/Projects/dots': No such file or directory
```

## Final Working Solution

Send the raw command string directly to the shell via `chansend()` without using `interactive_term()`:

```lua
vim.api.nvim_create_user_command(
  'GitCommit',
  function()
    local show = require('show')
    local cwd = vim.fn.getcwd()
    local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
    if cwd ~= git_root then
      print('Not in a git repository')
      return
    end

    -- Build the command as a raw string to send directly to the shell
    local cmd = string.format("copilot -p 'add commit message since last commit' --allow-all-tools --add-dir '%s'", cwd)
    vim.notify('Running command: ' .. cmd, vim.log.levels.INFO)
    
    -- Ensure interactive terminal is open
    show.interactive_term_open()
    
    -- Get buffer and channel
    local bufnr = vim.t.interactive_term_buf
    local win = vim.t.show_win
    local chan = vim.bo[bufnr].channel
    
    if chan and chan > 0 then
      -- Send the raw command string directly to the shell with newline
      vim.schedule(function()
        vim.fn.chansend(chan, cmd .. '\n')
        vim.api.nvim_set_current_win(win)
        vim.cmd.startinsert()
      end)
    else
      vim.notify('Failed to get terminal channel', vim.log.levels.ERROR)
    end
  end,
  { desc = 'Use Copilot to generate a git commit message' }
)
```

## Why This Works

1. **No string_to_table()**: Bypasses the splitting logic entirely
2. **Direct chansend()**: Sends the command as a single string to the shell
3. **Quotes preserved**: Single quotes around the prompt text stay intact
4. **Shell interprets**: The running shell in the terminal handles the quoting correctly

## Key Insights

- `interactive_term()` is designed for simple commands without complex quoting
- For commands with quoted arguments, send directly via `chansend()`
- The pattern: `vim.fn.chansend(chan, cmd .. '\n')`
- No need for `bash -c` wrapper when sending to an already-running shell

## When to Use Each Approach

### Use `interactive_term(cmd)` when:
- Simple commands without quotes: `git status`, `make test`
- All arguments are space-separated without special characters

### Use direct `chansend()` when:
- Commands have quoted arguments: `copilot -p 'message'`
- Complex shell syntax: pipes, redirects, etc.
- You need exact control over what the shell receives

## Example Pattern for Direct Send

```lua
-- Open terminal
local show = require('show')
show.interactive_term_open()

-- Get channel
local chan = vim.bo[vim.t.interactive_term_buf].channel

-- Send command
if chan and chan > 0 then
  vim.fn.chansend(chan, "your-command 'with quotes' here\n")
end
```
