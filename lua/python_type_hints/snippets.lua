local ls = require("luasnip")
local s, t, i, c = ls.snippet, ls.text_node, ls.insert_node, ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

-- Context helpers
local ctx = require("python_type_hints.context")

-- Smart condition
local function smart_type_condition()
	return function()
		local ok, _ = ctx.in_type_annotation_context()
		return ok
	end
end

-- Type suggestions
local type_suggestions = require("python_type_hints.patterns").type_suggestions

-- Helper to create a snippet
local function create_contextual_snippet(name, types, context_type)
	local desc = context_type == "return_type" and ("Return type for " .. name) or ("Parameter type for " .. name)
	return s({
		trig = "type_" .. name,
		desc = desc,
		condition = smart_type_condition(),
		show_condition = smart_type_condition(),
	}, {
		c(
			1,
			vim.tbl_map(function(type_str)
				return t(type_str)
			end, types)
		),
		i(0),
	})
end

local snippets = {}

-- Generate parameter snippets
for pattern, types in pairs(type_suggestions.parameter) do
	table.insert(snippets, create_contextual_snippet(pattern, types, "parameter"))
end

-- Generate return type snippets
for pattern, types in pairs(type_suggestions.return_type) do
	table.insert(snippets, create_contextual_snippet(pattern, types, "return_type"))
end

-- Manual snippets
local manual_snippets = {
	s(
		{
			trig = "ldda",
			desc = "list[dict[str, Any]]",
			condition = smart_type_condition(),
			show_condition = smart_type_condition(),
		},
		{ t("list[dict[str, Any]]"), i(0) }
	),
	s(
		{ trig = "dsa", desc = "dict[str, Any]", condition = smart_type_condition(), show_condition = smart_type_condition() },
		{ t("dict[str, Any]"), i(0) }
	),
	s(
		{
			trig = "tldai",
			desc = "tuple[list[dict[str, Any]], int]",
			condition = smart_type_condition(),
			show_condition = smart_type_condition(),
		},
		{ t("tuple[list[dict[str, Any]], int]"), i(0) }
	),
	s(
		{ trig = "opt", desc = "Optional[T]", condition = smart_type_condition(), show_condition = smart_type_condition() },
		{ t("Optional["), i(1, "T"), t("]"), i(0) }
	),
	s(
		{ trig = "ls", desc = "list[str]", condition = smart_type_condition(), show_condition = smart_type_condition() },
		{ t("list[str]"), i(0) }
	),
	s(
		{ trig = "li", desc = "list[int]", condition = smart_type_condition(), show_condition = smart_type_condition() },
		{ t("list[int]"), i(0) }
	),
	s(
		{ trig = "any", desc = "Any", condition = smart_type_condition(), show_condition = smart_type_condition() },
		{ t("Any"), i(0) }
	),
}

vim.list_extend(snippets, manual_snippets)
return snippets
