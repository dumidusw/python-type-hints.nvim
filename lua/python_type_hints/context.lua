-- lua/python_type_hints/context.lua
local ts_utils = require("nvim-treesitter.ts_utils")
local logger = require("python_type_hints.logger")

local M = {}

-- Check if in unwanted context (e.g., class, if, for, etc.)
function M.is_unwanted_context()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local before_cursor = line:sub(1, col)

	logger.log("🔍 Checking unwanted contexts")
	logger.log("🔍 Before cursor: '" .. before_cursor .. "'")

	local unwanted_patterns = {
		"^%s*def%s+%w+%(%)%s*:%s*", -- def func():
		"^%s*class%s+%w+%s*:%s*", -- class Foo:
		"^%s*class%s+%w+%(.*%)%s*:%s*", -- class Foo(Bar):
		"^%s*if%s+.*:%s*", -- if condition:
		"^%s*elif%s+.*:%s*", -- elif condition:
		"^%s*else%s*:%s*", -- else:
		"^%s*for%s+.*:%s*", -- for item in items:
		"^%s*while%s+.*:%s*", -- while condition:
		"^%s*with%s+.*:%s*", -- with context:
		"^%s*try%s*:%s*", -- try:
		"^%s*except%s*.*:%s*", -- except Exception:
		"^%s*finally%s*:%s*", -- finally:
		"%w+%[.*%]%s*:%s*", -- dict[key]: type
	}

	for _, pattern in ipairs(unwanted_patterns) do
		if before_cursor:match(pattern) then
			logger.log("❌ UNWANTED CONTEXT DETECTED")
			return true
		end
	end

	return false
end

-- Get context: parameter name or function name for return type
function M.get_context()
	if M.is_unwanted_context() then
		return nil, nil
	end

	local node = ts_utils.get_node_at_cursor()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local before_cursor = line:sub(1, col)

	-- Parameter: var_name: |
	local param_match = before_cursor:match("([%w_]+)%s*:%s*$")
	if param_match and not before_cursor:match("%)%s*%-%>") then
		return param_match, "parameter"
	end

	-- Return type: def func() -> |
	if before_cursor:match("%-%>%s*$") then
		-- local func_name = before_cursor:match("def%s+([%w_]+)%(.*%)%s*%-%>%s*$")
		local func_name = before_cursor:match("def%s+([%w_]+)%b()%s*%-%>%s*$")
		return func_name or "unnamed", "return"
	end

	-- TreeSitter fallback for parameter
	if node and node:type() == "type" then
		local parent = node:parent()
		if parent and parent:type() == "parameters" then
			local prev = node:prev_sibling()
			while prev and prev:type() ~= "identifier" do
				prev = prev:prev_sibling()
			end
			if prev then
				local name = vim.treesitter.get_node_text(prev, 0)
				return name, "parameter"
			end
		end
	end

	-- TreeSitter return type
	if before_cursor:match("%-%>%s*$") then
		local parent = node
		while parent do
			if parent:type() == "function_definition" then
				local func_name_node = parent:child(1)
				if func_name_node and func_name_node:type() == "identifier" then
					local func_name = vim.treesitter.get_node_text(func_name_node, 0)
					return func_name, "return"
				end
				return "unnamed", "return"
			end
			parent = parent:parent()
		end
	end

	return nil, nil
end

-- Smart condition for LuaSnip
function M.smart_condition()
	return function()
		local _, context_type = M.get_context()
		return context_type ~= nil
	end
end

return M
