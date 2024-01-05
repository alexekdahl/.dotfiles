return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		defaults = {
			prompt_prefix = "> ",
			selection_caret = "> ",
			entry_prefix = "  ",
			multi_icon = "<>",
			layout_strategy = "horizontal",
			layout_config = {
				width = 0.95,
				height = 0.85,
				prompt_position = "top",
				horizontal = {
					preview_width = function(_, cols, _)
						if cols > 200 then
							return math.floor(cols * 0.4)
						else
							return math.floor(cols * 0.6)
						end
					end,
				},
				vertical = {
					width = 0.9,
					height = 0.95,
					preview_height = 0.5,
				},
				flex = {
					horizontal = {
						preview_width = 0.9,
					},
				},
			},
			selection_strategy = "reset",
			sorting_strategy = "descending",
			scroll_strategy = "cycle",
			color_devicons = true,
		},

		pickers = {
			find_files = {
				find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
			},
			lsp_implementations = {
				find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
				layout_strategy = "vertical",
				layout_config = {
					prompt_position = "top",
				},
				sorting_strategy = "ascending",
				ignore_filename = false,
			},
			live_grep = {
				path_display = { "shorten" },
				find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
				layout_strategy = "vertical",
			},
			grep_string = {
				path_display = { "shorten" },
				find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
				layout_strategy = "vertical",
			},
		},
	},
}
