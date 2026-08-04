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
  {
    "<A-Left>",
    function()
      require("smart-splits").resize_left()
    end,
    desc = "Resize Left Window",
  },
  {
    "<A-Down>",
    function()
      require("smart-splits").resize_down()
    end,
    desc = "Resize Lower Window",
  },
  {
    "<A-Up>",
    function()
      require("smart-splits").resize_up()
    end,
    desc = "Resize Upper Window",
  },
  {
    "<A-Right>",
    function()
      require("smart-splits").resize_right()
    end,
    desc = "Resize Right Window",
  },
}

return M
