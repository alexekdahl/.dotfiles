return {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		use_default_keymaps = false,
		max_join_length = 260,
	},
	keys = {
		{ "<leader>m", "<cmd>TSJToggle<cr>" },
	},
}
