local options = {
  formatters_by_ft = {
    angular = { "prettier" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    css = { "prettier" },
    html = { "prettier" },
    java = { "google-java-format" },
    javascript = { "prettier" },
    json = { "prettier" },
    jsx = { "prettier" },
    lua = { "stylua" },
    php = { "phpcbf" },
    python = { "black" },
    rust = { "rustfmt" },
    scss = { "prettier" },
    typescript = { "prettier" },
    bash = { "beautysh" },
    sh = { "beautysh" },
    zsh = { "beautysh" },
    vue = { "prettier" },
  },

  formatters = {
    black = {
      command = "black",
      args = { "--quiet", "-" },
      stdin = true,
    },
    ["clang-format"] = {
      command = "clang-format",
      args = { "--style={IndentWidth: 4, TabWidth: 4}" },
      stdin = true,
    },
    ["google-java-format"] = {
      command = "google-java-format",
      args = { "--aosp", "-" },
      stdin = true,
    },
    ["rustfmt"] = {
      command = "rustfmt",
      args = { "--emit=stdout" },
      stdin = true,
    },
  },
}

require("conform").setup(options)
