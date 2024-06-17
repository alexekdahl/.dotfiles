return {
	"glepnir/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		-- keybinds for navigation in lspsaga window
		move_in_saga = { prev = "<C-k>", next = "<C-j>" },
		finder = {
			keys = {
				toggle_or_open = "<CR>",
				quit = "<ESC>",
			},
		},
		-- use enter to open file with definition preview
		definition_action_keys = {
			edit = "<CR>",
			quit = "<ESC>",
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
