M = {}
  -- diagnostic_show_sign = 1, default
  -- diagnostic_sign_priority = 20, default
  -- diagnostic_enable_underline = 1, default 1
  -- diagnostic_auto_popup_while_jump = 1, default 1
  --

local setGlobals = function()
    require('my.globals').set( {
    diagnostic_enable_virtual_text = 1, -- enable
    diagnostic_insert_delay = 1, -- don't show diag in insert mode
    diagnostic_virtual_text_prefix = ' ',
    diagnostic_trimmed_virtual_text = '20', -- default v:null
    space_before_virtual_text = 3 --default 1
  })
end

local setSigns = function()
  local sError = ''
  local sWarn = ''
  local sInfo = ''
  local sHint = ''
  require('my.signs').set({
    LspDiagnosticsErrorSign = { text = sError, texthl = 'LSPDiagnosticsError'},
    LspDiagnosticsWarningSign  = { text  = sWarn,  texthl  = 'LSPDiagnosticsWarning'},
    LspDiagnosticsInformationSign  = { text  = sInfo,  texthl  = 'LSPDiagnosticsInformation'},
    LspDiagnosticsHintSign  = { text  = sHint,  texthl  = 'LSPDiagnosticsHint'}
  })
end

local setCommands = function()
  local cmd = vim.api.nvim_command
  cmd('packadd! diagnostic-nvim')
  cmd('command! DiagOpen lua vim.cmd("OpenDiagnostic")')
  cmd('command! DiagPrev lua vim.cmd("PrevDiagnostic")')
  cmd('command! DiagNext lua vim.cmd("NextDiagnostic")')
  -- cmd('command! LspBufClients lua print(vim.inspect(vim.lsp.buf_get_clients()))')
end

local init = function()
  -- print( 'set diagnostics' )
  setCommands()
  setGlobals()
  setSigns()
end

M.init = init

return M.init()
