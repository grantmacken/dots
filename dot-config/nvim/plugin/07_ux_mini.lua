--- @see URL https://github.com/nvim-mini/MiniMax/blob/main/configs/nvim-0.11/plugin/30_mini.lua
--[[ MINI.PLUGINS
--
To minimize the time until first screen draw, modules are enabled in two steps:
- Step one enables everything that is needed for first draw with `now()`.
  Sometimes is needed only if Neovim is started as `nvim -- path/to/file`.
- Everything else is delayed until the first draw with `later()`.
--]]
--
--- @see URL https://github.com/nvim-mini/MiniMax/blob/main/configs/nvim-0.11/plugin/30_mini.lua
-- RE: 'cursorword'  Word boundaries are defined based on `:h 'iskeyword'` option

local ui = {
  'cursorword',
  'bufremove',
  'trailspace',
  'hipatterns',
}

for _, plugin in ipairs(ui) do
  vim.pack.add({ 'gh:nvim-mini/mini.' .. plugin }, { confirm = false })
  require('mini.' .. plugin).setup()
end
--
-- local actions = {
--   'align',
--   'bufremove',
--   'splitjoin',
--   'surround',
-- }
--
-- for _, plugin in ipairs(actions) do
--   vim.pack.add({ src = 'https://github.com/nvim-mini/mini.' .. plugin, prompt = false })
--   require('mini.' .. plugin).setup()
-- end
--
-- vim.pack.add({ 'https://github.com/nvim-mini/mini.extra', prompt = false })
-- local extra = require('mini.extra')
--
-- vim.pack.add({ 'https://github.com/nvim-mini/mini.ai', prompt = false })
-- local ai = require('mini.ai')
-- ai.setup({
--   -- 'mini.ai' can be extended with custom textobjects
--   custom_textobjects = {
--     -- Make `aB` / `iB` act on around/inside whole *b*uffer
--     B = extra.gen_ai_spec.buffer(),
--     -- For more complicated textobjects that require structural awareness,
--     -- use tree-sitter. This example makes `aF`/`iF` mean around/inside function
--     -- definition (not call). See `:h MiniAi.gen_spec.treesitter()` for details.
--     F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
--   },
--
--   -- 'mini.ai' by default mostly mimics built-in search behavior: first try
--   -- to find textobject covering cursor, then try to find to the right.
--   -- Although this works in most cases, some are confusing. It is more robust to
--   -- always try to search only covering textobject and explicitly ask to search
--   -- for next (`an`/`in`) or last (`al`/`il`).
--   -- Try this. If you don't like it - delete next line and this comment.
--   search_method = 'cover',
-- })
--
--
-- -- INDENTSCOPE
-- vim.pack.add({ 'https://github.com/nvim-mini/mini.indentscope', prompt = false })
-- local indentscope = require('mini.indentscope')
-- indentscope.setup({
--   symbol = '│', -- Character to use for indentation lines
--   options = {
--     try_as_border = true, -- Try to use the symbol as a border
--   },
-- })
--
--
--
-- --[[ Highlight patterns in text. Like `TODO`/`NOTE` or color hex codes.
-- Example usage:
-- - `:Pick hipatterns` - pick among all highlighted patterns
--
-- See also:
-- - `:h MiniHipatterns-examples` - examples of common setups
-- ]] --
--
--
-- vim.pack.add({ 'https://github.com/nvim-mini/mini.hipatterns', prompt = false })
-- local hipatterns = require('mini.hipatterns')
-- local hi_words = extra.gen_highlighter.words
-- hipatterns.setup({
--   highlighters = {
--     -- Highlight a fixed set of common words. Will be highlighted in any place,
--     -- not like "only in comments".
--     fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
--     hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
--     todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
--     note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
--
--     -- Highlight hex color string (#aabbcc) with that color as a background
--     hex_color = hipatterns.gen_highlighter.hex_color(),
--   },
-- })
