local icons = require("config.icons").icons
return {
	"mason-org/mason.nvim",
	cmd = "Mason",
	opts = {
		ui = {
			icons = {
				package_installed = icons.symbols.check,
				package_pending = icons.symbols.arrow_right,
				package_uninstalled = icons.symbols.cross,
			},
		},
	},
}
