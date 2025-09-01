-- lua/python_type_hints/init.lua
local M = {}

M.options = {
	enable_snippets = true,
	enable_logger = false,
}

function M.setup(opts)
	M.options = vim.tbl_extend("force", M.options, opts or {})

	-- 🔍 Debug: Print full opts
	-- print("🔧 python-type-hints.nvim opts:", vim.inspect(M.options))

	-- Enable logger if requested
	if M.options.enable_logger then
		-- print("🎯 Enabling logger...") -- Temporary debug
		require("python_type_hints.logger").enable()
		-- print("✅ Logger should now be enabled")
	end

	-- Register cmp source
	local source = require("python_type_hints.source")
	require("cmp").register_source("python_types", source.new())

	-- Load snippets if enabled
	if M.options.enable_snippets then
		local snippets = require("python_type_hints.snippets").snippets
		local ls = require("luasnip")
		ls.add_snippets("python", snippets)
		-- print("📎 Snippets loaded") -- Confirm snippets
	end
end

return M
