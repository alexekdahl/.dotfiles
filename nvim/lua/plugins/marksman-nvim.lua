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
	},
}
