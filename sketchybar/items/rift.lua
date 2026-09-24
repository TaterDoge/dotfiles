local colors = require("colors")
local settings = require("settings")
local rift = require("riftapi")

local workspace_numbers = { "1", "2", "3", "4", "5", "6" }
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
local max_spaces = #workspace_numbers
local spaces = {}
local workspace_spacers = {}
local workspace_gap = 6

local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'")
local output = handle and handle:read("*a"):match("^%s*(.-)%s*$"):lower() or "light"
if handle then
	handle:close()
end
local appearance = output

sbar.add("event", "rift_workspace_change")

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

-- riftapi native Mach query; no shell spawn, survives rift restarts
local function updateActiveWorkspace()
	local workspaces, err = rift.query.workspaces()
	if not workspaces then
		return
	end

	local active_index = nil
	for i, workspace in ipairs(workspaces) do
		if workspace.is_active then
			active_index = i
			break
		end
	end

	sbar.animate("tanh", 10, function()
		for i = 1, max_spaces do
			setWorkspaceStyle(i, i == active_index)
		end
	end)
end

-- Create workspace items
for i = 1, max_spaces do
	local color = workspaceColor(i)
	local space = sbar.add("item", "rift_space." .. i, {
		position = "left",
		label = {
			drawing = false,
		},
		icon = {
			string = workspace_numbers[i],
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
		updates = true,
		width = 26,
		padding_right = 0,
		padding_left = 0,
	})

	spaces[i] = space

	-- native Mach call, no shell spawn
	space:subscribe("mouse.clicked", function()
		rift.workspace.switch(i - 1)
	end)

	workspace_spacers[i] = sbar.add("item", "rift_space_gap." .. i, {
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
	shadow = false,
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({
		label = {
			string = env.INFO,
			color = colors[appearance].orange,
		},
	})
end)

-- Event handling: rift-cli subscriptions in ~/.config/rift/config.toml
-- trigger this event on workspace_changed / windows_changed.
local rift_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

rift_observer:subscribe("rift_workspace_change", updateActiveWorkspace)

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
bracket:subscribe("apperace_change", function(_)
	sbar.exec("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'", function(theme)
		local new_appearance = theme:match("^%s*(.-)%s*$"):lower()
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
