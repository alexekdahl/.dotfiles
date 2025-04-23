return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = {
		"williamboman/mason.nvim",
	},
	opts = {
		auto_update = true,
		debounce_hours = 24,
		ensure_installed = {
			-- "black",
			-- "flake8",
			"luacheck",
			"stylua",
			"luacheck",
			"goimports",
			"golangci-lint",
		},
	},
	cmd = {
		"MasonToolsInstall",
		"MasonToolsInstallSync",
		"MasonToolsUpdate",
		"MasonToolsUpdateSync",
		"MasonToolsClean",
	},
}
