M = {}
  -- diagnostic_show_sign = 1, default
  -- diagnostic_sign_priority = 20, default
  -- diagnostic_enable_underline = 1, default 1
  -- diagnostic_auto_popup_while_jump = 1, default 1

local init = function()
 vim.api.nvim_command('packadd! diagnostic-nvim')
 require('my.globals').set( {
    diagnostic_enable_virtual_text = 1; -- enable
    diagnostic_insert_delay = 1; -- don't show diag in insert mode
    diagnostic_virtual_text_prefix = ' ';
    -- diagnostic_trimmed_virtual_text = '20'; -- default v:null
    -- space_before_virtual_text = 3; --default 1
  })

  --"  Error",
  --"  Hint"
  --
  --  vim.fn.sign_define('LspDiagnosticsErrorSign', {text='', texthl='LspDiagnosticsError',linehl='', numhl=''})
 -- vim.fn.sign_define('LspDiagnosticsWarningSign', {text='', texthl='LspDiagnosticsWarning', linehl='', numhl=''})
 -- vim.fn.sign_define('LspDiagnosticsInformationSign', {text='', texthl='LspDiagnosticsInformation', linehl='', numhl=''})
--  vim.fn.sign_define('LspDiagnosticsHintSign', {text='', texthl='LspDiagnosticsHint', linehl='', numhl=''})
  --

  local sError = ' '
  local sWarn = ' '
  local sInfo = ' '
  local sHint = ' '
  require('my.signs').set({
    LspDiagnosticsErrorSign = { text = sError, texthl = 'LSPDiagnosticsError'};
    LspDiagnosticsWarningSign  = { text  = sWarn,  texthl  = 'LSPDiagnosticsWarning'};
    LspDiagnosticsInformationSign  = { text  = sInfo,  texthl  = 'LSPDiagnosticsInformation'};
    LspDiagnosticsHintSign  = { text  = sHint,  texthl  = 'LSPDiagnosticsHint'};
  })

  --[[
  --require('my.commands')({
   --DiagOpen = [[lua vim.cmd("OpenDiagnostic")']];
   --DiagPrev = [[lua vim.cmd("PrevDiagnostic")']];
  -- DiagNext = [[lua vim.cmd("NextDiagnostic")']];
  --})
  --]]
end

M.init = init

return M
