local M = {}

function M.is_valid_type_context(line, col)
	-- Basic heuristic: look for ":" or "->" before cursor
	local before_cursor = line:sub(1, col - 1)
	if before_cursor:match(":$") or before_cursor:match("->$") then
		return true
	end
	return false
end

return M
