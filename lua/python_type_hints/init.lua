local M = {}

M.setup = function()
	-- Minimal log to confirm setup
	vim.notify("[python-type-hints.nvim] setup called")

	-- Register dummy cmp source
	local has_cmp, cmp = pcall(require, "cmp")
	if not has_cmp then
		vim.notify("[python-type-hints.nvim] nvim-cmp not found!", vim.log.levels.WARN)
		return
	end

	local source = {}
	source.new = function()
		return {
			is_available = function()
				return vim.bo.filetype == "python"
			end,
			get_trigger_characters = function()
				return { ":", ">" }
			end,
			complete = function(self, params, callback)
				callback({
					items = {
						{ label = "int", kind = cmp.lsp.CompletionItemKind.TypeParameter },
						{ label = "str", kind = cmp.lsp.CompletionItemKind.TypeParameter },
					},
					isIncomplete = false,
				})
			end,
		}
	end

	cmp.register_source("python_types", source.new())
end

return M
