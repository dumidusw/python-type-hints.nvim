-- lua/python_type_hints/snippets.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local context = require("python_type_hints.context")

local M = {}

-- Manual snippets
M.snippets = {
	s({
		trig = "ldda",
		desc = "list[dict[str, Any]]",
		condition = context.smart_condition(),
	}, { t("list[dict[str, Any]]"), i(0) }),

	s({
		trig = "dsa",
		desc = "dict[str, Any]",
		condition = context.smart_condition(),
	}, { t("dict[str, Any]"), i(0) }),

	s({
		trig = "tldai",
		desc = "tuple[list[dict[str, Any]], int]",
		condition = context.smart_condition(),
	}, { t("tuple[list[dict[str, Any]], int]"), i(0) }),

	s({
		trig = "opt",
		desc = "Optional[T]",
		condition = context.smart_condition(),
	}, { t("Optional["), i(1, "T"), t("]"), i(0) }),

	s({
		trig = "ls",
		desc = "list[str]",
		condition = context.smart_condition(),
	}, { t("list[str]"), i(0) }),

	s({
		trig = "li",
		desc = "list[int]",
		condition = context.smart_condition(),
	}, { t("list[int]"), i(0) }),

	s({
		trig = "any",
		desc = "Any",
		condition = context.smart_condition(),
	}, { t("Any"), i(0) }),

	s({
		trig = "none",
		desc = "None",
		condition = context.smart_condition(),
	}, { t("None"), i(0) }),

	s({
		trig = "union",
		desc = "Union[T, U]",
		condition = context.smart_condition(),
	}, { t("Union["), i(1, "T"), t(", "), i(2, "U"), t("]"), i(0) }),

	s({
		trig = "callable",
		desc = "Callable[[...], ...]",
		condition = context.smart_condition(),
	}, { t("Callable[["), i(1, "..."), t("], "), i(2, "..."), t("]"), i(0) }),
}

return M
