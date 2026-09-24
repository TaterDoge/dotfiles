M.config = {}

---set arbitrary config key
---@param key string dot-separated path
---@param value_json string must be valid JSON; e.g. "true", "1.5", "\"str\""
---@return boolean|nil
---@return string|nil
function M.config.set(key, value_json)
	local cmd = string.format('{"set":{"key":%s,"value":%s}}', M._json_str(key), value_json)
	local config_cmd = string.format('{"Config":%s}', cmd)
	return M.execute(config_cmd, { "__apply_config__", cmd })
end

---@return boolean|nil
---@return string|nil
function M.config.save()
	return M.execute('{"Config":"save_config"}')
end

---@return boolean|nil
---@return string|nil
function M.config.reload()
	return M.execute('{"Config":"reload_config"}')
end
