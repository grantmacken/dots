vim.api.nvim_create_user_command(
  'ScriptsToFile',
  function(opts)
    -- 'opts.fargs[1]' will be the filename argument passed to the command
    local filename = opts.fargs[1] or "default_scripts_output.txt"
    -- Call the utility function
    require("util").redirect_vim_command_output("scriptnames", filename, false)
  end,
  {
    nargs = 1,             -- Expects one argument (the filename)
    complete = "file",     -- Enable file path completion
    desc = "Capture :scriptnames output to a file"
  }
)

-- vim.api.nvim_create_user_command(
--     'GHeditIssue',
--     function(opts)
--         -- 'opts.fargs[1]' will be the filename argument passed to the command
--         local filename = opts.fargs[1] or "default_scripts_output.txt"
--         -- Call the utility function
--         require("util").redirect_vim_command_output("scriptnames", filename, false)
--     end,
--     {
--         nargs = 1, -- Expects one argument (the filename)
--         complete = "file", -- Enable file path completion
--         desc = "Capture :scriptnames output to a file"
--     }
-- )
