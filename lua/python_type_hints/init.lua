-- lua/python_type_hints/init.lua
-- Entry point for python-type-hints.nvim

local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
	vim.notify("[python-type-hints] nvim-cmp is not installed", vim.log.levels.WARN)
	return
end

local source = require("python_type_hints.source")

cmp.register_source("python_type_hints", source)
