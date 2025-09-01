-- lua/python_type_hints/logger.lua
local M = {}

M.enabled = false

function M.log(msg)
	if M.enabled then
		local time = os.date("%H:%M:%S")
		local line = string.format("[py-hints] %s %s", time, msg)
		-- print(line)
	end
end

function M.enable()
	M.enabled = true
	print("[py-hints] 🟢 Logger ENABLED")
end

function M.disable()
	M.enabled = false
	-- print("[py-hints] 🔴 Logger DISABLED")
end

return M
