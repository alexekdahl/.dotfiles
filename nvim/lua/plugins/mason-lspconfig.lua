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
			"nimls",
		},
		automatic_installation = true,
	},
}
