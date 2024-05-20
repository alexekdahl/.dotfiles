return {
	"olimorris/onedarkpro.nvim",
	priority = 1000, -- Ensure it loads first
	config = function()
		require("onedarkpro").setup({
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
		})
		vim.cmd.colorscheme("onedark")
	end,
}
