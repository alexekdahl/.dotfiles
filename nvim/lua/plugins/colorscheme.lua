return {
	"alexekdahl/tachyon.nvim",
	priority = 1000,
	opts = {},
	config = function(_, opts)
		require("tachyon").setup(opts)
		vim.cmd.colorscheme("tachyon")
	end,
}
