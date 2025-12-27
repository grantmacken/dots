--[[ LSP
## GLOBAL KEYMAPS
These GLOBAL keymaps are created **unconditionally** when Nvim starts:
 - "gra" (Normal and Visual mode) is mapped to vim.lsp.buf.code_action()
 - "gri" is mapped to vim.lsp.buf.implementation()
 - "grn" is mapped to vim.lsp.buf.rename()
 - "grr" is mapped to vim.lsp.buf.references()
 - "grt" is mapped to vim.lsp.buf.type_definition()
 - "gO" is mapped to vim.lsp.buf.document_symbol()
 - CTRL-S (Insert mode) is mapped to vim.lsp.buf.signature_help()
 - "an" and "in" (Visual and Operator-pending mode) are mapped to
outer and inner incremental selections, respectively,
using vim.lsp.buf.selection_range()

BUFFER-LOCAL DEFAULTS

 - 'omnifunc' is set to vim.lsp.omnifunc(), use i_CTRL-X_CTRL-O to trigger completion.
 - 'tagfunc' is set to vim.lsp.tagfunc(). This enables features like go-to-definition, :tjump, and keymaps like CTRL-], CTRL-W_], CTRL-W_} to utilize the language server.
 - 'formatexpr' is set to vim.lsp.formatexpr(), so you can format lines via gq if the language server supports it.
    - To opt out of this use gw instead of gq, or clear 'formatexpr' on LspAttach.
 - K is mapped to vim.lsp.buf.hover() unless 'keywordprg' is customized or a custom keymap for K exists.
 - Document colors are enabled for highlighting color references in a document.
   - To opt out call vim.lsp.document_color.enable(false, args.buf) on LspAttach.

https://neovim.io/doc/user/lsp.html#_lua-module:-vim.lsp.buf
Enable LSP features based on server capabilities
' Features supported:

 - defintions:  keymap: gd:
                display: quickfix list
 - references:  keymap: gr
                display: quickfix list
 - code actions: keymap: gra (Normal and Visual mode)
 - hover:       keymap K, KK to enter the hover window and use q to close it
                         Show hover information about the symbol under the cursor in a floating window.
 - completions:          keymap: <C-Space>
 - inline completions:   keymaps: <Tab>, <M-n>, <M-p>
 - formatting on save:   BufWritePre
 - folding ranges:       keymap: za, zc, zo, zm, zr, zR`
 - signatures help:      keymap:  CTRL-S (Insert mode)
                         Show signature information about the symbol under the cursor in a floating window.'
   Fields:{silent} (boolean)

]] --
-- KEYMAPS and METHODS
local keymap = require('keymap')
--local methods = vim.lsp.protocol.Methods

-- HIGHLIGHTS
vim.api.nvim_set_hl(0, 'LspReferenceRead', { link = 'Search' })
vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Search' })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { link = 'Search' })
vim.api.nvim_set_hl(0, 'LspReferenceTarget', { link = 'Search' })

vim.api.nvim_set_hl(0, 'ComplMatchIns', {})
vim.api.nvim_set_hl(0, 'PmenuMatch', { link = 'Pmenu' })
vim.api.nvim_set_hl(0, 'PmenuMatchSel', { link = 'PmenuSel' })


-- Enable all LSP servers in the 'lsp' config directory
local uv = vim.uv or vim.loop
local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
local fd = uv.fs_scandir(lsp_dir)
if fd then
  while true do
    local server_name, _ = uv.fs_scandir_next(fd)
    if not server_name then break end
    local name = server_name:match("(.+)%..+$")
    -- vim.notify( 'enabled LSP server:'  .. name)
    vim.lsp.enable(name)
  end
end




--[[ HANDLERS
buf.hover:
Show hover information about the symbol under the cursor in a floating window.
vim.lsp.buf.hover.Opts Extends: vim.lsp.util.open_floating_preview.Opts
https://neovim.io/doc/user/lsp.html#vim.lsp.util.open_floating_preview.Opts
Fields:{silent} (boolean)

hover mappings
 - K is mapped to vim.lsp.buf.hover()
 - KK to enter the hover window and use q to close it

--]]


-- HACK: Override buf_request to ignore notifications from LSP servers that don't implement a method.
local buf_request = vim.lsp.buf_request
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf_request = function(bufnr, method, params, handler)
  return buf_request(bufnr, method, params, handler, function() end)
end


-- FEATURES SUPPORT FUNCTION
--
local on_list = function(options)
  vim.fn.setqflist({}, ' ', options)
  vim.cmd.cfirst()
end

--[[ defintions
 - keymap "gd" is mapped to vim.lsp.buf.definition()
 - display: quickfix list
]] --

--- Enable definitions if supported by the LSP server
--- @param client vim.lsp.Client LSP client instance
---@return nil
local support_definition = function(client, bufnr)
  if client:supports_method('textDocument/definition') then
    keymap.buf('gd', function()
      vim.lsp.buf.definition({
        on_list = on_list
      })
    end, 'vim.lsp.buf.definition()', bufnr)
  end
end

--[[ references
 - keymap "grr" is mapped to vim.lsp.buf.references()
 - display: quickfix list
]] --

--- Enable references if supported by the LSP server
--- @param client vim.lsp.Client LSP client instance
---@return nil
local support_references = function(client, bufnr)
  if not client:supports_method('textDocument/references') then
    return
  end
  keymap.buf('grr', function()
    vim.lsp.buf.references(nil, { on_list = on_list })
  end, 'vim.lsp.buf.references()', bufnr)
end

--[[ buffer implementation
 - keymap: "gri" is mapped to vim.lsp.buf.implementation()
 - display: quickfix list
]] --

--- Enable implementation if supported by the LSP server
---@param client vim.lsp.Client LSP client instance
---@return nil
local support_implementation = function(client, bufnr)
  if client:supports_method('textDocument/implementation') then
    keymap.buf('gri', function()
      vim.lsp.buf.implementation({
        on_list = on_list
      })
    end, 'vim.lsp.buf.implementation()', bufnr)
  end
end
--
--[[ buffer document symbols
  in current buffer
 - keymap: "gO" is mapped to vim.lsp.buf.document_symbol()
 - display: location list
 - note: uses default on_list handler
]] --
--- Enable document symbols if supported by the LSP server
--- @param client vim.lsp.Client LSP client instance
--- @return nil
local support_document_symbol = function(client, bufnr)
  if not client:supports_method('textDocument/documentSymbol') then return end
  keymap.buf('gO', function()
    vim.lsp.buf.document_symbol()
  end, 'vim.lsp.buf.document_symbol()', bufnr)
end

--
-- Enable completion if supported by the LSP server
local support_completion = function(client, bufnr)
  if client:supports_method('textDocument/completion') then
    vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    keymap.buf('<C-Space>', vim.lsp.completion.get, "Trigger lsp completion", bufnr, 'i')
  end
end

-- inlineCompletion
local support_inlineCompletion = function(client, bufnr)
  if client:supports_method('textDocument/inlineCompletion') then
    vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
    vim.lsp.inline_completion.enable(true)
    keymap.buf_dynamic(
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
    keymap.buf(
      "<M-n>",
      function()
        vim.lsp.inline_completion.select({})
      end,
      "Show next inline completion suggestion",
      bufnr,
      "i")
    keymap.buf(
      "<M-p>",
      function()
        vim.lsp.inline_completion.select({ count = -1 })
      end,
      "Show previous inline completion suggestion",
      bufnr,
      "i")
  end
end

--- enable formatting on save if supported by the LSP server

local support_format_on_save = function(client, bufnr)
  if client:supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
      desc = 'Format on save',
    })
  end
end

local support_foldingRange = function(client, bufnr)
  if client:supports_method('textDocument/foldingRange') then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][bufnr].foldexpr = 'v:lua.vim.lsp.foldexpr()'
  end
end

--[[ Show signature information about the symbol under the cursor
 - when: cursor position on symbol
 - keymap:  CTRL-S (Insert mode)
 - trigger:  - display: floating window.'
--]]
--- Enable signature help if supported by the LSP server
--- @param client vim.lsp.Client LSP client instance
--- @param bufnr number Buffer number
--- @return nil
local support_signature_help = function(client, bufnr)
  if client:supports_method('textDocument/signatureHelp') then
    keymap.buf('<C-k>', function()
      vim.lsp.buf.signature_help({
        border = 'rounded', -- 'none' | 'single' | 'double' | 'rounded' | 'solid' | 'shadow'
        title = 'Signature help',
        title_pos = 'center',
        max_height = math.floor(vim.o.lines * 0.5),
        max_width = math.floor(vim.o.columns * 0.4),
      }
      )
    end, 'vim.lsp.buf.signature_help()', bufnr, 'i')
  end
end

--- Enable hover if supported by the LSP server

local support_hover = function(client, bufnr)
  if not client:supports_method('textDocument/hover') then return end
  -- Map K to show hover information
  keymap.buf('K', function()
    vim.lsp.buf.hover({
      border = 'rounded', -- 'none' | 'single' | 'double' | 'rounded' | 'solid' | 'shadow'
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    })
  end, 'vim.lsp.buf.hover()', bufnr)
end



-- code actions
--[[
A simplified check for code actions at the current cursor position.
 - If code actions are available, a notification is shown.
 - You could extend this to update a sign, statusline, or lightbulb indicator.
 - use vim.lsp.buf_request to send a 'textDocument/codeAction' request.
   with the context of current diagnostics.

]] --
--- Check and notify if code actions are available at cursor position
---@param client vim.lsp.Client LSP client instance
---@param bufnr integer Buffer number
---@return nil
local support_code_action = function(client, bufnr)
  if client:supports_method('textDocument/codeAction') then
    local ok_tca, tiny_code_action = pcall(require, 'tiny-code-action')
    if not ok_tca then
      vim.notify('tiny-code-action not found', vim.log.levels.WARN)
      return
    end
    local ok_lb, lightbulb = pcall(require, 'lightbulb')
    if ok_lb then
      lightbulb.attach_lightbulb(bufnr, client)
    end
    -- require('lightbulb').attach_lightbulb(bufnr, client)
    keymap.buf_leader('ca', function()
        tiny_code_action.code_action()
      end,
      'vim.lsp.buf.code_action()',
      bufnr,
      { 'n', 'x' })
  end
end

--[[ FEATURES SUPPORT FUNCTIONS
  -- GLOBAL DEFAULTS
These GLOBAL keymaps are created unconditionally when Nvim starts:
 - "gra" (Normal and Visual mode) is mapped to vim.lsp.buf.code_action()
 - "gri" is mapped to vim.lsp.buf.implementation()
 - "grn" is mapped to vim.lsp.buf.rename()
 - "grr" is mapped to vim.lsp.buf.references()
 - "grt" is mapped to vim.lsp.buf.type_definition()
 - "gO" is mapped to vim.lsp.buf.document_symbol()
 - CTRL-S (Insert mode) is mapped to vim.lsp.buf.signature_help()
 - "an" and "in" (Visual and Operator-pending mode) are mapped to
outer and inner incremental selections, respectively,
using vim.lsp.buf.selection_range()

BUFFER-LOCAL DEFAULTS

 - 'omnifunc' is set to vim.lsp.omnifunc(), use i_CTRL-X_CTRL-O to trigger completion.
 - 'tagfunc' is set to vim.lsp.tagfunc(). This enables features like go-to-definition, :tjump, and keymaps like CTRL-], CTRL-W_], CTRL-W_} to utilize the language server.
 - 'formatexpr' is set to vim.lsp.formatexpr(), so you can format lines via gq if the language server supports it.
    - To opt out of this use gw instead of gq, or clear 'formatexpr' on LspAttach.
 - K is mapped to vim.lsp.buf.hover() unless 'keywordprg' is customized or a custom keymap for K exists.
 - Document colors are enabled for highlighting color references in a document.
   - To opt out call vim.lsp.document_color.enable(false, args.buf) on LspAttach.

https://neovim.io/doc/user/lsp.html#_lua-module:-vim.lsp.buf
Enable LSP features based on server capabilities
' Features supported:

 - defintions:  buf.definition()
                trigger: on cursor position
                keymap: gd:
                display: quickfix list
 - references:  keymap: grr
                display: quickfix list
- implementation: buf.implementation()
                  trigger: on cursor position
                  keymap: gri
                  display: quickfix list
 - code actions: buf.code_action()
                 trigger: on cursor position
                 keymap: gra (Normal and Visual mode)
                 display: tiny-code-actions buffer

 - hover:       keymap K, KK to enter the hover window and use q to close it
                         Show hover information about the symbol under the cursor in a floating window.
 - completions:          keymap: <C-Space>
 - inline completions:   keymaps: <Tab>, <M-n>, <M-p>
 - formatting on save:   BufWritePre
 - folding ranges:       keymap: za, zc, zo, zm, zr, zR`
 - signatures help:      keymap:  CTRL-S (Insert mode)
                         Show signature information about the symbol under the cursor in a floating window.'
   Fields:{silent} (boolean)

 -  ]] --
-- AUTOCOMANDS

--[[ LspAttach
After an LSP client performs "initialize" and attaches to a buffer. The
|autocmd-pattern| is the buffer name. The client ID is passed in the
Lua handler |event-data| argumen
--
--]]

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    -- quickfix and location lists: definitions, references, implementations
    support_definition(client, bufnr)
    support_implementation(client, bufnr)
    support_references(client, bufnr)
    support_document_symbol(client, bufnr)
    -- list in tiny-code-action buffer if supported
    support_code_action(client, bufnr)
    support_completion(client, bufnr)
    support_inlineCompletion(client, bufnr)
    -- info in floating windows
    support_signature_help(client, bufnr)
    support_hover(client, bufnr)
    -- support_foldingRange(client, bufnr)
    -- autocmd to format on save if supported
    support_format_on_save(client, bufnr)
  end
}
)


-- Update mappings when registering dynamic capabilities.
-- local register_capability = vim.lsp.handlers['client/registerCapability']
-- vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
--     local client = vim.lsp.get_client_by_id(ctx.client_id)
--     if not client then
--         return
--     end
--     on_attach(client, vim.api.nvim_get_current_buf())
--     return register_capability(err, res, ctx)
-- end

-- Trigger code action check when diagnostics change
-- vim.api.nvim_create_autocmd('DiagnosticChanged', {
--   callback = function(args)
--     local bufnr = args.buf
--     local clients = vim.lsp.get_clients({ bufnr = bufnr })
--     for _, client in ipairs(clients) do
--       support_code_action(client, bufnr)
--     end
--   end
-- }
-- )
--[[
 Note: If the LSP server performs dynamic registration, capabilities may be
    registered any time _after_ LspAttach. In that case you may want to handle
    the "registerCapability" event.
--]]

--[[ LspDetach                                                          *LspDetach*
  Just before an LSP client detaches from a buffer. The |autocmd-pattern| is
  the buffer name. The client ID is passed in the Lua handler |event-data|
  argument.
--]]

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
  end
}
)

--[[ LspNotify                                                          *LspNotify*
    This event is triggered after each successful notification sent to an
    LSP server.

    The client_id, LSP method, and parameters are sent in the Lua handler
    |event-data| table argument.
--]]
--[[
  vim.api.nvim_create_autocmd('LspNotify', {
    callback = function(args)
      local bufnr = args.buf
      local client_id = args.data.client_id
      local method = args.data.method
      local params = args.data.params

      -- do something with the notification
      if method == 'textDocument/...' then
        update_buffer(bufnr)
      end
    end,
  })
--]]
--
-- TODO
-- LspProgress                                                       *LspProgress*
-- LspRequest
--LspTokenUpdate                                                *LspTokenUpdate*




--[[




-- local ok_tca, tca = pcall(require, 'tiny-code-action')
-- if ok_tca then
--   tca.setup({
--     picker = {
--       "buffer",
--       opts = {
--         hotkeys = true,                   -- Enable hotkeys for quick selection of actions
--         hotkeys_mode = "text_diff_based", -- Modes for generating hotkeys
--         auto_preview = false,             -- Enable or disable automatic preview
--         auto_accept = false,              -- Automatically accept the selected action
--         position = "cursor",              -- Position of the picker window
--         winborder = "single",             -- Border style for picker and preview windows
--         custom_keys = {
--           { key = 'm', pattern = 'Fill match arms' },
--           { key = 'r', pattern = 'Rename.*' }, -- Lua pattern matching
--         },
--       },
--     },
--   })
--   vim.notify('tiny-code-action setup')
-- end

-- rachartier/tiny-code-action.nvim


-- LSP handlers wrapper to set default options"w
-- The vim.lsp.buf_… functions perform operations for LSP clients attached to the current buffer.



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


-- enable formatting on save if supported by the LSP server


local support_document_color = function(client, bufnr)
  -- Don't check for the capability here to allow dynamic registration of the request.
  vim.lsp.document_color.enable(true, bufnr)
  if client:supports_method(methods.workspace_textDocumentContent_refresh) then
    keymap('grc', function()
      vim.lsp.document_color.color_presentation()
    end, 'vim.lsp.document_color.color_presentation()', { 'n', 'x' })
  end
end

-- local support_code_action = function(client, bufnr)
--   if client:supports_method(methods.textDocument_codeAction) then
--     require('lightbulb').attach_lightbulb(bufnr, client)
--     keymap_buf('gra', function()
--         require('tiny-code-action').code_action()
--       end,
--       'vim.lsp.buf.code_action()',
--       bufnr,
--       { 'n', 'x' })
--   end
--   --keymap('gra', '<cmd>lua vim.lsp.buf.code_action()<cr>', 'vim.lsp.buf.code_action()', { 'n', 'x' })
-- end



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
]] --
