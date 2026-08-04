-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("associate_filetype"),
  pattern = { "*" },
  callback = function()
    vim.opt.formatoptions:remove({ "o" }) -- 防止使用 o 切换到下一行的时候自动加上注释符号(在上一行是注释的情况下)
  end,
})

if vim.g.neovide then
  local neovide = require("utils.neovide")
  neovide.init()
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.dart",
  callback = function()
    local pubspec = vim.fn.findfile("pubspec.yaml", ".;")
    if pubspec ~= "" then
      pcall(vim.cmd, "FlutterReload")
    end
  end,
})
