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
---@diagnostic disable: need-check-nil
local function relative_path()
	local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")
	local root = handle:read("*a")
	handle:close()
	root = string.gsub(root, "[\r\n]+$", "")
	local filepath = vim.fn.expand("%:p")
	local relativepath = string.gsub(filepath, "^" .. root .. "/", "")
	print(relativepath)
end
vim.keymap.set("n", "<leader>pa", relative_path)

mapkey("<leader>sv", "vsplit", "n") -- Split Vertically
mapkey("<leader>sh", "split", "n") -- Split Horizontally

vim.keymap.set(
	"n",
	"<leader>fc",
	"<cmd>lua require('telescope.builtin').find_files({ find_command = {'git', '--no-pager', 'diff', '--name-only' }})<CR>"
)

mapkey("<leader>ff", "Telescope find_files", "n")
mapkey("<leader>fl", "Telescope live_grep", "n")
mapkey("<leader>fr", "Telescope lsp_references", "n")
vim.keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics<CR>")
