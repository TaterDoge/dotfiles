-- Load only the window manager that is actually running.
-- Both aerospace.lua and rift.lua create the same item names
-- (front_app, spaces, left panel), so loading both breaks
-- subscriptions after every sketchybar reload.
local function is_running(pattern)
	local handle = io.popen("pgrep -x " .. pattern .. " >/dev/null 2>&1 && echo yes || echo no")
	local out = handle and handle:read("*l") or "no"
	if handle then
		handle:close()
	end
	return out == "yes"
end

if is_running("rift") then
	require("items.rift")
elseif is_running("AeroSpace") then
	require("items.aerospace")
else
	-- fallback: rift is the primary WM on this machine
	require("items.rift")
end
require("items.widgets")
