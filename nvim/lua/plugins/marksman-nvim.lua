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
		max_marks = 4,
		silent = true,
		minimal = true,
		disable_default_keys = true,
		debounce_ms = 100,
		highlights = {
			ProjectMarksTitle = { fg = "#FFE591" },
			ProjectMarksNumber = { fg = "#525252" },
			ProjectMarksName = { fg = "#85B884" },
			ProjectMarksFile = { fg = "#ABBAB5" },
			ProjectMarksLine = { fg = "#D19B6E" },
			ProjectMarksText = { fg = "#727272" },
			ProjectMarksHelp = { fg = "#525252" },
			ProjectMarksBorder = { fg = "#525252" },
			ProjectMarksSearch = { fg = "#FFE591" },
		},
	},
}
