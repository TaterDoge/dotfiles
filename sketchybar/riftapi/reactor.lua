---@return boolean|nil
---@return string|nil
function M.save_and_exit()
	return M.execute('{"Reactor":"save_and_exit"}')
end

---@return boolean|nil
---@return string|nil
function M.debug_layout_tree()
	return M.execute('{"Reactor":"debug"}')
end

---@return boolean|nil
---@return string|nil
function M.serialize_state()
	return M.execute('{"Reactor":"serialize"}')
end

---@return boolean|nil
---@return string|nil
function M.toggle_space_activated()
	return M.execute('{"Reactor":"toggle_space_activated"}')
end

---@return boolean|nil
---@return string|nil
function M.show_timing()
	return M.execute('{"Reactor":"show_timing"}')
end
