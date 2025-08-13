-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local servers = {
	"angularls",
	"ansiblels",
	"bashls",
	"clangd",
	"csharp_ls",
	"cssls",
	"dockerls",
	"docker_compose_language_service",
	"html",
	"helm_ls",
  "gopls",
	"jdtls",
	"jsonls",
	"lemminx",
	"lua_ls",
	"sqlls",
	"pylsp",
	"rust_analyzer",
	"tailwindcss",
	"taplo",
	"ts_ls",
	"yamlls",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		on_init = on_init,
		capabilities = capabilities,
	})
end

lspconfig.bashls.setup({
  filetypes = { "sh", "zsh" },
})

lspconfig.sqlls.setup({
	on_attach = on_attach,
	on_init = on_init,
	capabilities = capabilities,
	root_dir = function(fname)
		return lspconfig.util.root_pattern(".git")(fname)
			or lspconfig.util.path.dirname(fname)
	end,
})

lspconfig.html.setup({
	on_attach = on_attach,
	on_init = on_init,
	capabilities = capabilities,
	filetypes = { "html", "typescriptreact", "javascriptreact" },
	cmd = { "vscode-html-language-server", "--stdio" },
})

lspconfig.pylsp.setup({
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					maxLineLength = 120,
				},
			},
		},
	},
})

lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			assist = {
				importGranularity = "module",
				importPrefix = "by_self",
			},
			cargo = {
				allFeatures = true,
			},
			checkOnSave = {
				command = "clippy",
			},
		},
	},
})

-- Configuring which files should be matched as helm type
lspconfig.helm_ls.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  filetypes = { "helm" },
  root_dir = function(fname)
    return util.root_pattern("Chart.yaml")(fname) or util.find_git_ancestor(fname)
  end,
})

lspconfig.yamlls.setup({
  on_attach = function(client, bufnr)
    if vim.bo[bufnr].filetype == "helm" then
      client.stop()
      return
    end
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  filetypes = { "yaml", "yml" },
})

-- Global default border for all LSP float windows
local orig_open_floating = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_open_floating(contents, syntax, opts, ...)
end

vim.diagnostic.config({
  float = { border = "rounded" },
})
