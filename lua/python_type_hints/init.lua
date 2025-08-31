local M = {}

M.setup = function()
	local ls = require("luasnip")

	-- Load snippets
	local snippets = require("python_type_hints.snippets")
	ls.add_snippets("python", snippets)

	-- Load and register CMP source
	local cmp = require("cmp")
	local python_type_source = require("python_type_hints.source")
	cmp.register_source("python_types", python_type_source.new())

	print("[python-type-hints.nvim] setup called")
end

return M
