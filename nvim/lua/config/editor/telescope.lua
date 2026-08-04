local M = {}

M.keys = {
  { "<leader>sa", false },
  {
    "<leader>fp",
    function()
      require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
    end,
    desc = "查找插件文件",
  },
}

M.config = {
  extensions = {
    "refactoring",
  },
  defaults = {
    winblend = 0,
    initial_mode = "insert",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--fixed-strings", -- 全局禁用正则，按字面匹配
    },
  },
}

return M
