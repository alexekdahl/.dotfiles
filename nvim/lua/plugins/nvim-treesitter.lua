local config = function()
	require("nvim-treesitter.configs").setup({
		build = ":TSUpdate",
		auto_install = true,
		ensure_installed = {
			"markdown",
			"markdown_inline",
			"json",
			"javascript",
			"typescript",
			"yaml",
			"html",
			"css",
			"bash",
			"lua",
			"dockerfile",
			"gitignore",
			"python",
			"go",
			"gomod",
			"gowork",
			"vim",
			"vimdoc",
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
			additional_vim_regex_highlighting = true,
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
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
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
		"nvim-treesitter/playground",
	},
	config = config,
}
