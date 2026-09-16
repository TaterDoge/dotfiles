return {
  animate = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  dashboard = {
    width = 100,
    preset = {
      header = [[
       ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷
       ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇
       ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽
       ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕
       ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕
       ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕
       ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄
       ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕
       ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿
       ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
       ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟
       ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠
       ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙
       ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣
          ]],
    },
    -- sections = {
    --   {
    --     section = "terminal",
    --     cmd = "ghosttime",
    --     pane = 1,
    --     width = 80,
    --     height = 50,
    --   },
    --   { section = "header", padding = 4, pane = 2 },
    --   { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 2, pane = 2 },
    --   { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2, pane = 2 },
    --   function()
    --     local in_git = Snacks.git.get_root() ~= nil
    --     local cmds = {
    --       {
    --         icon = " ",
    --         title = "Git Status",
    --         cmd = "git --no-pager diff --stat -B -M -C",
    --         height = 10,
    --       },
    --     }
    --     return vim.tbl_map(function(cmd)
    --       return vim.tbl_extend("force", {
    --         pane = 2,
    --         section = "terminal",
    --         enabled = in_git,
    --         padding = 1,
    --         ttl = 5 * 60,
    --         indent = 3,
    --       }, cmd)
    --     end, cmds)
    --   end,
    --   { section = "startup", pane = 2 },
    -- },
  },
  scroll = {
    filter = function(buf)
      return vim.g.snacks_scroll ~= false
        and vim.b[buf].snacks_scroll ~= false
        and vim.bo[buf].buftype ~= "terminal"
        and vim.bo[buf].filetype ~= "blink-cmp-menu"
    end,
  },
  picker = {
    sources = {
      files = {
        exclude = { "node_modules", "dist", "build" },
      },
    },
  },
}
