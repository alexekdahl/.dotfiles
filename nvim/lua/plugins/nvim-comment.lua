return {
	"terrortylor/nvim-comment",
	config = function()
		require("nvim_comment").setup({ comment_empty = false })
	end,
	keys = {
		{ "gcc", "<cmd>CommentToggle<cr>" },
		{ "gc", "<cmd>CommentToggle<cr>", mode = "v" },
	},
}
