return {
	"mason-org/mason-lspconfig.nvim",
	ft = { "go", "lua", "python", "rust", "nim", "just" },
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	opts = {
		ensure_installed = {
			"efm",
			"pyright",
			"lua_ls",
			"gopls",
			"nim_langserver",
			"just",
			"rust_analyzer",
		},
		automatic_enable = true,
	},
}
