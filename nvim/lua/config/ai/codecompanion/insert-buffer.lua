local M = {}

M.requesting = false

local function insert_buffer(chat_bufnr, source_bufnr)
  local filepath = vim.api.nvim_buf_get_name(source_bufnr)
  if filepath == "" then
    return
  end

  local filename = vim.fn.fnamemodify(filepath, ":t")
  local relpath = vim.fn.fnamemodify(filepath, ":.:")

  local lines = vim.api.nvim_buf_get_lines(chat_bufnr, 0, -1, false)

  local last_me_line = nil
  for i = #lines, 1, -1 do
    if lines[i]:match("^## Me") then
      last_me_line = i
      break
    end
  end

  if not last_me_line then
    return
  end

  -- Find the most recent buffer block after the last "## Me".
  -- We treat the block as 4 lines:
  --   "" / "> Buffer:" / "" / "#{buffer:...}"
  local buffer_line = nil
  for i = last_me_line + 1, #lines do
    if lines[i]:match("^#{buffer:.*}$") then
      buffer_line = i
    end
  end

  local has_buf = false
  if buffer_line then
    -- Prefer matching the explicit <buf>...</buf> reference if present.
    -- Fallback to matching the filename in the #{buffer:...} line.
    local block_text = table.concat(lines, "\n", math.max(1, buffer_line - 3), buffer_line)
    if block_text:match("<buf>" .. vim.pesc(relpath) .. "</buf>") then
      has_buf = true
    elseif lines[buffer_line] == ("#{buffer:" .. filename .. "}") then
      has_buf = true
    end
  end

  -- delete buffer block
  if has_buf and buffer_line then
    vim.api.nvim_buf_set_lines(chat_bufnr, buffer_line - 4, buffer_line, false, {})
    return
  end

  -- update buffer line in the existing block
  if buffer_line then
    vim.api.nvim_buf_set_lines(chat_bufnr, buffer_line - 1, buffer_line, false, {
      "#{buffer:" .. filename .. "}",
    })
    return
  end

  -- add buffer block
  vim.api.nvim_buf_set_lines(chat_bufnr, last_me_line, last_me_line, false, {
    "",
    "> Buffer:",
    "",
    "#{buffer:" .. filename .. "}",
  })
end

local group = vim.api.nvim_create_augroup("CodeCompanionAutoBuffer", {})

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionChatCreated",
  group = group,
  callback = function(args)
    insert_buffer(args.buf, vim.fn.bufnr("#"))
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestStreaming" },
  group = group,
  callback = function()
    M.requesting = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionRequestFinished",
  group = group,
  callback = function()
    M.requesting = false
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  pattern = "*",
  callback = function(args)
    if M.requesting then
      return
    end
    if args.file == "" or vim.bo[args.buf].filetype == "codecompanion" then
      return
    end
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[bufnr].filetype == "codecompanion" and vim.api.nvim_buf_is_loaded(bufnr) then
        insert_buffer(bufnr, args.buf)
      end
    end
  end,
})
