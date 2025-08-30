local patterns = require("python_type_hints.patterns")
local context = require("python_type_hints.context")

local Source = {}
Source.__index = Source

function Source.new()
	return setmetatable({}, Source)
end

function Source:is_available()
	return vim.bo.filetype == "python"
end

function Source:get_debug_name()
	return "python_type_hints"
end

function Source:complete(request, callback)
	local line = request.context.cursor_line
	local col = request.context.cursor.col

	-- Detect context via Treesitter
	if not context.is_valid_type_context(line, col) then
		return callback({})
	end

	local items = {}

	-- Exact matches
	for word, type_hint in pairs(patterns.exact) do
		if line:match(word .. "%s*$") then
			table.insert(items, { label = type_hint, insertText = type_hint })
		end
	end

	-- Regex matches
	for pat, type_hint in pairs(patterns.regex) do
		if line:match(pat) then
			table.insert(items, { label = type_hint, insertText = type_hint })
		end
	end

	-- Fallbacks
	for _, type_hint in ipairs(patterns.fallbacks) do
		table.insert(items, { label = type_hint, insertText = type_hint })
	end

	callback(items)
end

return Source
