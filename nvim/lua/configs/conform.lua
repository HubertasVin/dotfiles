local options = {
	formatters_by_ft = {
		angular = { "prettier" },
		bash = { "beautysh" },
		zsh = { "beautysh" },
		sh = { "beautysh" },
		javascript = { "prettier" },
		json = { "prettier" },
		jsx = { "prettier" },
		lua = { "stylua" },
		css = { "prettier" },
		scss = { "prettier" },
		html = { "prettier" },
		rust = { "rust_analyzer" },
		typescript = { "prettier" },
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 200,
		lsp_fallback = true,
	},
}

require("conform").setup(options)
