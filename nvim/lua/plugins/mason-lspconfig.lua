return {
	"mason-org/mason-lspconfig.nvim",
	event = "BufReadPre",
	dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
	opts = {
		ensure_installed = {
			"efm",
			"pyright",
			"lua_ls",
			"gopls",
			"nim_langserver",
			"just",
		},
		automatic_enable = true,
	},
}
