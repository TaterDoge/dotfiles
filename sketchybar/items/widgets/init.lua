require("items.widgets.calendar")
require("items.widgets.wifi")
require("items.widgets.codeplan")

local colors = require("colors")

sbar.add("bracket", "items.right.panel", {
	"widgets.codeplan.bracket",
	"widgets.wifi.bracket",
	"widgets.calendar.bracket",
}, {
	background = {
		color = colors.dark.bar.transparent,
		border_width = 0,
		height = 28,
		padding_left = 0,
		padding_right = 0,
		corner_radius = 5,
	},
})
