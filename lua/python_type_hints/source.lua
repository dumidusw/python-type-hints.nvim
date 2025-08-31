-- lua/python_type_hints/source.lua
local cmp = require("cmp")
local patterns = require("python_type_hints.patterns")
local context = require("python_type_hints.context")
local logger = require("python_type_hints.logger")

local M = {}

-- Get suggestions based on name and context
local function get_suggestions(name, context_type)
	logger.log("=== GETTING SUGGESTIONS ===")
	logger.log("🔍 Name: " .. (name or "nil"))
	logger.log("🔍 Context type: " .. (context_type or "nil"))

	local mappings = context_type == "return" and patterns.return_type_mappings or patterns.type_mappings
	local suggestions = {}

	-- Exact match
	if name and mappings.exact[name] then
		logger.log("✅ Exact match for '" .. name .. "'")
		vim.list_extend(suggestions, mappings.exact[name])
	else
		-- Pattern match
		local matched = false
		for pattern, types in pairs(mappings.patterns) do
			if name and name:match(pattern) then
				logger.log("✅ Pattern match: " .. pattern)
				vim.list_extend(suggestions, types)
				matched = true
				break
			end
		end
		if not matched then
			logger.log("❌ No match, using fallbacks")
			suggestions = vim.deepcopy(mappings.fallbacks)
		else
			-- Add some fallbacks
			local added = {}
			for _, fb in ipairs(mappings.fallbacks) do
				if not vim.tbl_contains(suggestions, fb) and not added[fb] then
					table.insert(suggestions, fb)
					added[fb] = true
				end
				if #suggestions >= 6 then
					break
				end
			end
		end
	end

	return suggestions
end

-- Create cmp source
function M.new()
	return {
		is_available = function()
			return vim.bo.filetype == "python"
		end,

		get_trigger_characters = function()
			return { ":", ">" }
		end,

		complete = function(self, params, callback)
			logger.log("=== PYTHON TYPE COMPLETION TRIGGERED ===")

			local name, context_type = context.get_context()
			if not context_type then
				logger.log("❌ No valid context → abort")
				return callback({ items = {}, isIncomplete = false })
			end

			logger.log("✅ Context: " .. context_type .. " | Name: " .. (name or "unnamed"))

			local suggestions = get_suggestions(name, context_type)
			if #suggestions == 0 then
				return callback({ items = {}, isIncomplete = false })
			end

			local items = {}
			for i, typ in ipairs(suggestions) do
				-- ✅ Build detail (label shown in menu)
				local detail = context_type == "return" and ("Return type for: " .. (name or "function"))
					or ("Parameter type for: " .. (name or "parameter"))

				-- ✅ Build documentation (shown in preview)
				local doc_context
				if context_type == "return" then
					doc_context = string.format([[```python def %s(...) -> %s: ...```]], name or "function", typ)
				else
					doc_context = string.format([[```python %s: %s ```]], name or "param", typ)
				end
				table.insert(items, {
					label = typ,
					kind = cmp.lsp.CompletionItemKind.TypeParameter,
					detail = detail,
					documentation = {
						kind = cmp.lsp.MarkupKind.Markdown,
						value = doc_context,
					},
					sortText = string.format("%02d_%s", i, typ),
					insertText = typ,
				})
			end

			callback({
				items = items,
				isIncomplete = false,
			})
		end,
	}
end

return M
