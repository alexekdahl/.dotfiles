local mapkey = require("util.keymapper").mapkey

vim.keymap.set("n", "qw", function()
	vim.cmd("silent! normal mpea'<Esc>bi'<Esc>`pl")
end)
vim.keymap.set("n", "wq", function()
	vim.cmd("silent! normal mpeld bhd `ph")
end)
vim.keymap.set("v", "<C-p>", '"_dP')
vim.keymap.set("n", "<leader>o", "o<Esc>")
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")

vim.keymap.set("n", "<leader>v", "viw")

-- Show Full File-Path
mapkey("<leader>pa", "echo expand('%:p')", "n") -- Show Full File Path

mapkey("<leader>sv", "vsplit", "n") -- Split Vertically
mapkey("<leader>sh", "split", "n") -- Split Horizontally
-- mapkey("<leader>v", "viw", "n") -- Split Horizontally
-- mapkey("<leader>y", "yiw", "n") -- Split Horizontally

mapkey("<leader>e", "NvimTreeToggle", "n")
mapkey("<leader>j", "FloatermToggle", "n")
vim.keymap.set("t", "<leader>j", '<C-"><C-n><cmd>FloatermToggle<CR>')
vim.keymap.set("t", "<ESC>", '<C-"><C-n>')
vim.keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics<CR>")

mapkey("<leader>s", ":wa!", "n") -- Save
mapkey("<leader>ff", "Telescope find_files", "n")
mapkey("<leader>fl", "Telescope live_grep", "n")
mapkey("<leader>fr", "Telescope lsp_references", "n")
