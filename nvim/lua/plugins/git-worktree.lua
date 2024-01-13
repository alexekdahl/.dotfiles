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
}
