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
			"jsonls",
			"gopls",
			"golangci_lint_ls",
		},
		automatic_installation = true,
	},
}
