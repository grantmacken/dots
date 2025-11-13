--- @see dot-config/nvim/plugin/09_actions.lua for commands that use the show module
--- @see dot-config/nvim/lua/show/init.lua     the show module implementation
--- @see dot-config/nvim/lua/term/init.lua     the term module implementation
---
--[[ markdown block

Commands for actions like opening terminal, running make, etc.
These commands are defined here to keep the configuration modular and organized.

Action defined here are to do with the `build |> test |> review` cycle of a project

The results of an actions can be these types:
 1. shell: display in terminal window with the shell running as a job with an channel open, ready to recieve shell commands.
 2. tasks: display in terminal window with a tasks channel open, ready to recieve data to display.

## Out of scope
 - LSP diagnostics - these are handled by the LSP client
    - currently open buffer diagnostics results are displayed in the location list window
    - workplace diagnostics results are displayed in the quickfix window TODO explain not implemented yet
 - fzf pickers - these are defined in the relevant modules

]] --

vim.api.nvim_create_user_command(
  'ActionSendCommandExample',
  function()
    require('term').send_cmd('echo "An example action that shows output in a Terminal"')
  end,
  { desc = 'An example action that shows output in a Terminal' }
)

vim.api.nvim_create_user_command(
  'ActionSendDataExample',
  function()
    local term  = require('term')
    local set   = term.tput_set
    -- ansi escape codes examples
    local style = {
      bold    = set('bold'),
      warn    = set('warn'),
      good    = set('good'),
      caution = set('caution'),
      reset   = set('reset'),
    }
    -- open the channel for tasks terminal
    term.send_data(
      'With the terminal provided by `nvim_open_term` the buffer can display ANSI escape codes for styling text.')
    term.send_data('Set ' .. style['warn'] .. 'Warn' .. style['reset'] .. ' style then a reset text to normal')
    term.send_data('Set ' .. style['bold'] .. 'Bold' .. style['reset'] .. ' style then a reset text to normal')
    term.send_data('ansync command with error output')
    vim.system({ 'ls', '/nonexistent' }, { text = true }, function(result)
      vim.schedule(function()
        if result.stderr then
          require('term').send_data('Error: ' .. result.stderr)
        elseif result.stdout then
          require('term').send_data('ls output: ' .. result.stdout)
        end
      end)
    end)
  end,
  { desc = 'An example action data output to terminal' }
)

vim.api.nvim_create_user_command(
  'ActionSendDataAsyncExample',
  function()
    local term  = require('term')
    local set   = term.tput_set
    -- ansi escape codes examples
    local style = {
      bold    = set('bold'),
      warn    = set('warn'),
      good    = set('good'),
      caution = set('caution'),
      reset   = set('reset'),
    }
    term.send_data('ansync command with error output')
    vim.system({ 'ls', '/nonexistent' }, { text = true }, function(result)
      vim.schedule(function()
        if result.stderr then
          require('term').send_data('Error: ' .. result.stderr)
        elseif result.stdout then
          require('term').send_data('ls output: ' .. result.stdout)
        end
      end)
    end)
  end,
  { desc = 'An example action data output to terminal' }
)


vim.api.nvim_create_user_command(
  'GhHelp',
  function()
    require('term').send_cmd('clear && gh help')
  end,
  { desc = 'clear terminal and gh help' }
)

vim.api.nvim_create_user_command(
  'GhRepoView',
  function()
    local data = vim.system({ 'gh', 'repo', 'view' }, { text = true }):wait().stdout
    require('term').send_data(data)
  end,
  { desc = 'github repo view' }
)

vim.api.nvim_create_user_command(
  'TermClear',
  function()
    require('term').send_cmd('clear')
  end,
  { desc = 'clear terminal' }
)


vim.api.nvim_create_user_command(
  'GitStatus',
  function()
    local data = vim.system({ 'git', 'status', '--short', 'branch' }, { text = true }):wait()
    require('term').send_data(data.stdout)
  end,
  { desc = 'git status ' }
)
-- Use Copilot to generate a git commit message
vim.api.nvim_create_user_command(
  'GitCommitMessage',
  function()
    require('term').send_cmd('copilot --allow-all-tools -p "conventional-commit"')
  end,
  { desc = 'git commit message' }
)



-- -- Use Copilot to generate a git commit message
-- vim.api.nvim_create_user_command(
--   'GitCommit',
--   function()
--     local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
--     if not git_root or git_root == '' then
--       vim.notify('Not in a git repository', vim.log.levels.ERROR)
--       return
--     end
--     local show = require('show')
--     show.window(show.buffer('buf_shell'))
--     local term = require('term')
--     local chan = term.chan_shell()
--     local cmd = string.format(
--       "copilot -p 'add commit message since last commit' --allow-all-tools --add-dir %s'", git_root)
--     term.send_shell_cmd(cmd)
--   end,
--   { desc = 'Use Copilot to generate a git commit message' }
-- )

--
-- vim.api.nvim_create_user_command('TermOpen', require('term').open, {
--   desc = 'open terminal window'
-- })
--
--
-- vim.api.nvim_create_user_command('TermClose', require('term').close, {
--   desc = 'close terminal window'
-- })

-- show results in a noninteractive terminal window
-- here we use vim.system() to run a shell command asynchronously
-- and show the output in a noninteractive terminal window
-- @see dot-config/nvim/lua/show/init.lua
--
--vim.api.nvim_create_user_command(
-- vim.api.nvim_create_user_command(
--   'ActionExampleJob',
--   function()
--     local show = require('show')
--     show.job_term('ls --color -al .')
--   end,
--   { desc = 'An example action that shows output in a noninteractive terminal' }
-- )
-- --
-- vim.api.nvim_create_user_command(
--   'ActionExampleNonInteractive',
--   function()
--     local show = require('show')
--     show.noninteractive_term('ls --color -al .')
--   end,
--   { desc = 'An example action that shows output in a noninteractive terminal' }
-- )
--
-- -- send bash commands to interactive terminal window
-- -- This action opens an interactive terminal window (if not already open)
-- -- and sends the bash commands to the terminal window
-- -- The terminal window remains open for further interaction
-- --- @see dot-config/nvim/lua/show/init.lua
-- vim.api.nvim_create_user_command(
--   'ActionExampleInteractiveTerminal',
--   function()
--     local show = require('show')
--     -- Use blur mode to keep focus on editor
--     show.interactive_term('echo "Hello from ActionExampleInteractiveTerminal"', { mode = 'blur' })
--   end,
--   { desc = 'Example: Run command without losing focus (blur mode)' }
-- )
-- -- send bash commands to scratch buffer
-- -- @see dot-config/nvim/lua/show/init.lua
-- -- This action opens a scratch buffer (if not already open)
-- -- and sends the bash commands to the scratch buffer
-- -- The scratch buffer remains open for further interaction
-- vim.api.nvim_create_user_command(
--   'ActionExampleScratch',
--   function()
--     local show = require('show')
--     show.scratch('ls --color=always -al .')
--   end,
--   { desc = 'An example action that shows output in a Interactive Terminal' }
-- )
--
-- vim.api.nvim_create_user_command(
--   'Make',
--   function()
--     local show = require('show')
--     show.scratch('make')
--   end
--   , {
--     desc = 'open terminal window and run make'
--   })
--
-- vim.api.nvim_create_user_command(
--   'MakeHelp',
--   function()
--     local show = require('show')
--     show.scratch('make help')
--   end
--   , {
--     desc = 'open terminal window and run make help target'
--   })
--
-- vim.api.nvim_create_user_command(
--   'GitStatus',
--   function()
--     local show = require('show')
--     show.scratch('git status --short --branch --porcelain')
--   end
--   , {
--     desc = 'show git status in scratch buffer'
--   })
--
-- vim.api.nvim_create_user_command(
--   'GitLog',
--   function()
--     local show = require('show')
--     show.noninteractive_term('git log --oneline --graph --decorate')
--   end
--   , {
--     desc = 'show git log in scratch buffer'
--   })
--
--
--
-- vim.api.nvim_create_user_command(
--   'GitPushCommit',
--   function()
--     local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
--     if not git_root or git_root == '' then
--       vim.notify('Not in a git repository', vim.log.levels.ERROR)
--       return
--     end
--     local show = require('show')
--     show.interactive_term_send_raw('git push', { mode = 'blur' })
--   end,
--   { desc = 'push git commit message then ' }
-- )
--
-- -- Open Copilot CLI in interactive terminal
-- vim.api.nvim_create_user_command(
--   'CopilotCLI',
--   function()
--     local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
--     if not git_root or git_root == '' then
--       vim.notify('Not in a git repository', vim.log.levels.ERROR)
--       return
--     end
--     -- Build the copilot command with --add-dir pointing to git root
--     -- Check if there's an existing session by checking for copilot process in terminal
--     local bufnr = vim.t.interactive_term_buf
--     local has_session = false
--
--     if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
--       local chan = vim.bo[bufnr].channel
--       if chan and chan > 0 then
--         -- Terminal is running, check if copilot is already running
--         -- We'll send the command which will either start copilot or continue the session
--         has_session = true
--       end
--     end
--
--     local show = require('show')
--     if has_session then
--       -- Just focus the terminal, copilot session should still be active
--       vim.notify('Opening existing Copilot session', vim.log.levels.INFO)
--       show.interactive_term_open()
--     else
--       -- Start new copilot session with git root
--       local cmd = string.format("copilot --add-dir '%s'", git_root)
--       vim.notify('Starting Copilot CLI: ' .. cmd, vim.log.levels.INFO)
--       show.interactive_term_send_raw(cmd, { mode = 'focus' })
--     end
--   end,
--   { desc = 'Open Copilot CLI in interactive terminal (continues session if exists)' }
-- )
--
--
--
-- --[[ Enhanced Interactive Terminal Commands
-- These commands demonstrate the new features of interactive_term():
-- - Multiple modes: focus, blur, back, insert
-- - Custom environment variables
-- - Custom shell support
-- - Terminal toggle and open functions
-- ]] --
--
-- -- Terminal Management
-- vim.api.nvim_create_user_command(
--   'TermToggle',
--   function()
--     require('show').interactive_term_toggle()
--   end,
--   { desc = 'Toggle interactive terminal window' }
-- )
--
-- vim.api.nvim_create_user_command(
--   'TermOpen',
--   function()
--     require('show').interactive_term_open()
--   end,
--   { desc = 'Open interactive terminal without command' }
-- )
--
-- -- General command runner with user input
-- vim.api.nvim_create_user_command(
--   'TermRunFocus',
--   function(opts)
--     require('show').interactive_term(opts.args, { mode = 'focus' })
--   end,
--   { desc = 'Run command in interactive terminal (focus mode)', nargs = 1 }
-- )
--
-- vim.api.nvim_create_user_command(
--   'TermRunBlur',
--   function(opts)
--     require('show').interactive_term(opts.args, { mode = 'blur' })
--   end,
--   { desc = 'Run command in interactive terminal (blur mode)', nargs = 1 }
-- )
--
-- -- Make commands using interactive terminal
-- vim.api.nvim_create_user_command(
--   'MakeInteractive',
--   function()
--     require('show').interactive_term('make', { mode = 'focus' })
--   end,
--   { desc = 'Run make in interactive terminal' }
-- )
--
-- vim.api.nvim_create_user_command(
--   'MakeTest',
--   function()
--     require('show').interactive_term('make test', { mode = 'focus' })
--   end,
--   { desc = 'Run make test in terminal' }
-- )
--
-- vim.api.nvim_create_user_command(
--   'MakeClean',
--   function()
--     require('show').interactive_term('make clean', { mode = 'blur' })
--   end,
--   { desc = 'Run make clean in background' }
-- )
--
-- -- Git commands with different modes
-- vim.api.nvim_create_user_command(
--   'GitStatusInteractive',
--   function()
--     require('show').interactive_term('git status', { mode = 'blur' })
--   end,
--   { desc = 'Show git status without losing focus' }
-- )
--
-- vim.api.nvim_create_user_command(
--   'GitFetch',
--   function()
--     require('show').interactive_term('git fetch --all --prune', { mode = 'blur' })
--   end,
--   { desc = 'Fetch git updates in background' }
-- )
--
-- vim.api.nvim_create_user_command(
--   'GitPull',
--   function()
--     require('show').interactive_term('git pull --rebase', { mode = 'back' })
--   end,
--   { desc = 'Pull git changes and return to editing' }
-- )
--
-- vim.api.nvim_create_user_command(
--   'GitLogInteractive',
--   function()
--     require('show').interactive_term('git log --oneline --graph --decorate', { mode = 'focus' })
--   end,
--   { desc = 'Show git log in terminal' }
-- )
--
-- -- Test runners with custom environment
-- vim.api.nvim_create_user_command(
--   'TestRun',
--   function()
--     require('show').interactive_term('npm test', {
--       mode = 'focus',
--       env = { NODE_ENV = 'test' }
--     })
--   end,
--   { desc = 'Run tests with test environment' }
-- )
--
-- -- File operations
-- vim.api.nvim_create_user_command(
--   'RunFile',
--   function()
--     local file = vim.fn.expand('%:p')
--     local ext = vim.fn.expand('%:e')
--
--     local cmd_map = {
--       py = 'python ' .. file,
--       js = 'node ' .. file,
--       lua = 'lua ' .. file,
--       sh = 'bash ' .. file,
--       rb = 'ruby ' .. file,
--       go = 'go run ' .. file,
--     }
--
--     local cmd = cmd_map[ext]
--     if cmd then
--       require('show').interactive_term(cmd, { mode = 'focus' })
--     else
--       vim.notify('No runner defined for .' .. ext .. ' files', vim.log.levels.WARN)
--     end
--   end,
--   { desc = 'Run current file in terminal' }
-- )
--
-- vim.api.nvim_create_user_command(
--   'LintFile',
--   function()
--     local file = vim.fn.expand('%')
--     require('show').interactive_term('eslint ' .. file, { mode = 'back' })
--   end,
--   { desc = 'Lint current file and return' }
-- )
--
-- vim.api.nvim_create_user_command(
--   'FormatFile',
--   function()
--     local file = vim.fn.expand('%')
--     require('show').interactive_term('prettier --write ' .. file, { mode = 'blur' })
--   end,
--   { desc = 'Format current file in background' }
-- )
--
-- -- Watch commands
-- vim.api.nvim_create_user_command(
--   'Watch',
--   function(opts)
--     require('show').interactive_term('watch -n 2 ' .. opts.args, { mode = 'focus' })
--   end,
--   { desc = 'Run watch command in terminal', nargs = 1 }
-- )
--
-- -- SSH commands
-- vim.api.nvim_create_user_command(
--   'SSH',
--   function(opts)
--     require('show').interactive_term('ssh ' .. opts.args, { mode = 'focus' })
--   end,
--   { desc = 'SSH to remote server', nargs = 1 }
-- )
--
-- -- Background processes
-- vim.api.nvim_create_user_command(
--   'BackgroundCommand',
--   function(opts)
--     require('show').interactive_term(opts.args, { mode = 'blur' })
--   end,
--   { desc = 'Run command in background without losing focus', nargs = 1 }
-- )
--
-- -- GitHub workflow watch command
-- vim.api.nvim_create_user_command(
--   'GitHubWatchWorkflow',
--   function()
--     local show = require('show')
--     -- Add sleep delay before gh command to allow workflow to be created after force push
--     -- The command uses bash -c to chain sleep and gh watch together
--     show.job_term('bash -c "sleep 5 && gh run watch"')
--   end,
--   { desc = 'Watch GitHub workflow action with 5 second delay (useful after force push)' }
-- )
--
-- -- local keymap = require('util').keymap
-- -- keymap('<leader>to', require('term').open, 'open [t]erminal window')
-- -- keymap('<leader>tc', require('term').close, 'close [t]erminal window')
-- -- keymap('<leader>tm', ':Make<CR>', '[t]erminal run [m]ake')
--
-- -- Example keybindings for enhanced terminal commands
-- -- Uncomment and customize as needed:
-- -- vim.keymap.set('n', '<leader>tt', ':TermToggle<CR>', { desc = '[T]oggle [T]erminal' })
-- -- vim.keymap.set('n', '<leader>to', ':TermOpen<CR>', { desc = '[T]erminal [O]pen' })
-- -- vim.keymap.set('n', '<leader>tr', ':TermRun ', { desc = '[T]erminal [R]un command' })
-- -- vim.keymap.set('n', '<leader>mt', ':MakeTest<CR>', { desc = '[M]ake [T]est' })
-- -- vim.keymap.set('n', '<leader>mc', ':MakeClean<CR>', { desc = '[M]ake [C]lean' })
-- -- vim.keymap.set('n', '<leader>gf', ':GitFetch<CR>', { desc = '[G]it [F]etch' })
-- -- vim.keymap.set('n', '<leader>gp', ':GitPull<CR>', { desc = '[G]it [P]ull' })
-- -- vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', { desc = '[R]un [F]ile' })
