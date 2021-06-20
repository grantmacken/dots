M = {}
-- before plugin enabled
-- local setup = function() end
local generator = function()
  local el_segments = {}
  local subscribe = require "el.subscribe"
  local extensions = require('el.extensions')
  local helper = require("el.helper")

  local git_icon = subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, bufnr)
    local icon = extensions.file_icon(window, bufnr)
    if icon then
      return icon .. " "
    end

    return ""
  end)

  local git_branch = subscribe.buf_autocmd("el_git_branch", "BufEnter", function(window, buffer)
    local branch = extensions.git_branch(window, buffer)
    if branch then
      return " " .. extensions.git_icon() .. " " .. branch
    end
  end)

  local git_changes = subscribe.buf_autocmd("el_git_changes", "BufWritePost", function(window, buffer)
    return extensions.git_changes(window, buffer)
  end)

  -- Statusline options can be of several different types.
  -- Option 1, just a string.

  --table.insert(el_segments, '[literal_stdring]')

  -- Keep in mind, these can be the builtin strings,
  -- which are found in |:help statusline|
  -- table.insert(el_segments, '%f')

  -- expresss_line provides a helpful wrapper for these.
  -- You can check out el.builtin
  --local builtin = require('el.builtin')
  --table.insert(el_segments, builtin.file)

    -- Option 2, just a function that returns a string.
    table.insert(el_segments, extensions.mode) -- mode returns the current mode.

    -- Option 3, returns a function that takes in a Window and a Buffer. See |:help el.Window| and |:help el.Buffer|
    --
    -- With this option, you don't have to worry about escaping / calling the function in the correct way to get the current buffer and window.
    local file_namer = function(window, buffer)
      return buffer.name
    end

    table.insert(el_segments, file_namer)

    -- Option 4, you can return a coroutine.
    --  In lua, you can cooperatively multi-thread.
    --  You can use `coroutine.yield()` to yield execution to another coroutine.
    --
    -- For example, in luvjob.nvim, there is `co_wait` which is a coroutine version of waiting for a job to complete. So you can start multiple jobs at once and wait for them to all be done.
    table.insert(el_segments, extensions.git_changes)

    -- Option 5, there are several helper functions provided to asynchronously
    --  run timers which update buffer or window variables at a certain frequency.
    --
    --  These can be used to set infrequrently updated values without waiting.
    --[[ table.insert(el_segments, helper.async_buf_setter(
      win_id,
      'el_git_stat',
      extensions.git_changes,
      5000
    )) ]]

    return el_segments
end
-- after plugin enabled
local config = function()
  require('el').setup { generator = generator }
end

M.config = config
-- M.setup = setup

return M



