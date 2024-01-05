return {
	"glepnir/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	lazy = false,
	opts = {
		-- keybinds for navigation in lspsaga window
		move_in_saga = { prev = "<C-k>", next = "<C-j>" },
		-- use enter to open file with finder
		finder_action_keys = {
			open = "<CR>",
		},
		-- use enter to open file with definition preview
		definition_action_keys = {
			edit = "<CR>",
		},
		diagnostic = {
			show_code_action = true,
		},
		lightbulb = {
			enable = false,
		},
		code_action = {
			show_server_name = true,
			-- extend_gitsigns = true,
			keys = {
				quit = "<ESC>",
				exec = "<CR>",
			},
		},
	},
}
