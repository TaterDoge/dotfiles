package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"
-- Avoid recursively loading this config directory when requiring the C module.
local lua_path = package.path
package.path = ""
sbar = require("sketchybar")
package.path = lua_path

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("top_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
sbar.add("event", "apperace_change", "AppleInterfaceThemeChangedNotification")
require("bar")
require("default")
require("items")
sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()
