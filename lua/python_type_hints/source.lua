local cmp = require("cmp")
local ts_utils = require("nvim-treesitter.ts_utils")
local log = require("configs.cmp_sources.logger") -- optional for debugging
local patterns = require("python_type_hints.patterns")
local ctx = require("python_type_hints.context")

local M = {}

M.new = function()
	return {
		is_available = function()
			return vim.bo.filetype == "python"
		end,

		get_trigger_characters = function()
			return { ":", ">" }
		end,

		complete = function(self, params, callback)
			local is_valid, name, context_type = ctx.is_valid_type_context()
			if not is_valid then
				return callback({ items = {}, isIncomplete = false })
			end

			local suggestions = patterns.get_type_suggestions(name, context_type)
			local items = {}
			for i, typ in ipairs(suggestions) do
				local detail = context_type == "return" and ("Return type for: " .. (name or "function"))
					or ("Parameter type for: " .. (name or "parameter"))

				local doc_context = context_type == "return"
						and string.format("```python\ndef %s(...) -> %s:\n    ...\n```", name or "function", typ)
					or string.format("```python\n%s: %s\n```", name or "param", typ)

				table.insert(items, {
					label = typ,
					kind = cmp.lsp.CompletionItemKind.TypeParameter,
					detail = detail,
					documentation = { kind = cmp.lsp.MarkupKind.Markdown, value = doc_context },
					sortText = string.format("%02d_%s", i, typ),
					insertText = typ,
				})
			end

			callback({ items = items, isIncomplete = false })
		end,
	}
end

return M
