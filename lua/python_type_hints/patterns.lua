local M = {}

M.exact = {
	["int"] = "int",
	["str"] = "str",
	["float"] = "float",
	["bool"] = "bool",
	["list"] = "list",
	["dict"] = "dict",
	["set"] = "set",
}

M.regex = {
	["%[%]$"] = "List[]",
	["{}$"] = "Dict[]",
}

M.fallbacks = {
	"Any",
	"Optional[]",
	"Union[]",
}

return M
