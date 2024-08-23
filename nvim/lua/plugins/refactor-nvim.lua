return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
	keys = {
		{ "<leader>re", "<cmd>lua require('refactoring').refactor('Extract Function')<CR>", mode = "x" },
	},
}
