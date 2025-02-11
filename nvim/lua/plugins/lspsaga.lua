return {
	"glepnir/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = "LspAttach",
	opts = {
		beacon = {
			enable = false,
		},
		-- keybinds for navigation in lspsaga window
		move_in_saga = { prev = "<C-k>", next = "<C-j>" },
		finder = {
			keys = {
				toggle_or_open = "<CR>",
				quit = { "q", "<ESC>" },
			},
		},
		-- use enter to open file with definition preview
		definition_action_keys = {
			edit = "<CR>",
			quit = "<ESC>",
		},
		diagnostic = {
			show_code_action = false,
			keys = {
				quit = { "q", "<ESC>" },
			},
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
	keys = {
		{ "gD", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek definition" },
		{ "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover doc" },
		{
			"<leader>k",
			"<cmd>Lspsaga show_cursor_diagnostics<CR>",
			desc = "Show cursor diagnostic",
		},
		{
			"<leader>a",
			"<cmd>Lspsaga code_action<CR>",
			desc = "Code action",
		},
		{
			"<leader>p",
			"<cmd>Lspsaga outline<CR>",
			desc = "Show outline",
		},
		{
			"<leader>lf",
			"<cmd>Lspsaga finder tyd+ref+imp+def<CR>",
			desc = "Show finder",
		},
	},
}
