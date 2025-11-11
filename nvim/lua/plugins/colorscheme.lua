return {
	"alexekdahl/tachyon.nvim",
	priority = 1000,
	event = "VimEnter",
	opts = {
		styles = {
			variables = { fg = "#fafafa" },
			Normal = { fg = "#fafafa" },
			Identifier = { fg = "#fafafa" },
		},
	},
	config = function(_, opts)
		require("tachyon").setup(opts)
		vim.cmd.colorscheme("tachyon")
	end,
}
