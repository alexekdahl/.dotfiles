return {
	"williamboman/mason-lspconfig.nvim",
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
	opts = {
		ensure_installed = {
			"efm",
			"tsserver",
			"pyright",
			"lua_ls",
			"gopls",
			"golangci_lint_ls",
			"nimlangserver",
		},
		automatic_installation = true,
	},
}
