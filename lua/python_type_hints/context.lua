-- ~/.config/nvim/lua/python_type_hints/context.lua
local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

-- Safely get current line and cursor info
local function get_cursor_line()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local lines = vim.api.nvim_buf_get_lines(0, row, row + 1, false)
	local line = (lines and lines[1]) or ""
	col = math.min(col, #line)
	return line, col
end

-- Detect unwanted contexts (functions, classes, loops, etc.)
local function is_unwanted_context()
	local line, col = get_cursor_line()
	local before_cursor = line:sub(1, col)

	local patterns = {
		"^%s*def%s+%w+%(%)%s*:%s*", -- empty function
		"^%s*class%s+%w+%s*:%s*", -- class
		"^%s*class%s+%w+%(.*%)%s*:%s*", -- class with inheritance
		"^%s*if%s+.*:%s*",
		"^%s*elif%s+.*:%s*",
		"^%s*else%s*:%s*",
		"^%s*for%s+.*:%s*",
		"^%s*while%s+.*:%s*",
		"^%s*with%s+.*:%s*",
		"^%s*try%s*:%s*",
		"^%s*except%s+.*:%s*",
		"^%s*finally%s*:%s*",
	}

	for _, pattern in ipairs(patterns) do
		if before_cursor:match(pattern) then
			return true
		end
	end

	return false
end

-- Determine if we are in a valid type annotation context
function M.is_valid_type_context()
	local line, col = get_cursor_line()
	local before_cursor = line:sub(1, col)
	local node = ts_utils.get_node_at_cursor()

	-- First, reject unwanted contexts
	if is_unwanted_context() then
		return false, nil, nil
	end

	-- Parameter type annotation (colon context)
	local param_match = before_cursor:match("([%w_]+)%s*:%s*$")
	if param_match then
		return true, param_match, "parameter"
	end

	-- Return type annotation (arrow context)
	local return_match = before_cursor:match("%-%>%s*$")
	if return_match then
		-- Try to get function name from TreeSitter
		local func_name
		if node then
			local parent = node
			local depth = 0
			while parent and depth < 5 do
				if parent:type() == "function_definition" then
					local name_node = parent:child(1)
					if name_node and name_node:type() == "identifier" then
						func_name = vim.treesitter.get_node_text(name_node, 0)
					end
					break
				end
				parent = parent:parent()
				depth = depth + 1
			end
		end
		return true, func_name, "return"
	end

	-- No valid type context found
	return false, nil, nil
end

return M
