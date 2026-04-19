return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = require("config.editor.smart-splits").keys,
    opts = {
      multiplexer_integration = "tmux",
    },
  },

  -- 代码格式化
  {
    "stevearc/conform.nvim",
    opts = require("config.editor.conform"),
  },

  -- git状态
  {
    "gitsigns.nvim",
    opts = require("config.editor.gitsigns").config,
  },

  -- 加速jk移动 https://github.com/rainbowhxch/accelerated-jk.nvim
  {
    "PHSix/faster.nvim",
    event = { "VimEnter *" },
  },

  -- 多光标插件 https://github.com/mg979/vim-visual-multi
  {
    "mg979/vim-visual-multi",
    lazy = false,
  },

  -- 布尔切换
  {
    "nguyenvukhang/nvim-toggler",
    keys = {
      {
        "<leader>i",
        function()
          require("nvim-toggler").toggle()
        end,
        desc = "切换布尔值",
      },
    },
    opts = {},
  },

  -- 快捷打开yazi https://github.com/DreamMaoMao/yazi.nvim
  {
    "DreamMaoMao/yazi.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>yz",
        "<cmd>Yazi<cr>",
        desc = "打开yazi面板",
      },
    },
  },

  -- 浮动终端 https://github.com/nvzone/floaterm
  {
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    keys = {
      {
        "<C-\\>",
        mode = { "n", "i", "t" },
        "<cmd>FloatermToggle<cr>",
        desc = "切换FloatTerminal",
      },
    },
    opts = {
      border = true,
      size = { h = 80, w = 80 },
      mappings = {
        term = function(buf)
          vim.keymap.set({ "n", "t" }, "<C-p>", function()
            require("floaterm.api").cycle_term_bufs("prev")
          end, { buffer = buf })
        end,
      },
    },
    cmd = "FloatermToggle",
  },

  -- markdown 预览
  {
    "iamcco/markdown-preview.nvim",
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
  },
}
