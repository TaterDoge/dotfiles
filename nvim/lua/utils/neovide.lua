local M = {}

function M.init()
  M.config()
  M.background()
  M.refresh(60, 5)
  M.theme()
end

function M.config()
  vim.o.winborder = "none"
  vim.o.guifont = "Maple_Mono_NF_CN:h14:i"
  -- 没有空闲
  vim.g.neovide_no_idle = true
  -- 退出需要确认
  vim.g.neovide_confirm_quit = true
  -- 开启Alt和Meta按键
  vim.g.neovide_input_macos_option_key_is = true
  -- 触控板死亡地带
  vim.g.neovide_touch_deadzone = 6.0
  -- 触控板拖动超时
  vim.g.neovide_touch_drag_timeout = 0.17
  -- macos option -> alt
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"

  --- 光标 ---
  ------------
  -- 光标粒子
  vim.g.neovide_cursor_vfx_mode = "ripple"
  -- 抗锯齿
  vim.g.neovide_cursor_antialiasing = true
  -- 插入动画
  vim.g.neovide_cursor_animate_in_insert_mode = true
  -- 光标闪烁
  vim.g.neovide_cursor_smooth_blink = false
  -- 动画切换到命令行
  vim.g.neovide_cursor_animate_command_line = true
  vim.g.neovide_alpha_composition = false

  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<D-v>", '<c-\\><c-n>"+pa', { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
end

function M.background()
  -- 设置透明背景
  vim.g.neovide_opacity = 1
  -- 窗口模糊
  vim.g.neovide_window_blurred = true

  -- 浮动边框圆角
  vim.g.neovide_floating_corner_radius = 0.5

  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 10
  vim.g.neovide_light_radius = 50
end

-- 设置fps
function M.refresh(run_fps, free_fps)
  -- 设置刷新率
  vim.g.neovide_refresh_rate = run_fps
  -- 空闲刷新率
  vim.g.neovide_refresh_rate_idle = free_fps
end

function M.theme()
  vim.g.terminal_color_0 = "#45475a"
  vim.g.terminal_color_1 = "#f38ba8"
  vim.g.terminal_color_2 = "#a6e3a1"
  vim.g.terminal_color_3 = "#f9e2af"
  vim.g.terminal_color_4 = "#89b4fa"
  vim.g.terminal_color_5 = "#f5c2e7"
  vim.g.terminal_color_6 = "#94e2d5"
  vim.g.terminal_color_7 = "#bac2de"
  vim.g.terminal_color_8 = "#585b70"
  vim.g.terminal_color_9 = "#f38ba8"
  vim.g.terminal_color_10 = "#a6e3a1"
  vim.g.terminal_color_11 = "#f9e2af"
  vim.g.terminal_color_12 = "#89b4fa"
  vim.g.terminal_color_13 = "#f5c2e7"
  vim.g.terminal_color_14 = "#94e2d5"
  vim.g.terminal_color_15 = "#a6adc8"
end

return M
