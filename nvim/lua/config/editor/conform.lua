return {
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    markdown = { "prettier" },
    html = { "biome-check" },
    css = { "biome-check" },
    scss = { "prettier" },
    vue = { "oxfmt", "prettier" },
    json = { "biome-check" },
    jsonc = { "biome-check" },
    javascript = { "biome-check" },
    typescript = { "biome-check" },
    javascriptreact = { "biome-check" },
    typescriptreact = { "biome-check" },
  },
}
