local opts = {
	ensure_installed = {
		"efm",
		"bashls",
		"tsserver",
		"pyright",
		"lua_ls",
		"jsonls",
		"gopls",
		"golangci_lint_ls",
	},
	automatic_installation = true,
}

return {
	"williamboman/mason-lspconfig.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
