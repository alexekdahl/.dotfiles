return {
	"alexekdahl/git-worktree.nvim",
	branch = "alexekdahl/feat/base-dir",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("git-worktree").setup({
			base_directory = "../",
		})
		require("telescope").load_extension("git_worktree")
	end,
	keys = {
		{ "<leader>gf", "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>" },
		{ "<leader>gco", "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>" },
	},
}
