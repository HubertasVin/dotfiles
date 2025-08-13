return {
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "asm",
        "awk",
        "bash",
        "c",
        "c_sharp",
        "cmake",
        "cpp",
        "css",
        "go",
        "haskell",
        "html",
        "json",
        "java",
        "javascript",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "php",
        "phpdoc",
        "python",
        "ruby",
        "rust",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "xml",
        "yaml",
        "vim",
        "vimdoc",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },
  {
    "towolf/vim-helm",
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "angular-language-server",
        "ansible-language-server",
        "ansible-lint",
        "bash-language-server",
        "black",
        "clangd",
        "clang-format",
        "csharp-language-server",
        "css-lsp",
        "dockerfile-language-server",
        "docker-compose-language-service",
        "google-java-format",
        "gopls",
        "gofumpt",
        "golines",
        "html-lsp",
        "helm-ls",
        "java-language-server",
        "json-lsp",
        "lemminx",
        "lua-language-server",
        "sqlls",
        "stylua",
        "phpcbf",
        "prettier",
        "python-lsp-server",
        "pyink",
        "rust-analyzer",
        "typescript-language-server",
        "tailwindcss-language-server",
        "taplo",
        "yaml-language-server",
        "yamllint",
      },
    },
  },

  {
    "smoka7/hop.nvim",
    config = function()
      require("hop").setup()
    end,
    event = "BufRead", -- Lazy load on buffer read
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("todo-comments").setup {
        keywords = {
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
        colors = {
          hint = { "Hint", "#FBBF24" },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
}
