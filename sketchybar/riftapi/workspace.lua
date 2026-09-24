M.workspace = {}

---@param workspace_id integer 0-based
---@return boolean|nil
---@return string|nil
function M.workspace.switch(workspace_id)
	local cmd = string.format('{"Reactor":{"switch_to_workspace":%d}}', workspace_id)
	return M.execute(cmd)
end

---@param skip_empty? boolean
---@return boolean|nil
---@return string|nil
function M.workspace.next(skip_empty)
	local cmd = string.format('{"Reactor":{"next_workspace":%s}}', M._json_opt_bool(skip_empty))
	return M.execute(cmd)
end

---@param skip_empty? boolean
---@return boolean|nil
---@return string|nil
function M.workspace.prev(skip_empty)
	local cmd = string.format('{"Reactor":{"prev_workspace":%s}}', M._json_opt_bool(skip_empty))
	return M.execute(cmd)
end

---@return boolean|nil
---@return string|nil
function M.workspace.create()
	return M.execute('{"Reactor":"create_workspace"}')
end

---@return boolean|nil
---@return string|nil
function M.workspace.last()
	return M.execute('{"Reactor":"switch_to_last_workspace"}')
end

---@param workspace_id integer
---@param window_id? integer
---@return boolean|nil
---@return string|nil
function M.workspace.move_window(workspace_id, window_id)
	local wid = window_id ~= nil and tostring(window_id) or "null"
	local cmd =
		string.format('{"Reactor":{"move_window_to_workspace":{"workspace":%d,"window_id":%s}}}', workspace_id, wid)
	return M.execute(cmd)
end

---@param workspace_id? integer nil = active workspace
---@param mode "traditional"|"bsp"|"stack"|"master_stack"|"scrolling"
---@return boolean|nil
---@return string|nil
function M.workspace.set_layout(workspace_id, mode)
	local wid = workspace_id ~= nil and tostring(workspace_id) or "null"
	local cmd = string.format('{"Reactor":{"set_workspace_layout":{"workspace":%s,"mode":%s}}}', wid, M._json_str(mode))
	return M.execute(cmd)
end
