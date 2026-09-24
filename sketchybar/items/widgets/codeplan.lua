local colors = require("colors")
local settings = require("settings")

local function trim(value)
	return tostring(value or ""):match("^%s*(.-)%s*$")
end

local function current_appearance()
	local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null || echo 'Light'")
	local output = handle and trim(handle:read("*a")):lower() or "light"
	if handle then
		handle:close()
	end
	return output
end

local appearance = current_appearance()

local function palette()
	return colors[appearance]
end

local popup_width = 300
local popup_padding = 10
local bar_height = 8
local widget_width = 112
local widget_bar_height = 5

local dashboard_url = "https://dash.x-aio.com/dashboard/tokens-plan"

local codeplan_status = sbar.add("item", "widgets.codeplan.status", {
	position = "right",
	width = 0,
	update_freq = 300,
	y_offset = 4,
	icon = {
		string = "--/--",
		width = 76,
		align = "left",
		padding_left = 0,
		padding_right = 0,
		color = palette().green,
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
	},
	label = {
		string = "--%",
		width = 36,
		align = "right",
		padding_left = 0,
		padding_right = 0,
		color = palette().green,
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
	},
})

local codeplan_progress_rest = sbar.add("item", "widgets.codeplan.progress_rest", {
	position = "right",
	width = widget_width,
	y_offset = -5,
	icon = {
		drawing = false,
	},
	label = { drawing = false },
	background = {
		color = colors.with_alpha(palette().green, 0.2),
		height = widget_bar_height,
		corner_radius = 2,
		border_width = 0,
	},
})

local codeplan_progress_fill = sbar.add("item", "widgets.codeplan.progress_fill", {
	position = "right",
	width = 0,
	y_offset = -5,
	icon = { drawing = false },
	label = { drawing = false },
	background = {
		color = palette().green,
		height = widget_bar_height,
		corner_radius = 2,
		border_width = 0,
	},
})

local codeplan_separator = sbar.add("item", "widgets.codeplan.separator", {
	position = "right",
	icon = { drawing = false },
	label = {
		string = "T ⋮",
		font = { family = settings.font.numbers },
		color = palette().green,
		padding_right = 6,
	},
})

local codeplan_bracket = sbar.add("bracket", "widgets.codeplan.bracket", {
	codeplan_separator.name,
	codeplan_status.name,
	codeplan_progress_rest.name,
	codeplan_progress_fill.name,
}, {
	background = {
		color = palette().green_bg,
		border_width = 0,
	},
	popup = {
		align = "center",
		background = {
			border_width = 0,
		},
		height = 25,
	},
})

local popup_position = "popup." .. codeplan_bracket.name

sbar.add("item", "widgets.codeplan.padding", {
	position = "right",
	width = settings.group_paddings,
})

local popup_background = {
	color = colors.transparent,
	border_width = 0,
	height = 0,
	padding_left = popup_padding,
	padding_right = popup_padding,
}

local function popup_item(name, props)
	props.position = popup_position
	props.width = props.width or popup_width
	props.background = props.background or popup_background
	return sbar.add("item", "widgets.codeplan." .. name, props)
end

local function popup_spacer(name)
	popup_item(name, {
		icon = { drawing = false },
		label = { string = "" },
	})
end

local function clamp_percent(percent)
	return math.max(0, math.min(100, tonumber(percent) or 0))
end

local function percent_width(percent, width)
	return math.floor(clamp_percent(percent) / 100 * width + 0.5)
end

local function set_bar_percent(label_item, bar_item, percent)
	local percent_value = clamp_percent(percent)
	bar_item:set({ icon = { width = percent_width(percent_value, popup_width) } })
	label_item:set({ label = { string = percent_value .. "%" } })
end

-- 40510 -> "40.5k", 300000 -> "300k", 1200000 -> "1.2M"
local function format_credits(value)
	value = tonumber(value) or 0
	if value >= 1000000 then
		return (string.format("%.2f", value / 1000000):gsub("%.?0+$", "")) .. "M"
	end
	if value >= 1000 then
		return (string.format("%.1f", value / 1000):gsub("%.0$", "")) .. "k"
	end
	return string.format("%.0f", value)
end

-- ── Section: current billing period ───────────────────────────────────

popup_spacer("spacer_0")

local session_label = popup_item("session_label", {
	icon = {
		string = "Credits",
		color = palette().magenta,
		width = popup_width / 2,
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 18.0,
		},
	},
	label = {
		string = "--%",
		color = palette().magenta,
		align = "right",
		width = popup_width / 2,
		font = {
			family = settings.font.numbers,
			size = 13.0,
		},
	},
})

local session_bar = popup_item("session_bar", {
	icon = {
		string = " ",
		width = 0,
		align = "left",
		padding_left = 0,
		padding_right = 0,
		background = {
			color = palette().magenta,
			height = bar_height,
			corner_radius = 2,
		},
	},
	label = { drawing = false },
	background = {
		color = colors.with_alpha(palette().magenta, 0.2),
		height = bar_height,
		corner_radius = 2,
		border_width = 0,
		padding_left = popup_padding,
		padding_right = popup_padding,
	},
})

local session_reset = popup_item("session_reset", {
	icon = { drawing = false },
	label = {
		string = "Used: --",
		color = palette().grey,
		font = {
			family = settings.font.numbers,
			size = 13.0,
		},
	},
})

local plan_label = popup_item("plan_label", {
	icon = { drawing = false },
	label = {
		string = "",
		color = palette().grey,
		font = {
			family = settings.font.numbers,
			size = 13.0,
		},
	},
})

local link = popup_item("link", {
	icon = { drawing = false },
	label = {
		string = "open dashboard  ",
		color = palette().grey,
		font = {
			family = settings.font.numbers,
			size = 16.0,
		},
	},
	align = "right",
	click_script = "open " .. dashboard_url,
})

popup_spacer("spacer_1")

-- ── Data source ───────────────────────────────────────────────────────
-- helpers/xaio_usage.sh pulls the auth token out of Chrome's cookie jar and
-- prints the credit_plan/account JSON, so the user never pastes a token:
-- being logged in to dash.x-aio.com in Chrome is enough.

local usage_script = "$HOME/.config/sketchybar/helpers/xaio_usage.sh"

local function get_xaio_usage(callback)
	sbar.exec(usage_script, function(result)
		if type(result) ~= "table" or result.code ~= "200" then
			local message = type(result) == "table" and result.message or nil
			callback({ error = message or "Login to dash.x-aio.com" })
			return
		end

		local data = type(result.data) == "table" and result.data or {}
		local quota = tonumber(data.base_quota) or 0
		local remaining = tonumber(data.base_balance) or 0
		local used = math.max(0, quota - remaining)
		local plan = type(data.current_plan) == "table" and data.current_plan or {}

		callback({
			quota = quota,
			used = used,
			remaining = remaining,
			percent = quota > 0 and math.floor(used / quota * 100 + 0.5) or 0,
			plan = plan.plan_level_name,
			period = plan.plan_period_name,
			reset = tostring(data.next_reset_time or data.current_period_end or "")
				:gsub("T", " ")
				:sub(1, 16),
		})
	end)
end

local popup_open
local has_usage_data = false

local function clear_widget_progress()
	codeplan_progress_fill:set({
		width = 0,
		background = { color = colors.transparent },
	})
	codeplan_progress_rest:set({
		width = widget_width,
		background = { color = colors.transparent },
	})
end

local function apply_widget_error()
	local c = palette()
	has_usage_data = false
	codeplan_status:set({
		y_offset = 0,
		icon = { drawing = false },
		label = {
			string = "Click Auth",
			width = widget_width,
			align = "left",
			color = c.green,
		},
	})
	clear_widget_progress()
end

local function apply_widget_usage(result)
	local c = palette()
	has_usage_data = true
	codeplan_status:set({
		y_offset = 4,
		icon = {
			drawing = true,
			string = format_credits(result.used) .. "/" .. format_credits(result.quota),
			width = 76,
			color = c.green,
		},
		label = {
			string = result.percent .. "%",
			width = 36,
			align = "right",
			color = c.green,
		},
	})
	local used_width = percent_width(result.percent, widget_width)
	codeplan_progress_fill:set({
		width = used_width,
		background = { color = c.green },
	})
	codeplan_progress_rest:set({
		width = widget_width - used_width,
		background = { color = colors.with_alpha(c.green, 0.2) },
	})
end

local function apply_widget_result(result)
	if result.error then
		apply_widget_error()
		return
	end
	apply_widget_usage(result)
end

local function apply_popup_result(result)
	if not popup_open() then
		return
	end

	if result.error then
		local c = palette()
		session_label:set({ label = { string = "Login" } })
		session_bar:set({ icon = { width = 0 } })
		session_reset:set({ label = { string = result.error } })
		plan_label:set({ label = { string = "click to open dashboard" } })
		return
	end

	local c = palette()
	set_bar_percent(session_label, session_bar, result.percent)
	session_reset:set({
		label = {
			string = "Used: " .. format_credits(result.used) .. " / " .. format_credits(result.quota),
		},
	})
	plan_label:set({
		label = {
			string = trim(
				table.concat({ result.plan or "", result.period or "" }, " ")
					.. (result.reset ~= "" and ("  ·  resets " .. result.reset) or "")
			),
			color = c.grey,
		},
	})
end

local function update_usage()
	get_xaio_usage(function(result)
		apply_widget_result(result)
		apply_popup_result(result)
	end)
end

codeplan_bracket:subscribe("apperace_change", function()
	appearance = current_appearance()

	sbar.animate("tanh", 10, function()
		local c = palette()
		codeplan_bracket:set({ background = { color = c.green_bg } })
		codeplan_separator:set({ label = { color = c.green } })
		codeplan_status:set({
			icon = { color = c.green },
			label = { color = c.green },
		})
		if has_usage_data then
			codeplan_progress_fill:set({
				background = { color = c.green },
			})
			codeplan_progress_rest:set({
				background = { color = colors.with_alpha(c.green, 0.2) },
			})
		else
			clear_widget_progress()
		end
		session_label:set({
			icon = { color = c.magenta },
			label = { color = c.magenta },
		})
		session_bar:set({
			icon = { background = { color = c.magenta } },
			background = { color = colors.with_alpha(c.magenta, 0.2) },
		})
		session_reset:set({ label = { color = c.grey } })
		plan_label:set({ label = { color = c.grey } })
		link:set({ label = { color = c.grey } })
	end)
end)

popup_open = function()
	return codeplan_bracket:query().popup.drawing == "on"
end

codeplan_status:subscribe({ "forced", "routine", "system_woke" }, function()
	update_usage()
end)

local function codeplan_collapse()
	if not popup_open() then
		return
	end
	codeplan_bracket:set({ popup = { drawing = false } })
end

local function codeplan_toggle()
	if popup_open() then
		codeplan_collapse()
		return
	end

	codeplan_bracket:set({ popup = { drawing = true } })
	update_usage()
end

local function codeplan_status_click()
	if has_usage_data then
		codeplan_toggle()
		return
	end
	sbar.exec("open " .. dashboard_url)
end

codeplan_separator:subscribe("mouse.clicked", codeplan_toggle)
codeplan_status:subscribe("mouse.clicked", codeplan_status_click)
codeplan_progress_fill:subscribe("mouse.clicked", codeplan_toggle)
codeplan_progress_rest:subscribe("mouse.clicked", codeplan_toggle)

for _, item in ipairs({ codeplan_separator, codeplan_status, codeplan_progress_fill, codeplan_progress_rest }) do
	item:subscribe("mouse.exited.global", codeplan_collapse)
end

update_usage()
