
--@see https://github.com/nvim-mini/MiniMax/blob/main/configs/nvim-0.11/plugin/30_mini.lua
--[[ DIFF
-- Work with diff hunks that represent the difference between the buffer text and
some reference text set by a source. Default source uses text from Git index.
Also provides summary info used in developer section of 'mini.statusline'.
Example usage:
- `ghip` - apply hunks (`gh`) within *i*nside *p*aragraph
- `gHG` - reset hunks (`gH`) from cursor until end of buffer (`G`)
- `ghgh` - apply (`gh`) hunk at cursor (`gh`)
- `gHgh` - reset (`gH`) hunk at cursor (`gh`)
- `<Leader>go` - toggle overlay

See also:
- `:h MiniDiff-overview` - overview of how module works
- `:h MiniDiff-diff-summary` - available summary information
- `:h MiniDiff.gen_source` - available built-in sources
]]--

local ok_diff, diff = pcall(require, 'mini.diff')
if ok_diff then
  diff.setup()
end

--[[ Navigate and manipulate file system

Navigation is done using column view (Miller columns) to display nested
directories, they are displayed in floating windows in top left corner.

Manipulate files and directories by editing text as regular buffers.

Example usage:
- `<Leader>ed` - open current working directory
- `<Leader>ef` - open directory of current file (needs to be present on disk)

Basic navigation:
- `l` - go in entry at cursor: navigate into directory or open file
- `h` - go out of focused directory
- Navigate window as any regular buffer
- Press `g?` inside explorer to see more mappings

Basic manipulation:
- After any following action, press `=` in Normal mode to synchronize, read
  carefully about actions, press `y` or `<CR>` to confirm
- New entry: press `o` and type its name; end with `/` to create directory
- Rename: press `C` and type new name
- Delete: type `dd`
- Move/copy: type `dd`/`yy`, navigate to target directory, press `p`

See also:
- `:h MiniFiles-navigation` - more details about how to navigate
- `:h MiniFiles-manipulation` - more details about how to manipulate
- `:h MiniFiles-examples` - examples of common setups

]]--


--TODO: marks + autocmd
local ok_files, files = pcall(require, 'mini.files')
if ok_files then
  files.setup({ windows = { preview = true } })
end

-- TODO

-- Git integration for more straightforward Git actions based on Neovim's state.
-- It is not meant as a fully featured Git client, only to provide helpers that
-- integrate better with Neovim. Example usage:
-- - `<Leader>gs` - show information at cursor
-- - `<Leader>gd` - show unstaged changes as a patch in separate tabpage
-- - `<Leader>gL` - show Git log of current file
-- - `:Git help git` - show output of `git help git` inside Neovim
--
-- See also:
-- - `:h MiniGit-examples` - examples of common setups
-- - `:h :Git` - more details about `:Git` user command
-- - `:h MiniGit.show_at_cursor()` - what information at cursor is show

--[[
Track and reuse file system visits. Every file/directory visit is persistently
tracked on disk to later reuse: show in special frecency order, etc. It also
supports adding labels to visited paths to quickly navigate between them.
Example usage:
- `<Leader>fv` - find across all visits
- `<Leader>vv` / `<Leader>vV` - add/remove special "core" label to current file
- `<Leader>vc` / `<Leader>vC` - show files with "core" label; all or added within
  current working directory

See also:
- `:h MiniVisits-overview` - overview of how module works
- `:h MiniVisits-examples` - examples of common setups
]]--

require('mini.visits').setup()
