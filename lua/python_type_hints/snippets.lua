local ls = require("luasnip")

ls.add_snippets("python", {
	ls.parser.parse_snippet("list", "list[$1]"),
	ls.parser.parse_snippet("dict", "dict[$1, $2]"),
	ls.parser.parse_snippet("tuple", "tuple[$1]"),
	ls.parser.parse_snippet("optional", "Optional[$1]"),
})
