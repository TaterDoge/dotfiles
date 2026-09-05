local M = {}

M.config = {
  open_mapping = [[<C-\>]],
  -- direction = "horizontal",
  direction = "float",
  shade_filetypes = {},
  hide_numbers = true,
  insert_mappings = true,
  terminal_mappings = true,
  start_in_insert = true,
  close_on_exit = true,
  highlights = {
    FloatBorder = {
      guifg = "#61AFEF",
    },
  },
  float_opts = {
    border = "curved",
  },
}

return M
