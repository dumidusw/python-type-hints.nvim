-- lua/python_type_hints/source.lua
-- nvim-cmp source for Python type hints

local ts_utils = vim.treesitter
local snippets = require("python_type_hints.snippets")

local source = {}

-- Called when cmp needs completion items
function source:complete(_, callback)
	local bufnr = vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype

	if ft ~= "python" then
		return callback()
	end

	-- Get node under cursor
	local parser = ts_utils.get_parser(bufnr, "python")
	if not parser then
		return callback()
	end

	local tree = parser:parse()[1]
	if not tree then
		return callback()
	end

	local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
	cursor_row = cursor_row - 1

	local root = tree:root()
	local node = root:named_descendant_for_range(cursor_row, cursor_col, cursor_row, cursor_col)
	if not node then
		return callback()
	end

	-- Only trigger inside function params or variable annotations
	local node_type = node:type()
	if node_type ~= "typed_parameter" and node_type ~= "function_definition" and node_type ~= "variable_annotation" then
		return callback()
	end

	-- Return snippets as completion items
	local items = {}
	for _, s in ipairs(snippets) do
		table.insert(items, {
			label = s,
			insertText = s,
			kind = vim.lsp.protocol.CompletionItemKind.Keyword,
		})
	end

	callback({ items = items, isIncomplete = false })
end

-- Required cmp metadata
function source:get_debug_name()
	return "python_type_hints"
end

return source
