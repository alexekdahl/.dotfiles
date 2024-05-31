return {
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000,
		opts = {
			colors = {
				red = "#E06C75",
				green = "#98C379",
				olive_green = "#808000",
				yellow = "#E5C07B",
				dark_yellow = "#D19A66",
				blue = "#61AFEF",
				purple = "#C678DD",
				orange = "#D19A66",
				cyan = "#56B6C2",
				white = "#ABB2BF",
				black = "#15171F",
			},
			highlights = {
				["TelescopeBorder"] = { fg = "#808000" },
				["TelescopeResultsTitle"] = { fg = "${green}" },
				["TelescopePromptTitle"] = { fg = "${green}" },
				["TelescopePreviewTitle"] = { fg = "${green}" },
				["NoiceCmdlinePopupBorder"] = { fg = "#808000" },
				["NoiceCmdlinePopupTitle"] = { fg = "${green}" },
			},
			options = {
				transparency = true,
			},
		},
		config = function(_, opts)
			require("onedarkpro").setup(opts)
			-- vim.cmd.colorscheme("onedark")
		end,
	},
	{
		"asilvam133/rose-pine.nvim",
		name = "rose-pine",
		opts = {
			variant = "moon",
			enable = {
				terminal = true,
				legacy_highlights = false,
				migrations = false,
			},
			styles = {
				bold = false,
				italic = false,
				transparency = true,
			},
		},
		config = function(_, opts)
			require("rose-pine").setup(opts)
			-- vim.cmd("colorscheme rose-pine")
		end,
	},
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_transparent_background = 1
			vim.g.gruvbox_material_background = "hard"
			vim.g.ruvbox_material_lightline_disable_bold = 1
			vim.g.gruvbox_material_better_performance = 1
			vim.g.gruvbox_material_foreground = "original"
			vim.g.gruvbox_material_current_word = "grey background"
			vim.cmd("colorscheme gruvbox-material")
		end,
	},
}
