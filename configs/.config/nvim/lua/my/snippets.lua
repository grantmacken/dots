local ls = require("luasnip")
--local k = require("astronauta.keymap")
--local inoremap = k.inoremap
--local snoremap = k.snoremap

ls.snippets = {
  all = {
    ls.parser.parse_snippet({ trig = "todo" }, "TODO(gmack: ${1:todo}"),
    ls.parser.parse_snippet({ trig = "fixme" }, "FIXME(gmack): ${1:fixme}"),
  }
}

