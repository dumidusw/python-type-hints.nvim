local M = {}

-- Parameter type suggestions
M.type_suggestions = {
	parameter = {
		str = { "str" },
		int = { "int" },
		float = { "float" },
		bool = { "bool" },
		list = { "list" },
		dict = { "dict" },
		any = { "Any" },
	},
	return_type = {
		str = { "str" },
		int = { "int" },
		float = { "float" },
		bool = { "bool" },
		list = { "list" },
		dict = { "dict" },
		any = { "Any" },
	},
}

-- Helper to get suggestions dynamically
function M.get_type_suggestions(name, context_type)
	if context_type == "return" then
		return M.type_suggestions.return_type[name] or { "Any" }
	else
		return M.type_suggestions.parameter[name] or { "Any" }
	end
end

return M
