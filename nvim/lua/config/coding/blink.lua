return {
  sources = {
    default = { "snippets", "lsp", "path", "buffer" },
    per_filetype = {
      codecompanion = { "codecompanion" },
    },
  },
  completion = {
    ghost_text = {
      enabled = true,
    },
    menu = {
      border = {
        { "󱐋", "WarningMsg" },
        "─",
        "╮",
        "│",
        "╯",
        "─",
        "╰",
        "│",
      },
      draw = {
        columns = { { "kind_icon" }, { "label", gap = 1 } },
        components = {
          label = {
            text = function(ctx)
              return require("colorful-menu").blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return require("colorful-menu").blink_components_highlight(ctx)
            end,
          },
        },
      },
    },
    documentation = {
      auto_show = true,
      window = {
        border = {
          { "", "DiagnosticHint" },
          "─",
          "╮",
          "│",
          "╯",
          "─",
          "╰",
          "│",
        },
      },
    },
  },

  keymap = {
    ["<Tab>"] = {
      "select_next",
      function(cmp)
        if cmp.snippet_active() then
          return cmp.snippet_forward()
        end
      end,
      "fallback",
    },
    ["<S-Tab>"] = { "select_prev", "fallback" },
  },
}
