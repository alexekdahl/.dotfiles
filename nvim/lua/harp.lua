local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<C-a>", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-y>", function()
	ui.nav_file(1)
end)
vim.keymap.set("n", "<C-u>", function()
	ui.nav_file(2)
end)
