return {
	"olimorris/onedarkpro.nvim",
	priority = 1000,
	opts = {
		options = {
			cursorline = false,
			transparency = true,
			window_unfocussed_color = false,
		},
	},
	config = function(_, opt)
		vim.cmd.colorscheme("onedark")
		local theme = require("onedarkpro")
		theme.setup(opt)
		theme.load()
	end,
}
