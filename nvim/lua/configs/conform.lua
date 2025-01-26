local options = {
  formatters_by_ft = {
    angular = { "prettier" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    json = { "prettier" },
    jsx = { "prettier" },
    lua = { "stylua" },
    rust = { "rust_analyzer" },
    scss = { "prettier" },
    typescript = { "prettier" },
    bash = { "beautysh" },
    sh = { "beautysh" },
    zsh = { "beautysh" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 200,
    lsp_fallback = true,
  },

  formatters = {
    ["clang-format"] = {
      command = "clang-format",
      args = { "--style={IndentWidth: 4, TabWidth: 4}" },
      stdin = true,
    },
  },
}

require("conform").setup(options)
