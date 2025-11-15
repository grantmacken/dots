local keymap = require('util').keymap
local keymap_buf = require('util').keymap_buf
local keymap_dynamic = require('util').keymap_dynamic
local methods = vim.lsp.protocol.Methods

vim.api.nvim_set_hl(0, 'LspReferenceRead', { link = 'Search' })
vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Search' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { link = 'Search' })
vim.api.nvim_set_hl(0, 'LspReferenceTarget', { link = 'Search' })

vim.api.nvim_set_hl(0, 'ComplMatchIns', {})
vim.api.nvim_set_hl(0, 'PmenuMatch', { link = 'Pmenu' })
vim.api.nvim_set_hl(0, 'PmenuMatchSel', { link = 'PmenuSel' })

local ok_tca, tca = pcall(require, 'tiny-code-action')
if ok_tca then
  tca.setup({
    picker = {
      "buffer",
      opts = {
        hotkeys = true,                   -- Enable hotkeys for quick selection of actions
        hotkeys_mode = "text_diff_based", -- Modes for generating hotkeys
        auto_preview = false,             -- Enable or disable automatic preview
        auto_accept = false,              -- Automatically accept the selected action
        position = "cursor",              -- Position of the picker window
        winborder = "single",             -- Border style for picker and preview windows
        custom_keys = {
          { key = 'm', pattern = 'Fill match arms' },
          { key = 'r', pattern = 'Rename.*' }, -- Lua pattern matching
        },
      },
    },
  })
  vim.notify('tiny-code-action setup')
end

-- rachartier/tiny-code-action.nvim


-- LSP handlers wrapper to set default options"w
-- The vim.lsp.buf_… functions perform operations for LSP clients attached to the current buffer.
--
-- local function on_list(options)
--   vim.fn.setqflist({}, ' ', options)
--   vim.cmd.cfirst()
-- end
--
-- vim.lsp.buf.definition({ on_list = on_list })
-- vim.lsp.buf.references(nil, { on_list = on_list })

-- vim.lsp.buf.hover.Opts Extends: vim.lsp.util.open_floating_preview.Opts
-- https://neovim.io/doc/user/lsp.html#vim.lsp.util.open_floating_preview.Opts
-- Fields:{silent} (boolean)
-- K is mapped to vim.lsp.buf.hover()
-- KK to enter the hover window and use q to close it
-- Show hover information about the symbol under the cursor in a floating window.
-- vim.lsp.buf.hover({
--   border = 'rounded', -- 'none' | 'single' | 'double' | 'rounded' | 'solid' | 'shadow'
--   max_height = math.floor(vim.o.lines * 0.5),
--   max_width = math.floor(vim.o.columns * 0.4),
-- })

-- vim.lsp.buf.signature_help() - Show signature information about the symbol under the cursor in a floating window.'
-- CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()
-- The signature help will be shown when entering insert mode.
-- vim.lsp.buf.signature_help({
--   border = 'rounded', -- 'none' | 'single' | 'double' | 'rounded' | 'solid' | 'shadow'
--   max_height = math.floor(vim.o.lines * 0.5),
--   max_width = math.floor(vim.o.columns * 0.4),
-- })
--
-- "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()
--
-- vim.lsp.buf.code_action()


-- local function w(fn)
--   return function(...)
--     return fn({
--       ignore_current_line = true,
--       jump_to_single_result = true,
--       includeDeclaration = false,
--     }, ...)
--   end
-- end

-- LSP CODE ACTIONS

--
-- local ok_fzf, fzf = pcall(require, 'fzf-lua')
-- if ok_fzf then
--   vim.lsp.handlers['textDocument/codeAction'] = w(fzf.lsp_code_actions)
-- end

-- Suppress "Request was superseded by a new request" messages from LSP
-- vim.lsp.handlers['window/showMessage'] = function(err, method, params, client_id)
--   if params.message:find("Request was superseded by a new request") then
--     return
--   end
--   vim.lsp.handlers['window/showMessage'](err, method, params, client_id)
-- end

-- Enable inline completion if supported by the LSP server
local support_inline_completion = function(client, bufnr)
  if client:supports_method(methods.textDocument_inlinecompletion) then
    vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
    vim.lsp.inline_completion.enable(true)
    keymap_dynamic(
      '<Tab>',
      function()
        if not vim.lsp.inline_completion.get()
        then
          return "<Tab>"
        end
      end,
      "Apply suggestion",
      bufnr,
      'i')
    keymap(
      "<M-n>",
      function()
        vim.lsp.inline_completion.select({})
      end,
      "Show next inline completion suggestion",
      "i")
    keymap(
      "<M-p>",
      function()
        vim.lsp.inline_completion.select({ count = -1 })
      end,
      "Show previous inline completion suggestion",
      "i")
  end
end

-- Enable completion if supported by the LSP server
local support_completion = function(client, bufnr)
  if client:supports_method(methods.textDocument_completion) then
    vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    keymap_buf('<C-Space>', vim.lsp.completion.get, "Trigger lsp completion", bufnr)
  end
end

-- enable formatting on save if supported by the LSP server
local support_format_on_save = function(client, bufnr)
  if client:supports_method(methods.textDocument_formatting) then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
      desc = 'Format on save',
    })
  end
end


local support_document_color = function(client, bufnr)
  -- Don't check for the capability here to allow dynamic registration of the request.
  vim.lsp.document_color.enable(true, bufnr)
  if client:supports_method(methods.workspace_textDocumentContent_refresh) then
    keymap('grc', function()
      vim.lsp.document_color.color_presentation()
    end, 'vim.lsp.document_color.color_presentation()', { 'n', 'x' })
  end
end

local support_code_action = function(client, bufnr)
  if client:supports_method(methods.textDocument_codeAction) then
    require('lightbulb').attach_lightbulb(bufnr, client)
    keymap_buf('gra', function()
        require('tiny-code-action').code_action()
      end,
      'vim.lsp.buf.code_action()',
      bufnr,
      { 'n', 'x' })
  end
  --keymap('gra', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'vim.lsp.buf.code_action()', { 'n', 'x' })
end

local support_signature_help = function(client, bufnr)
  if client:supports_method(methods.textDocument_signatureHelp) then
    local signature_help = vim.lsp.buf.signature_help
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.buf.signature_help = function()
      return signature_help {
        border = 'rounded', -- 'none' | 'single' | 'double' | 'rounded' | 'solid' | 'shadow'
        title = 'Signature help',
        title_pos = 'center',
        max_height = math.floor(vim.o.lines * 0.5),
        max_width = math.floor(vim.o.columns * 0.4),
      }
    end
    keymap_buf('<C-k>',
      function() vim.lsp.buf.signature_help() end,
      'Signature help', bufnr, 'i')
  end
end

-- Override hover to set max height and width
-- vim.lsp.buf.hover() - Show hover information about the symbol under the cursor in a floating window.
-- 'K' is mapped to vim.lsp.buf.hover()
-- 'KK' to enter the hover window and use 'q' to close it
local support_hover = function(client, bufnr)
  if client:supports_method(methods.textDocument_hover) then
    local hover = vim.lsp.buf.hover
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.buf.hover = function()
      return hover {
        border = 'rounded', -- 'none' | 'single' | 'double' | 'rounded' | 'solid' | 'shadow'
        title = 'Info about the symbol under the cursor ',
        title_pos = 'center',
        max_height = math.floor(vim.o.lines * 0.5),
        max_width = math.floor(vim.o.columns * 0.4),
      }
    end
  end
end

-- TODO textDocument_inlayHint

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP Attach',
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufnr = event.buf
    support_completion(client, bufnr)
    support_inline_completion(client, bufnr)
    support_format_on_save(client, bufnr)
    -- support_document_color(client, bufnr)
    support_code_action(client, bufnr)
    support_signature_help(client, bufnr)
    support_hover(client, bufnr)
    -- keymap('grr', '<cmd>FzfLua lsp_references<cr>', 'vim.lsp.buf.references()')
    --keymap('gy', '<cmd>FzfLua lsp_typedefs<cr>', 'Go to type definition')
    -- keymap('<leader>ls', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document symbols')
  end
})

vim.api.nvim_create_autocmd('LspDetach', {
  desc = 'LSP Detaching',
  group = vim.api.nvim_create_augroup("UserLspDetach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client_id = event.data.client_id
    -- Get the attaching client
    local client = vim.lsp.get_client_by_id(client_id)
    -- Don't check for the capability here to allow dynamic registration of the request.

    -- Remove the autocommand to format the buffer on save, if it exists
    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_clear_autocmds({
        event = 'BufWritePre',
        buffer = bufnr,
      })
    end
  end,
})

vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd.edit(vim.lsp.log.get_filename())
end, {})

vim.api.nvim_create_user_command("LspHandlers", function()
  require('scratch').show(vim.tbl_keys(vim.lsp.handlers), 'LSP Handlers')
end, {})

vim.api.nvim_create_user_command("LspNames", function()
  local show = require('scratch').show
  local curBuf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = curBuf })
  local client_names = vim.tbl_map(function(client) return client.name end, clients)
  show(client_names, 'LSP Names')
end, {})

vim.api.nvim_create_user_command("LspServerCapabilities", function()
  local show = require('scratch').show
  local curBuf = vim.api.nvim_get_current_buf()
  local client = vim.lsp.get_clients({ bufnr = curBuf })[1]
  local capabilities = client.server_capabilities
  --vim.print(vim.tbl_keys(client))
  --vim.notify(client.name)
  show(vim.inspect(capabilities), 'LSP Server Capabilities')
end, {})

vim.api.nvim_create_user_command("LspCopilotServerCapabilities", function()
  local show = require('scratch').show
  local client = vim.lsp.get_clients({ name = 'copilot' })[1]
  --vim.print(vim.inspect(client))
  local capabilities = client.server_capabilities
  vim.print(vim.inspect(capabilities))

  --vim.print(vim.tbl_keys(client))
  --vim.notify(client.name)
  --show(vim.inspect(capabilities), 'LSP Server Capabilities')
end, {})
