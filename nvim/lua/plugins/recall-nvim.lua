return {
	"fnune/recall.nvim",
	version = "*",
	opts = {
		sign = "",
		sign_highlight = "NONE",
		telescope = {
			autoload = true,
			mappings = {
				unmark_selected_entry = {
					normal = "d",
					insert = "",
				},
			},
		},
	},
	config = function(_, opts)
		local recall = require("recall")

		recall.setup(opts)

		vim.keymap.set("n", "<C-a>", recall.toggle, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-u>", recall.goto_next, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-y>", recall.goto_prev, { noremap = true, silent = true })
		-- vim.keymap.set("n", "<leader>mc", recall.clear, { noremap = true, silent = true })
		vim.keymap.set("n", "<C-e>", ":Telescope recall<CR>", { noremap = true, silent = true })
	end,
}
