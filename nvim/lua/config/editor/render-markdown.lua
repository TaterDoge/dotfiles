-- ---------------------------------------------------------------------------
-- render-markdown
-- ---------------------------------------------------------------------------

-- Setup custom reverse video render-markdown heading hl groups based on
-- the fg color of existing markdown hl groups. This provides the fancy
-- headings when in preview mode.
local setup_heading_hl_groups = function()
  local function pick_hl(names)
    for _, name in ipairs(names) do
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
      if ok and hl and (hl.fg or hl.bg) then
        return hl
      end
    end
    return nil
  end

  local function to_hl_spec(hl)
    local spec = {}
    if hl.fg then
      spec.fg = hl.fg
    end
    if hl.bg then
      spec.bg = hl.bg
    end
    if hl.bold then
      spec.bold = true
    end
    if hl.italic then
      spec.italic = true
    end
    if hl.underline then
      spec.underline = true
    end
    if hl.undercurl then
      spec.undercurl = true
    end
    return spec
  end

  local fallback_hl_info = pick_hl({ "@markup.heading", "Title" }) or {}

  for lvl = 1, 6 do
    local hl_info = pick_hl({
      "@markup.heading." .. lvl .. ".markdown",
      "@markup.heading." .. lvl,
      "markdownH" .. lvl,
      "htmlH" .. lvl,
      "Title",
    }) or fallback_hl_info

    local hl_spec = to_hl_spec(hl_info)

    vim.api.nvim_set_hl(0, "RenderMarkdownH" .. lvl, hl_spec)

    local bg_spec = vim.tbl_extend("force", {}, hl_spec, { reverse = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH" .. lvl .. "Bg", bg_spec)
  end
end

-- Set the heading hl groups on VimEnter and autocmd for colorscheme changes
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("render_markdown_heading_hl", { clear = true }),
  once = true,
  callback = setup_heading_hl_groups,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("render_markdown_colorscheme", { clear = true }),
  desc = "Setup heading hl groups for render markdown.",
  callback = setup_heading_hl_groups,
})

return {
  file_types = { "markdown", "md", "codecompanion", "opencode_output" },
  render_modes = { "n", "no", "c", "t", "i", "ic" },
  code = {
    sign = false,
    border = "thin",
    position = "right",
    width = "block",
    above = "▁",
    below = "▔",
    language_left = "█",
    language_right = "█",
    language_border = "▁",
    left_pad = 1,
    right_pad = 1,
  },
  heading = {
    sign = false,
    width = "block",
    left_pad = 1,
    right_pad = 0,
    position = "right",
    icons = function(ctx)
      return (""):rep(ctx.level) .. ""
    end,
  },
}
