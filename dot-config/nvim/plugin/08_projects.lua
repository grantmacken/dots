vim.api.nvim_create_user_command(
  'ProjectSelect',
  function()
    vim.schedule(function()
      require('projects').select()
    end)
  end,
  { desc = 'select project' }
)
