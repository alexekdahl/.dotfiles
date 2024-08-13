local icons = require("config.icons").icons
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		disable_netrw = true,
		hijack_netrw = true,
		hijack_cursor = true,
		hijack_unnamed_buffer_when_opening = false,
		sync_root_with_cwd = true,
		update_focused_file = {
			enable = true,
			update_root = false,
		},
		view = {
			adaptive_size = true,
			side = "left",
			width = 40,
			preserve_window_proportions = true,
		},
		git = {
			enable = true,
			ignore = true,
		},
		filesystem_watchers = {
			enable = true,
		},
		actions = {
			open_file = {
				resize_window = true,
			},
		},
		renderer = {
			root_folder_label = true,
			highlight_git = true,
			highlight_opened_files = "none",
			indent_markers = {
				enable = false,
			},
			icons = {
				show = {
					file = true,
					folder = true,
					folder_arrow = true,
					git = true,
				},
				glyphs = {
					default = icons.folder.file,
					symlink = icons.folder.file_symlink,
					folder = {
						default = icons.folder.folder,
						empty = icons.folder.empty_folder,
						empty_open = icons.folder.empty_folder_open,
						open = icons.folder.open_folder,
						symlink = icons.folder.folder_symlink,
						symlink_open = icons.folder.folder_symlink_open,
						arrow_open = icons.symbols.chevron_down,
						arrow_closed = icons.symbols.chevron_right,
					},
					git = {
						unstaged = icons.symbols.cross,
						staged = icons.symbols.check,
						unmerged = icons.symbols.git_branch,
						renamed = icons.symbols.arrow_right,
						untracked = icons.symbols.star,
						deleted = icons.folder.deleted,
						ignored = icons.symbols.hollow,
					},
				},
			},
		},
	},
	cmd = "NvimTreeToggle",
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<cr>" },
	},
}
