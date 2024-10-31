return {
	{
		enabled = true,
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
				["TelescopeBorder"] = { fg = "${olive_green}" },
				["TelescopeResultsTitle"] = { fg = "${green}" },
				["TelescopePromptTitle"] = { fg = "${green}" },
				["TelescopePreviewTitle"] = { fg = "${green}" },
				["NoiceCmdlinePopupBorder"] = { fg = "${olive_green}" },
				["NoiceCmdlinePopupTitle"] = { fg = "${green}" },
			},
			options = {
				transparency = true,
			},
		},
		config = function(_, opts)
			require("onedarkpro").setup(opts)
			vim.cmd.colorscheme("onedark")
		end,
	},
	{
		"rose-pine/neovim",
		enabled = false,
		priority = 1000,
		opts = {
			styles = {
				bold = false,
				italic = false,
				transparency = true,
			},
		},
		config = function(_, opts)
			require("rose-pine").setup(opts)
			vim.cmd("colorscheme rose-pine-moon")
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		enabled = false,
		priority = 1000,
		opts = {
			options = {
				colorblind = {
					enable = false,
				},
			},
		},
		config = function(_, opts)
			require("nightfox").setup(opts)
			vim.cmd("colorscheme nightfox")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		enabled = false,
		priority = 1000,
		opts = {
			compile = true,
			undercurl = false,
			commentStyle = {
				italic = false,
			},
			keywordStyle = {
				italic = false,
			},
			transparent = true,
		},
		config = function(_, opts)
			require("kanagawa").setup(opts)
			vim.cmd("colorscheme kanagawa")
		end,
	},
}
