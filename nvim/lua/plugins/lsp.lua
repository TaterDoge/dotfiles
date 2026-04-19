return {
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "fish-lsp",
        "biome",
        "rustfmt",
        "json-lsp",
        "vtsls",
        "prisma-language-server",
        "tailwindcss-language-server",
        "svelte-language-server",
        "vue-language-server",
        "css-lsp",
        "css-variables-language-server",
        "oxlint",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "scss", "css", "gitignore" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- 不要覆盖整个 servers，而是合并配置
      opts.servers = opts.servers or {}

      -- 只为所有 servers 设置键绑定禁用
      opts.servers["*"] = {
        keys = {
          { "K", false },
          { "<C-k>", false, mode = { "i" } },
          { "gd", false },
          { "gh", false },
          { "<leader>ca", false },
        },
      }
    end,
  },

  -- lsp 操作增强 https://github.com/nvimdev/lspsaga.nvim
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
    keys = require("config.lsp.lspsage").keys,
    opts = require("config.lsp.lspsage").config,
  },
}
