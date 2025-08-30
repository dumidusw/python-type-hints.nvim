local M = {}

function M.setup(opts)
	opts = opts or {}
	local cmp_ok, cmp = pcall(require, "cmp")
	if not cmp_ok then
		vim.notify("[python-type-hints] nvim-cmp not found", vim.log.levels.ERROR)
		return
	end

	-- Register cmp source
	cmp.register_source("python_type_hints", require("python_type_hints.source").new())

	vim.notify("[python-type-hints] loaded successfully")
end

return M
