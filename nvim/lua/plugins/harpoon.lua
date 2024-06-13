return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({
			settings = {
				save_on_toggle = true,
			},
		})
	end,
	keys = {
		{
			"<C-a>",
			function()
				require("harpoon"):list():add()
			end,
		},
		{
			"<C-e>",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end,
		},
		{
			"<C-y>",
			function()
				require("harpoon"):list():select(1)
			end,
		},
		{
			"<C-u>",
			function()
				require("harpoon"):list():select(1)
			end,
		},
	},
}
