M = {}

-- before plugin enabled
--local setup = function() end

-- after plugin enabled
local config = function()
  require("trouble").setup({
    height = 7, -- height of the trouble list
    icons = true, -- use devicons for filenames
    mode = "lsp_workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    action_keys = { -- key mappings for actions in the trouble list
      close = "q", -- close the list
      cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
      refresh = "r", -- manually refresh
      jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
      jump_close = {"o"}, -- jump to the diagnostic and close the list
      toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
      toggle_preview = "P", -- toggle auto_preview
      hover = "K", -- opens a small poup with the full multiline message
      preview = "p", -- preview the diagnostic location
      close_folds = {"zM", "zm"}, -- close all folds
      open_folds = {"zR", "zr"}, -- open all folds
      toggle_fold = {"zA", "za"}, -- toggle fold of current file
      previous = "k", -- preview item
      next = "j" -- next item
    },
 ident_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    signs = {
      -- icons / text used for a diagnostic
      error = "",
      warning = "",
      hint = "",
      information = "",
      other = "﫠"
    },
    use_lsp_diagnostic_signs = false
  })

  -- trouble bindings

 vim.api.nvim_set_keymap("n", "<leader>gx", "<cmd>TroubleToggle<cr>",  {silent = true, noremap = true})
 vim.api.nvim_set_keymap("n", "<leader>gw", "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", {silent = true, noremap = true})
 vim.api.nvim_set_keymap("n", "<leader>gd", "<cmd>TroubleToggle lsp_document_diagnostics<cr>", {silent = true, noremap = true})
 vim.api.nvim_set_keymap("n", "<leader>gl", "<cmd>TroubleToggle loclist<cr>", {silent = true, noremap = true})
 vim.api.nvim_set_keymap("n", "<leader>gq", "<cmd>TroubleToggle quickfix<cr>", {silent = true, noremap = true})
 vim.api.nvim_set_keymap("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", {silent = true, noremap = true})
end

M.config = config
-- M.setup = setup

return M



