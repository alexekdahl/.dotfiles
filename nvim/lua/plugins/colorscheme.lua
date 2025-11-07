return {
	"lucasadelino/conifer.nvim",
	priority = 1000,
	event = "VimEnter",
	opts = {
		transparent = true,
		styles = {
			variables = { fg = "#fafafa" },
			Normal = { fg = "#fafafa" },
			Identifier = { fg = "#fafafa" },
		},
	},
	config = function(_, opts)
		require("conifer").setup(opts)
		vim.cmd.colorscheme("conifer")
	end,
}
