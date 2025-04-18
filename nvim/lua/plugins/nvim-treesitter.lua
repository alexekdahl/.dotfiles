return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
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
				"markdown_inline",
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
					lookahead = true,
					keymaps = {
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
					set_jumps = true,
				},
			},
			playground = { enable = false },
		})
	end,
}
