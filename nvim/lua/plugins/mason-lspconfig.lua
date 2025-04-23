return {
	"williamboman/mason-lspconfig.nvim",
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
	opts = {
		ensure_installed = {
			"efm",
			"pyright",
			"lua_ls",
			"gopls",
			"golangci_lint_ls",
			"nim_langserver",
		},
		automatic_installation = true,
	},
}
