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
			"goimports",
			"hadolint",
			"fixjson",
			"eslint_d",
			"prettierd",
		},
	},
	dependencies = {
		"williamboman/mason.nvim",
	},
}
