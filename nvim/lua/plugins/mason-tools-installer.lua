return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		auto_update = true,
		debounce_hours = 24,
		ensure_installed = {
			"black",
			"flake8",
			"luacheck",
			"stylua",
			"markdownlint",
			"mdformat",
			"gofmt",
			"goimports",
		},
	},
	dependencies = {
		"williamboman/mason.nvim",
	},
}
