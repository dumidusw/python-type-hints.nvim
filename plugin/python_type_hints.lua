-- plugin/python_type_hints.lua
-- This file makes the plugin loadable via `package.loaded`

local function has(name)
	return vim.fn.has(name) == 1
end

local function exists(name)
	return vim.fn.isdirectory(vim.fn.stdpath("config") .. "/lua/" .. name) == 1
end

-- Only load plugin if nvim-cmp is available
if not exists("cmp") then
	return
end

-- Define plugin
vim.api.nvim_create_user_command("PythonTypeHintsEnable", function()
	require("python_type_hints").setup()
end, {})

-- Auto-setup on first use (Lazy-load)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		local ok, _ = pcall(require, "python_type_hints")
		if ok then
			require("python_type_hints").setup()
		end
	end,
	once = true,
})
