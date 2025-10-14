return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = { "<C-a>", "<C-e>", "<M-y>", "<M-u>", "<M-i>", "<M-o>" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()
		local list = function()
			return harpoon:list()
		end

		local keymap = vim.keymap.set
		local opts = { noremap = true, silent = true, desc = "Harpoon" }

		keymap("n", "<C-a>", function()
			list():add()
		end, opts)
		keymap("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(list())
		end, opts)

		--  (Alt + y/u/i/o)
		for i, key in ipairs({ "y", "u", "i", "o" }) do
			keymap("n", "<M-" .. key .. ">", function()
				list():select(i)
			end, vim.tbl_extend("force", opts, { desc = "Harpoon select " .. i }))
		end
	end,
}
