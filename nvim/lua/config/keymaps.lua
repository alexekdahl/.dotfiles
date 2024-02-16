local mapkey = require("util.keymapper").mapkey

vim.keymap.set("v", "<C-p>", '"_dP')
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")

vim.keymap.set("n", "<leader>v", "viw")
vim.keymap.set("n", "<leader>y", "yiw")
vim.keymap.set("n", "<leader>o", "o<Esc>")
vim.keymap.set("n", "<leader>if", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

mapkey("<leader>sv", "vsplit", "n") -- Split Vertically
mapkey("<leader>sh", "split", "n") -- Split Horizontally
mapkey("<leader>s", "wa!", "n")

mapkey(
	"<leader>fc",
	"lua require('telescope.builtin').find_files({ find_command = {'git', '--no-pager', 'diff', '--name-only' }})",
	"n"
)
mapkey("<leader>ff", "Telescope find_files", "n")
mapkey("<leader>fl", "Telescope live_grep", "n")
mapkey("<leader>fr", "Telescope lsp_references", "n")
mapkey("<leader>d", "Telescope diagnostics", "n")
