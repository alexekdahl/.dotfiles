local theme = require("onedarkpro")
-- vim.o.background = 'dark'
vim.cmd.colorscheme("onedark")
theme.setup({
	options = {
		cursorline = false,
		transparency = true, -- Use a transparent background?
		window_unfocussed_color = false, -- When the window is out of focus, change the normal background?
	},
})
theme.load()
