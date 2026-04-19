return {
  -- 主题
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = require("config.ui.catppuccin"),
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = require("config.ui.tokyonight"),
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "auto",
      dark_variant = "moon",
      styles = {
        transparency = true,
      },
    },
  },
  {
    "sainnhe/everforest",
    init = function()
      vim.g.everforest_background = "soft"
      -- vim.g.everforest_transparent_background = 1
    end,
  },

  {
    "Shatur/neovim-ayu",
    -- dir = "~/Project/neovim-ayu",
    config = function()
      require("ayu").setup({
        mirage = false,
        overrides = function()
          local c = require("ayu.colors")
          return {
            LineNr = { fg = c.fg_idle },

            RenderMarkdownCode = { bg = c.selection_inactive },
            RenderMarkdownCodeBorder = { bg = c.selection_bg },
            RenderMarkdownCodeInline = { fg = c.tag, bg = c.selection_inactive },
            RenderMarkdownTableHead = { fg = c.selection_bg },
            RenderMarkdownTableRow = { fg = c.selection_bg },

            ["@markup.heading"] = { fg = c.keyword, bold = true },
            ["@markup.heading.1"] = { fg = c.accent, bold = true },
            ["@markup.heading.2"] = { fg = c.keyword, bold = true },
            ["@markup.heading.3"] = { fg = c.markup, bold = true },
            ["@markup.heading.4"] = { fg = c.entity, bold = true },
            ["@markup.heading.5"] = { fg = c.regexp, bold = true },
            ["@markup.heading.6"] = { fg = c.string, bold = true },
            ["@markup.strong"] = { fg = c.keyword, bold = true },
            ["@markup.italic"] = { fg = c.keyword, italic = true },
            ["@markup.quote"] = { fg = c.constant, italic = true },
            ["@markup.raw"] = { fg = c.tag, bg = c.selection_inactive },
            ["@markup.list"] = { fg = c.vcs_added },
            ["@markup.raw.block"] = { fg = c.tag },
            ["@module"] = { fg = c.fg },
            ["@string.documentation"] = { fg = c.lsp_inlay_hint },
            ["@variable.builtin"] = { fg = c.fg },
          }
        end,
      })
    end,
  },
}
