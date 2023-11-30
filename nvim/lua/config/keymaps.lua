local mapkey = require("util.keymapper").mapkey

vim.keymap.set("n", "qw", function()
	vim.cmd("silent! normal mpea'<Esc>bi'<Esc>`pl")
end)
vim.keymap.set("n", "wq", function()
	vim.cmd("silent! normal mpeld bhd `ph")
end)
vim.keymap.set("v", "<C-p>", '"_dP')
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")

vim.keymap.set("n", "<leader>v", "viw")
vim.keymap.set("n", "<leader>y", "yiw")
vim.keymap.set("n", "<leader>s", "<cmd>wa!<CR>")
vim.keymap.set("n", "<leader>o", "o<Esc>")

-- Show Full File-Path
mapkey("<leader>pa", "echo expand('%:p')", "n") -- Show Full File Path

mapkey("<leader>sv", "vsplit", "n") -- Split Vertically
mapkey("<leader>sh", "split", "n") -- Split Horizontally

mapkey("<leader>e", "NvimTreeToggle", "n")
mapkey("<leader>j", "FloatermToggle", "n")
vim.keymap.set("t", "<leader>j", "<cmd>FloatermToggle<CR>")

mapkey("<leader>ff", "Telescope find_files", "n")
mapkey("<leader>fl", "Telescope live_grep", "n")
mapkey("<leader>fr", "Telescope lsp_references", "n")
vim.keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics<CR>")

-- mapkey("<leader>v", "viw", "n") -- Split Horizontally
-- mapkey("<leader>y", "yiw", "n") -- Split Horizontally
-- mapkey("<leader>s", "wa!", "n") -- Save
-- vim.keymap.set("t", "<ESC>", '<C-"><C-n>')
