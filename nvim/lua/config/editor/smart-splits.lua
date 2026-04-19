local M = {}

M.keys = {
  {
    "<C-h>",
    function()
      require("smart-splits").move_cursor_left()
    end,
    desc = "Go to Left Window",
  },
  {
    "<C-j>",
    function()
      require("smart-splits").move_cursor_down()
    end,
    desc = "Go to Lower Window",
  },
  {
    "<C-k>",
    function()
      require("smart-splits").move_cursor_up()
    end,
    desc = "Go to Upper Window",
  },
  {
    "<C-l>",
    function()
      require("smart-splits").move_cursor_right()
    end,
    desc = "Go to Right Window",
  },
}

return M
