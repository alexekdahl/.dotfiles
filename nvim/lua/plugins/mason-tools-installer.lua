return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		auto_update = false,
		debounce_hours = 24,
		ensure_installed = {
			"luacheck",
			"stylua",
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
