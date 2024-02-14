local config = function()
	require("nvim-treesitter.configs").setup({
		build = ":TSUpdate",
		auto_install = true,
		ensure_installed = {
			"markdown",
			"json",
			"javascript",
			"typescript",
			"yaml",
			"html",
			"bash",
			"lua",
			"dockerfile",
			"gitignore",
			"python",
			"go",
			"gomod",
		},
		event = { "BufReadPre", "BufNewFile" },
		indent = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		autopairs = {
			enable = true,
		},
		rainbow = {
			enable = true,
		},
		refactor = {
			highlight_definitions = {
				enable = true,
			},
			highlight_current_scope = {
				enable = false,
			},
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<c-space>",
				node_incremental = "<c-space>",
				scope_incremental = "<c-s>",
				node_decremental = "<M-space>",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>ss"] = "@parameter.inner",
				},
			},
		},
		playground = { enable = false },
	})
end

return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = config,
}
