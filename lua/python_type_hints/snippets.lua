-- ~/.config/nvim/lua/python_type_hints/snippets.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local context = require("python_type_hints.context") -- use the new context.lua
local fmt = require("luasnip.extras.fmt").fmt

-- Smart condition function for snippet visibility
local function smart_type_condition()
	return function()
		local valid, _, _ = context.is_valid_type_context()
		return valid
	end
end

-- Type suggestions
local type_suggestions = {
	parameter = {
		users = { "list[dict[str, Any]]", "list[User]", "pd.DataFrame", "Optional[list[User]]" },
		user = { "dict[str, Any]", "User", "Optional[User]" },
		data = { "dict[str, Any]", "list[dict[str, Any]]", "pd.DataFrame", "Any" },
		payload = { "dict[str, Any]", "list[dict[str, Any]]", "Payload" },
		response = { "dict[str, Any]", "Response", "requests.Response", "httpx.Response" },
		request = { "dict[str, Any]", "Request", "httpx.Request" },
		id = { "int", "str", "Optional[int]", "Optional[str]" },
		user_id = { "int", "str", "Optional[int]" },
		items = { "list[dict[str, Any]]", "list[T]", "Sequence[T]" },
		results = { "list[dict[str, Any]]", "list[T]", "pd.DataFrame" },
		name = { "str", "Optional[str]" },
		email = { "str", "Optional[str]" },
		message = { "str", "Optional[str]" },
		df = { "pd.DataFrame", "Optional[pd.DataFrame]" },
		dataframe = { "pd.DataFrame", "Optional[pd.DataFrame]" },
		file = { "str", "Path", "TextIO", "BinaryIO" },
		path = { "str", "Path", "Optional[Path]" },
		filename = { "str", "Path", "Optional[str]" },
		config = { "dict[str, Any]", "Config", "Settings" },
		settings = { "dict[str, Any]", "Settings", "Config" },
		options = { "dict[str, Any]", "Options", "Optional[dict[str, Any]]" },
	},

	return_type = {
		get_user = { "Optional[User]", "dict[str, Any]", "User" },
		get_users = { "list[User]", "list[dict[str, Any]]", "pd.DataFrame" },
		process_data = { "dict[str, Any]", "list[dict[str, Any]]", "pd.DataFrame" },
		fetch_data = { "dict[str, Any]", "list[dict[str, Any]]", "requests.Response" },
		validate_data = { "bool", "tuple[bool, str]", "ValidationResult" },
		parse_config = { "dict[str, Any]", "Config", "Settings" },
		load_config = { "dict[str, Any]", "Config", "Settings" },
		save_data = { "bool", "None", "int" },
		create_user = { "User", "dict[str, Any]", "int" },
		update_user = { "bool", "User", "dict[str, Any]" },
		delete_user = { "bool", "None" },
	},
}

-- Function to create contextual snippets
local function create_contextual_snippet(name, types, context_type)
	local description = context_type == "return_type" and ("Return type for " .. name)
		or ("Parameter type for " .. name)

	return s({
		trig = "type_" .. name,
		desc = description,
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

-- Generate contextual snippets
local contextual_snippets = {}

for name, types in pairs(type_suggestions.parameter) do
	table.insert(contextual_snippets, create_contextual_snippet(name, types, "parameter"))
end

for name, types in pairs(type_suggestions.return_type) do
	table.insert(contextual_snippets, create_contextual_snippet(name, types, "return_type"))
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
		{
			trig = "dsa",
			desc = "dict[str, Any]",
			condition = smart_type_condition(),
			show_condition = smart_type_condition(),
		},
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
		{
			trig = "opt",
			desc = "Optional[T]",
			condition = smart_type_condition(),
			show_condition = smart_type_condition(),
		},
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
	s(
		{ trig = "none", desc = "None", condition = smart_type_condition(), show_condition = smart_type_condition() },
		{ t("None"), i(0) }
	),
	s(
		{
			trig = "union",
			desc = "Union[T, U]",
			condition = smart_type_condition(),
			show_condition = smart_type_condition(),
		},
		{ t("Union["), i(1, "T"), t(", "), i(2, "U"), t("]"), i(0) }
	),
	s(
		{
			trig = "callable",
			desc = "Callable[[...], ...]",
			condition = smart_type_condition(),
			show_condition = smart_type_condition(),
		},
		{ t("Callable[["), i(1, "..."), t("], "), i(2, "..."), t("]"), i(0) }
	),
}

-- Combine all snippets
local all_snippets = {}
vim.list_extend(all_snippets, manual_snippets)
vim.list_extend(all_snippets, contextual_snippets)

return all_snippets
