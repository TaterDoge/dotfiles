local env = require("config.env")

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = env.theme,
    },
    dependencies = {
      "lewis6991/async.nvim",
    },
  },
}
