local icons = require("config.icons").icons
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		},
	},
	opts = {
		defaults = {
			prompt_prefix = icons.symbols.chevron_right .. " ",
			selection_caret = icons.symbols.chevron_right .. " ",
			entry_prefix = "  ",
			multi_icon = icons.symbols.star .. " ",
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
				layout_config = { preview_width = 0.6 },
			},
			lsp_references = {
				find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
				layout_strategy = "vertical",
				sorting_strategy = "ascending",
				ignore_filename = false,
			},
			live_grep = {
				find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
				layout_config = { preview_width = 0.6 },
			},
			grep_string = {
				path_display = { "shorten" },
				find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
				layout_strategy = "vertical",
			},
		},
	},
	config = function(_, opts)
		require("telescope").setup(opts)
		require("telescope").load_extension("fzf")
	end,
}
