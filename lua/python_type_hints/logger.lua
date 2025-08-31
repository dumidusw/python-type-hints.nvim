-- lua/python_type_hints/logger.lua
local M = {}

M.enabled = false

function M.log(msg)
	if M.enabled then
		local time = os.date("%H:%M:%S")
		local line = string.format("[%s] %s", time, msg)
		vim.schedule(function()
			vim.api.nvim_echo({ { line, "Comment" } }, false, {})
		end)
	end
end

function M.enable()
	M.enabled = true
end

function M.disable()
	M.enabled = false
end

return M
