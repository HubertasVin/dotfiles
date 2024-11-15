return {
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = { "asm", "awk", "bash", "c", "c_sharp", "cmake", "cpp", "css", "go", "haskell", "html", "json", "java","javascript", "lua", "luadoc", "make", "markdown", "php", "phpdoc", "python", "ruby", "rust", "sql", "toml", "tsx", "typescript", "xml", "yaml", "vim", "vimdoc" },
  	},
  },

  {
    "stevearc/conform.nvim",
    event = 'BufWritePre',
    config = function()
      require "configs.conform"
    end,
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
  			"lua-language-server", "stylua", "html-lsp", "css-lsp", "clangd", "prettier", "typescript-language-server", "csharp-language-server", "haskell-language-server", "jdtls", "tailwindcss-language-server", "yaml-language-server", "python-lsp-server", "json-lsp", "lemmin"
  		},
  	},
  },

  {
    "smoka7/hop.nvim",
    config = function()
      require("hop").setup()
    end,
    event = "BufRead",  -- Lazy load on buffer read
  },
}
