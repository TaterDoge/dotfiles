M.layout = {}

---@return boolean|nil
---@return string|nil
function M.layout.ascend()
	return M.execute('{"Reactor":"ascend"}')
end

---@return boolean|nil
---@return string|nil
function M.layout.descend()
	return M.execute('{"Reactor":"descend"}')
end

---@param direction "left"|"right"|"up"|"down"
---@return boolean|nil
---@return string|nil
function M.layout.move_node(direction)
	local cmd = string.format('{"Reactor":{"move_node":%s}}', M._json_str(direction))
	return M.execute(cmd)
end

---@param direction "left"|"right"|"up"|"down"
---@return boolean|nil
---@return string|nil
function M.layout.join_window(direction)
	local cmd = string.format('{"Reactor":{"join_window":%s}}', M._json_str(direction))
	return M.execute(cmd)
end

---@return boolean|nil
---@return string|nil
function M.layout.toggle_stack()
	return M.execute('{"Reactor":"toggle_stack"}')
end

---@return boolean|nil
---@return string|nil
function M.layout.toggle_orientation()
	return M.execute('{"Reactor":"toggle_orientation"}')
end

---@return boolean|nil
---@return string|nil
function M.layout.unjoin()
	return M.execute('{"Reactor":"unjoin_windows"}')
end

---@return boolean|nil
---@return string|nil
function M.layout.toggle_focus_float()
	return M.execute('{"Reactor":"toggle_focus_floating"}')
end

---@param delta number
---@return boolean|nil
---@return string|nil
function M.layout.adjust_master_ratio(delta)
	local cmd = string.format('{"Reactor":{"adjust_master_ratio":{"delta":%.6f}}}', delta)
	return M.execute(cmd)
end

---@param delta integer
---@return boolean|nil
---@return string|nil
function M.layout.adjust_master_count(delta)
	local cmd = string.format('{"Reactor":{"adjust_master_count":{"delta":%d}}}', delta)
	return M.execute(cmd)
end

---@return boolean|nil
---@return string|nil
function M.layout.promote_to_master()
	return M.execute('{"Reactor":"promote_to_master"}')
end

---@return boolean|nil
---@return string|nil
function M.layout.swap_master_stack()
	return M.execute('{"Reactor":"swap_master_stack"}')
end

---@param a string WindowId debug string
---@param b string WindowId debug string
---@return boolean|nil
---@return string|nil
function M.layout.swap_windows(a, b)
	local cmd = string.format('{"Reactor":{"swap_windows":[%s,%s]}}', M._json_str(a), M._json_str(b))
	return M.execute(cmd)
end

---@param delta number
---@return boolean|nil
---@return string|nil
function M.layout.scroll_strip(delta)
	local cmd = string.format('{"Reactor":{"scroll_strip":{"delta":%.6f}}}', delta)
	return M.execute(cmd)
end

---@return boolean|nil
---@return string|nil
function M.layout.snap_strip()
	return M.execute('{"Reactor":"snap_strip"}')
end

---@return boolean|nil
---@return string|nil
function M.layout.center_selection()
	return M.execute('{"Reactor":"center_selection"}')
end
