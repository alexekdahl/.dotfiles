return {
	"alexekdahl/marksman.nvim",
	keys = {
		{
			"<C-a>",
			function()
				require("marksman").add_mark()
			end,
			desc = "Add mark",
		},
		{
			"<C-e>",
			function()
				require("marksman").show_marks()
			end,
			desc = "Show marks",
		},
		{
			"<M-y>",
			function()
				require("marksman").goto_mark(1)
			end,
			desc = "Go to mark 1",
		},
		{
			"<M-u>",
			function()
				require("marksman").goto_mark(2)
			end,
			desc = "Go to mark 2",
		},
		{
			"<M-i>",
			function()
				require("marksman").goto_mark(3)
			end,
			desc = "Go to mark 3",
		},
		{
			"<M-o>",
			function()
				require("marksman").goto_mark(4)
			end,
			desc = "Go to mark 4",
		},
	},
	opts = {
		search_in_ui = false,
		sort_marks = false,
		max_marks = 5,
		silent = true,
		minimal = true,
		enable_descriptions = false,
		undo_levels = 1,
		highlights = {
			ProjectMarksTitle = { fg = "#60B197" },
			ProjectMarksNumber = { fg = "#AA749F" },
			ProjectMarksName = { fg = "#85B884" },
			ProjectMarksFile = { fg = "#ABBAB5" },
			ProjectMarksLine = { fg = "#D19B6E" },
			ProjectMarksText = { fg = "#727272" },
			ProjectMarksHelp = { fg = "#60B197" },
			ProjectMarksBorder = { fg = "#525252" },
			ProjectMarksSearch = { fg = "#FFE591" },
		},
	},
}
