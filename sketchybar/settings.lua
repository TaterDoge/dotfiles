return {
    paddings = 3,
    group_paddings = 5,

    icons = "NerdFont", -- alternatively available: sf-symbols

    -- This is a font configuration for SF Pro and SF Mono (installed manually)
    -- font = require("helpers.default_font"),

    -- Font config for JetBrainsMono Nerd Font.
    font = {
        text = "JetBrainsMono Nerd Font",    -- Used for text
        numbers = "JetBrainsMono Nerd Font", -- Used for numbers
        style_map = {
            ["Thin"] = "Thin",
            ["Regular"] = "Regular",
            ["Semibold"] = "Medium",
            ["Bold"] = "SemiBold",
            ["Heavy"] = "Bold",
            ["Black"] = "ExtraBold",
        },
    },
}
