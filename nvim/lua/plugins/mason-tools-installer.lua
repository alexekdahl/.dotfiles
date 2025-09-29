return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = {
		"williamboman/mason.nvim",
	},
	opts = {
		auto_update = true,
		debounce_hours = 24,
		ensure_installed = {
			"luacheck",
			"stylua",
			"luacheck",
			"goimports",
			"golines",
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
