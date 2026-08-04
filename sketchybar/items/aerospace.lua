local colors = require("colors")
local settings = require("settings")

local workspace_names = { "1", "2", "3", "4", "5", "6" }
local workspace_colors = {
	light = {
		colors.light.yellow,
		colors.light.red,
		colors.light.green,
		colors.light.blue,
		colors.light.magenta,
		colors.light.orange,
	},
	dark = {
		colors.dark.yellow,
		colors.dark.red,
		colors.dark.green,
		colors.dark.blue,
		colors.dark.magenta,
		colors.dark.orange,
	},
}
local max_spaces = #workspace_names
local spaces = {}
local workspace_spacers = {}
local workspace_gap = 6

local function trim(value)
	return tostring(value or ""):match("^%s*(.-)%s*$") or ""
end

local function shellQuote(value)
	return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function commandPath(command, fallback)
	local handle = io.popen("command -v " .. command .. " 2>/dev/null")
	local path = handle and trim(handle:read("*a")) or ""
	if handle then
		handle:close()
	end
	return path ~= "" and path or fallback
end

local aerospace_path = commandPath("aerospace", "/opt/homebrew/bin/aerospace")

local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'")
local output = handle and trim(handle:read("*a")):lower() or "light"
if handle then
	handle:close()
end
local appearance = output

sbar.add("event", "aerospace_workspace_change")

local function workspaceColor(index)
	local palette = workspace_colors[appearance] or workspace_colors.light
	return palette[((index - 1) % #palette) + 1]
end

local function workspaceTextColor()
	local theme = colors[appearance] or colors.light
	return theme.white
end

local function setWorkspaceStyle(index, is_active)
	local space = spaces[index]
	if not space then
		return
	end

	local color = workspaceColor(index)
	local text_color = workspaceTextColor()

	space:set({
		icon = {
			color = is_active and text_color or color,
		},
		background = {
			color = is_active and color or colors.with_alpha(color, 0.25),
			border_color = colors.transparent,
			border_width = 0,
		},
	})
end

local function workspaceIndex(workspace_name)
	for index, name in ipairs(workspace_names) do
		if tostring(name) == tostring(workspace_name) then
			return index
		end
	end
	return nil
end

local function updateActiveWorkspaceByName(workspace_name)
	local active_index = workspaceIndex(trim(workspace_name))

	sbar.animate("tanh", 10, function()
		for i = 1, max_spaces do
			setWorkspaceStyle(i, i == active_index)
		end
	end)
end

local function updateActiveWorkspace()
	sbar.exec(aerospace_path .. " list-workspaces --focused", function(focused_workspace)
		updateActiveWorkspaceByName(focused_workspace)
	end)
end

-- Create workspace items. AeroSpace workspace names are user-defined strings;
-- this config keeps the same 1-6 layout that the rift adapter used.
for i = 1, max_spaces do
	local color = workspaceColor(i)
	local workspace_name = workspace_names[i]
	local space = sbar.add("item", "aerospace_space." .. workspace_name, {
		position = "left",
		label = {
			drawing = false,
		},
		icon = {
			string = workspace_name,
			color = color,
			font = {
				family = settings.font.numbers,
				style = settings.font.style_map["Regular"],
				size = 13.0,
			},
			align = "center",
			width = 26,
			padding_left = 0,
			padding_right = 0,
		},
		background = {
			color = colors.with_alpha(color, 0.25),
			border_color = colors.transparent,
			border_width = 0,
			height = 26,
			corner_radius = 5,
		},
		click_script = aerospace_path .. " workspace " .. shellQuote(workspace_name),
		drawing = true,
		updates = true,
		width = 26,
		padding_right = 0,
		padding_left = 0,
	})

	spaces[i] = space

	space:subscribe("aerospace_workspace_change", function(env)
		local focused_workspace = trim(env.FOCUSED_WORKSPACE or env.FOCUSED or env.AEROSPACE_FOCUSED_WORKSPACE)
		if focused_workspace == "" then
			updateActiveWorkspace()
			return
		end

		sbar.animate("tanh", 10, function()
			setWorkspaceStyle(i, focused_workspace == workspace_name)
		end)
	end)

	space:subscribe("mouse.clicked", function()
		updateActiveWorkspaceByName(workspace_name)
	end)

	workspace_spacers[i] = sbar.add("item", "aerospace_space_gap." .. workspace_name, {
		position = "left",
		icon = {
			drawing = false,
		},
		label = {
			drawing = false,
		},
		background = {
			color = colors.transparent,
			border_width = 0,
			padding_left = 0,
			padding_right = 0,
		},
		drawing = true,
		updates = false,
		width = workspace_gap,
		padding_left = 0,
		padding_right = 0,
	})
end

-- Front app display
local front_app = sbar.add("item", "front_app", {
	position = "left",
	display = "active",
	icon = { drawing = false },
	label = {
		font = {
			style = settings.font.style_map["Black"],
		},
		color = colors[appearance].orange,
	},
	updates = true,
	width = "dynamic",
	background = {
		color = colors.transparent,
		border_width = 0,
		padding_right = 13,
		padding_left = 13,
	},
})

local front_app_bracket = sbar.add("bracket", "front_app.bracket", {
	front_app.name,
}, {
	background = {
		color = colors[appearance].orange_bg,
		padding_left = 0,
		padding_right = 0,
		border_width = 0,
	},
	width = "dynamic",
	shadow = true,
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({
		label = {
			string = env.INFO,
			color = colors[appearance].orange,
		},
	})
end)

-- Event handling. Add this to ~/.aerospace.toml:
-- exec-on-workspace-change = ['/bin/bash', '-c', 'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE']

-- Create bracket with all spaces
local space_names = {}
for i = 1, max_spaces do
	table.insert(space_names, spaces[i].name)
	table.insert(space_names, workspace_spacers[i].name)
end

local bracket = sbar.add("bracket", "items.spaces.bracket", space_names, {
	background = {
		color = colors.transparent,
		border_width = 0,
		padding_left = 0,
		padding_right = 0,
	},
	shadow = false,
})

-- Appearance change handling
bracket:subscribe("apperace_change", function(env)
	sbar.exec("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'", function(theme)
		local new_appearance = trim(theme):lower()
		appearance = new_appearance

		sbar.animate("tanh", 10, function()
			front_app:set({
				label = {
					color = colors[appearance].orange,
				},
			})

			front_app_bracket:set({
				background = {
					color = colors[appearance].orange_bg,
				},
			})

			bracket:set({
				background = {
					color = colors.transparent,
				},
			})

			for index, _ in ipairs(spaces) do
				setWorkspaceStyle(index, false)
			end
		end)

		updateActiveWorkspace()
	end)
end)

-- Spacer
local spacer = sbar.add("item", "spacer.left.panel.inner", {
	icon = {
		drawing = false,
	},
	label = {
		drawing = false,
	},
	background = {
		color = colors.transparent,
		border_width = 0,
		padding_left = 0,
		padding_right = 0,
	},
	drawing = true,
	updates = true,
	width = 15,
})

-- Main panel bracket
sbar.add("bracket", "items.left.panel", {
	bracket.name,
	front_app_bracket.name,
	spacer.name,
}, {
	background = {
		color = colors.transparent,
		border_width = 0,
		height = 28,
		padding_left = 0,
		padding_right = 0,
		corner_radius = 5,
	},
})

-- Initial setup
updateActiveWorkspace()
