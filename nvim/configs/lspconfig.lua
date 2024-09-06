-- EXAMPLE 
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "angularls", "csharp_ls", "cssls", "clangd", "dockerls", "gitlab_ci_ls", "hls", "html", "jdtls", "jsonls", "gopls", "pylsp", "rust_analyzer", "tailwindcss", "yamlls" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- lspconfig.tsserver.setup {
--   on_attach = function(client, bufnr)
--     -- Disable tsserver formatting in favor of eslint
--     client.server_capabilities.documentFormattingProvider = false
--     on_attach(client, bufnr)
--   end,
--   on_init = on_init,
--   capabilities = capabilities,
--   filetypes = { "typescript", "typescriptreact" },
--   cmd = { "typescript-language-server", "--stdio" },
-- }

lspconfig.html.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "html", "typescriptreact", "javascriptreact" },
  cmd = { "vscode-html-language-server", "--stdio" },
}

lspconfig.csharp_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "cs" },
  cmd = { "csharp-ls" },
}

lspconfig.hls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "haskell", "lhaskell", "hs" },
  cmd = { "haskell-language-server-wrapper", "--lsp" },
}
