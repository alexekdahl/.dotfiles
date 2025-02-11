local keys = {
	{
		"<leader>:",
		function()
			Snacks.picker.command_history()
		end,
		desc = "Command History",
	},
	{
		"<leader>ff",
		function()
			Snacks.picker.files({
				cmd = "rg",
				exclude = { ".git/", "node_modules/" },
				hidden = true,
				win = {
					list = {
						keys = {
							["<c-Down>"] = "preview_scroll_down",
							["<Up>"] = { "preview_scroll_up", mode = { "i", "n" } },
							["<Left>"] = { "preview_scroll_left", mode = { "i", "n" } },
							["<Right>"] = { "preview_scroll_right", mode = { "i", "n" } },
						},
					},
				},
			})
		end,
		desc = "Find Files",
	},
	{
		"<leader>fl",
		function()
			Snacks.picker.grep()
		end,
		desc = "Grep",
	},
	{
		"<leader>fr",
		function()
			Snacks.picker.lsp_references()
		end,
		nowait = true,
		desc = "References",
	},
	{
		"<leader>fc",
		function()
			Snacks.picker.git_status()
		end,
	},
	{
		"<leader>sw",
		function()
			Snacks.picker.grep_word()
		end,
		desc = "Visual selection or word",
		mode = { "n", "x" },
	},

	{
		"<leader>d",
		function()
			Snacks.picker.diagnostics()
		end,
		desc = "Diagnostics",
	},

	{
		"<leader>fm",
		function()
			Snacks.picker.man()
		end,
		desc = "Man Pages",
	},
	{
		"<leader>sm",
		function()
			Snacks.picker.marks()
		end,
		desc = "Marks",
	},

	{
		"<leader>fq",
		function()
			Snacks.picker.qflist()
		end,
		desc = "Quickfix List",
	},
	{
		"<leader>uC",
		function()
			Snacks.picker.colorschemes()
		end,
		desc = "Colorschemes",
	},

	{
		"gd",
		function()
			Snacks.picker.lsp_definitions()
		end,
		desc = "Goto [D]efinition",
	},
	{
		"gt",
		function()
			Snacks.picker.lsp_type_definitions()
		end,
		desc = "Goto T[y]pe Definition",
	},
	{
		"gt",
		function()
			Snacks.picker.lsp_type_definitions()
		end,
		desc = "Goto T[y]pe Definition",
	},
	{
		"<leader>gl",
		function()
			Snacks.picker.git_log({
				finder = "git_log",
				format = "git_log",
				preview = "git_show",
				confirm = "git_checkout",
				layout = "vertical",
			})
		end,
		desc = "Git Log",
	},
	{
		"<leader>e",
		function()
			Snacks.explorer.open({
				replace_netrw = true,
				hidden = true,
			})
		end,
	},
	{
		"<leader>gh",
		function()
			Snacks.gitbrowse.open()
		end,
		mode = { "n", "v" },
	},
}

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		picker = { enabled = true, layout = { cycle = false } },
		explorer = { enabled = true },
		gitbrowse = { enabled = true },
		indent = {
            enabled = true,
            animate = { enabled = false },
            scope = { enabled = false },
        },
	},
	keys = keys,
}
