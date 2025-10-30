-- return {
-- 	{
-- 		"olimorris/onedarkpro.nvim",
-- 		priority = 1000,
-- 		event = "VimEnter",
-- 		opts = {
-- 			colors = {
-- 				red = "#E06C75",
-- 				green = "#98C379",
-- 				olive_green = "#808000",
-- 				yellow = "#E5C07B",
-- 				dark_yellow = "#D19A66",
-- 				blue = "#61AFEF",
-- 				purple = "#C678DD",
-- 				purple_border = "#5A5F8C",
-- 				orange = "#D19A66",
-- 				cyan = "#56B6C2",
-- 				white = "#ABB2BF",
-- 				black = "#15171F",
-- 			},
-- 			options = {
-- 				transparency = true,
-- 			},
-- 		},
-- 		config = function(_, opts)
-- 			require("onedarkpro").setup(opts)
-- 			vim.cmd.colorscheme("onedark")
-- 		end,
-- 	},
-- }
return {
	"lucasadelino/conifer.nvim",
	priority = 1000,
	event = "VimEnter",
	opts = {
		transparent = true,
		styles = {
			variables = { fg = "#fafafa" },
			Normal = { fg = "#fafafa" },
			Identifier = { fg = "#fafafa" },
		},
	},
	config = function(_, opts)
		require("conifer").setup(opts)
		vim.cmd.colorscheme("conifer")
	end,
}
