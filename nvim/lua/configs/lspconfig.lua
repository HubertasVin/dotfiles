-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
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

-- lsps with default config
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
		return lspconfig.util.root_pattern(".git")(fname) -- Uses the .git directory as the root
			or lspconfig.util.path.dirname(fname) -- Falls back to the file's directory
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
