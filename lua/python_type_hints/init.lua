-- lua/python_type_hints/init.lua
local M = {}

M.options = {
	enable_snippets = true,
	enable_logger = false,
}

function M.setup(opts)
	M.options = vim.tbl_extend("force", M.options, opts or {})

	-- Enable logger if requested
	if M.options.enable_logger then
		require("python_type_hints.logger").enable()
	end

	-- Register cmp source
	local source = require("python_type_hints.source")
	require("cmp").register_source("python_types", source.new())

	-- Load snippets if enabled
	if M.options.enable_snippets then
		local snippets = require("python_type_hints.snippets").snippets
		local ls = require("luasnip")
		ls.add_snippets("python", snippets)
	end
end

return M
