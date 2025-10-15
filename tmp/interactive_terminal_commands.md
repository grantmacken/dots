# Enhanced Interactive Terminal Commands

## Summary of Changes

### File: dot-config/nvim/plugin/09_actions.lua
- **Before**: 169 lines with basic commands
- **After**: 422 lines with 34 total commands
- **New commands added**: 22 enhanced interactive terminal commands

## Available Commands

### Terminal Management (3)
- `:TermToggle` - Toggle interactive terminal window
- `:TermOpen` - Open interactive terminal without command
- `:TermRun <command>` - Run command in interactive terminal (focus mode)

### Make Commands (5)
- `:Make` - Run make in scratch buffer (original)
- `:MakeHelp` - Run make help target (original)
- `:MakeInteractive` - Run make in interactive terminal (focus)
- `:MakeTest` - Run make test in terminal (focus)
- `:MakeClean` - Run make clean in background (blur)

### Git Commands (8)
- `:GitStatus` - Show git status in scratch buffer (original)
- `:GitLog` - Show git log in noninteractive terminal (original)
- `:GitCommit` - Use Copilot for commit message (original)
- `:GitPush` - Push changes (original)
- `:GitStatusInteractive` - Show git status without losing focus (blur)
- `:GitFetch` - Fetch git updates in background (blur)
- `:GitPull` - Pull with rebase and return to editing (back)
- `:GitLogInteractive` - Show git log in terminal (focus)

### Test & Build Commands (4)
- `:TestRun` - Run tests with test environment (focus + env)
- `:TestWatch` - Run tests in watch mode (focus)
- `:DevServer` - Start dev server with debug enabled (focus + env)
- `:BuildWatch` - Start continuous build process (focus)

### Docker/Podman Commands (3)
- `:DockerUp` - Start docker containers (focus)
- `:DockerDown` - Stop docker containers in background (blur)
- `:DockerLogs [container]` - Follow docker container logs (focus)

### File Operations (3)
- `:RunFile` - Run current file in terminal (auto-detects language)
- `:LintFile` - Lint current file and return (back)
- `:FormatFile` - Format current file in background (blur)

### Utility Commands (5)
- `:Watch <command>` - Run watch command in terminal
- `:SSH <host>` - SSH to remote server
- `:FishCommand <command>` - Run command in fish shell
- `:BackgroundCommand <command>` - Run command in background (blur)

### Example Commands (4)
- `:ActionExampleJob` - Example using job_term
- `:ActionExampleNonInteractive` - Example noninteractive terminal
- `:ActionExampleInteractiveTerminal` - Example interactive (blur mode)
- `:ActionExampleScratch` - Example scratch buffer

## Mode Reference

All enhanced commands support the following modes:

- **focus** (default) - Open terminal and enter insert mode
- **blur** - Run command but keep focus on current window
- **back** - Run command then return to previous window
- **insert** - Open terminal and enter insert mode (same as focus)

## Example Usage

```vim
" Toggle terminal
:TermToggle

" Run make test in terminal (stays in terminal)
:MakeTest

" Run make clean in background (stays in editor)
:MakeClean

" Fetch git updates without interrupting work
:GitFetch

" Run current Python/JS/etc file
:RunFile

" Start dev server with debug enabled
:DevServer

" Run arbitrary command in terminal
:TermRun npm install

" Run command in background
:BackgroundCommand npm run build
```

## Suggested Keybindings (commented in file)

```lua
vim.keymap.set('n', '<leader>tt', ':TermToggle<CR>', { desc = '[T]oggle [T]erminal' })
vim.keymap.set('n', '<leader>to', ':TermOpen<CR>', { desc = '[T]erminal [O]pen' })
vim.keymap.set('n', '<leader>tr', ':TermRun ', { desc = '[T]erminal [R]un command' })
vim.keymap.set('n', '<leader>mt', ':MakeTest<CR>', { desc = '[M]ake [T]est' })
vim.keymap.set('n', '<leader>mc', ':MakeClean<CR>', { desc = '[M]ake [C]lean' })
vim.keymap.set('n', '<leader>gf', ':GitFetch<CR>', { desc = '[G]it [F]etch' })
vim.keymap.set('n', '<leader>gp', ':GitPull<CR>', { desc = '[G]it [P]ull' })
vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', { desc = '[R]un [F]ile' })
```

## Advanced Features

### Custom Environment Variables
```lua
require('show').interactive_term('npm test', {
  mode = 'focus',
  env = { NODE_ENV = 'test', DEBUG = '*' }
})
```

### Custom Shell
```lua
require('show').interactive_term('echo $SHELL', {
  mode = 'focus',
  shell = 'fish'
})
```

### Programmatic Access
```lua
local show = require('show')

-- Toggle terminal
show.interactive_term_toggle()

-- Open terminal
show.interactive_term_open()

-- Run command with options
show.interactive_term('make test', { mode = 'blur' })
```

## Implementation Details

### Files Modified
1. **dot-config/nvim/lua/show/init.lua**
   - Enhanced `interactive_term_buffer()` with modified flag handling and TermClose autocmd
   - Enhanced `interactive_term()` with mode support, custom env, and custom shell
   - Added `interactive_term_open()` function
   - Added `interactive_term_toggle()` function

2. **dot-config/nvim/plugin/09_actions.lua**
   - Updated `ActionExampleInteractiveTerminal` to use blur mode
   - Added 22 new user commands demonstrating various use cases
   - Added commented keybinding examples

### Key Improvements
- **Mode support**: focus, blur, back, insert modes for different workflows
- **Buffer cleanup**: Clears stale content when restarting terminal
- **Error handling**: pcall wrapper with retry logic
- **Autocmd cleanup**: Automatic cleanup on TermClose event
- **Custom environment**: Support for environment variables
- **Custom shell**: Support for different shells (bash, fish, etc.)
- **Modified flag handling**: Prevents unwanted save prompts
