-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local utils = require("utils")

-- 调用easydict翻译快捷键
Snacks.keymap.set({ "n", "v" }, "<leader>mm", function()
  local mode = vim.fn.mode()
  local selected_text = utils.encodeURL(utils.get_text(mode))
  os.execute("open easydict://" .. selected_text)
  vim.api.nvim_input("<Esc>")
end, { desc = "翻译" })

Snacks.keymap.set("n", "<leader>fP", function()
  Snacks.picker.projects()
end, { desc = "打开项目管理" })

-- 快速查询单词
Snacks.keymap.set("n", "?", "*")

------------------
--- MOVE
------------------
-- 替代^ 跳转到行首
Snacks.keymap.set("n", "<leader>h", "^", { desc = "跳转到行首" })
Snacks.keymap.set("v", "<leader>h", "^", { desc = "跳转到行首" })
-- 替代$ 跳转到行尾
Snacks.keymap.set("n", "<leader>l", "$", { desc = "跳转到行尾" })
Snacks.keymap.set("v", "<leader>l", "$", { desc = "跳转到行尾" })

-- 保存文件
Snacks.keymap.set("n", "<leader>sa", "<cmd>:w<cr>", { desc = "保存文件" })

-- accelerated-jk 加速jk移动
Snacks.keymap.set("n", "j", "<Plug>(faster_move_gj)")
Snacks.keymap.set("n", "k", "<Plug>(faster_move_gk)")
Snacks.keymap.set({ "n", "v" }, "<S-j>", "5j")
Snacks.keymap.set({ "n", "v" }, "<S-k>", "5k")

-- 插入模式下移动光标
Snacks.keymap.set("i", "<C-a>", "<End>")
Snacks.keymap.set("i", "<C-i>", "<ESC>^i")
Snacks.keymap.set("i", "<C-h>", "<Left>")
Snacks.keymap.set("i", "<C-l>", "<Right>")
Snacks.keymap.set("i", "<C-j>", "<Down>")
Snacks.keymap.set("i", "<C-k>", "<Up>")

-- 插入模式快速退出
Snacks.keymap.set("i", "jk", "<Esc>")

Snacks.keymap.set("n", "<leader>bD", function()
  Snacks.bufdelete.all()
end, { desc = "删除所有buffer" })

-- Opencode 快速插入当前文件（推荐快捷键）
local function copy_file_mention()
  local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  local mode = vim.fn.mode()
  local mention = "@" .. filepath

  if mode == "v" or mode == "V" then
    local s_row, e_row = unpack(utils.get_range())
    local line_range = s_row == e_row and tostring(s_row) or (s_row .. "-" .. e_row)
    local selected_text = utils.get_text(mode)
    mention = string.format("%s:%s %s", mention, line_range, selected_text)
  end

  vim.fn.setreg("+", mention)
  vim.notify("✅ 已复制到剪贴板：" .. mention, vim.log.levels.INFO, { title = "file path快捷复制" })
end

vim.keymap.set("n", "<leader>cp", copy_file_mention, { desc = "快速获取当前文件 @提及" })
vim.keymap.set("x", "<leader>cp", copy_file_mention, { desc = "快速获取当前文件 @提及和选区" })

------------------
--- LSP
------------------
Snacks.keymap.set("n", "<leader>co", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports" },
      diagnostics = {},
    },
  })
end, {
  desc = "删除所有未使用的导入",
})

Snacks.keymap.set("n", "<leader>ci", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.addMissingImports" },
      diagnostics = {},
    },
  })
end, {
  desc = "导入所有未导入的组件",
})
