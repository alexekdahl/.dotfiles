local mapkey = require("util.keymapper").mapkey
local cmd = require("util.keycmd")

mapkey("<C-J>", cmd.focus_split_down, "n")
mapkey("<C-H>", cmd.focus_split_left, "n")
mapkey("<C-K>", cmd.focus_split_up, "n")
mapkey("<C-L>", cmd.focus_split_right, "n")

mapkey("<leader>sv", cmd.split_vertical, "n")
mapkey("<leader>sh", cmd.split_horizontal, "n")

mapkey("<C-p>", cmd.paste_no_registry, "v")
mapkey("<leader>v", cmd.visual_inner_word, "n")
mapkey("<leader>y", cmd.yank_inner_word, "n")
mapkey("<leader>o", cmd.add_line_below, "n")
mapkey("<leader>s", cmd.save_all, "n")

mapkey("<leader>t", cmd.go_test, "n")

mapkey("<C-b>", cmd.toggle_quickfix, "n")
mapkey("<leader>l", cmd.color_print, "n")
mapkey("<C-s>", cmd.smart_replace, "n")
mapkey("]", vim.diagnostic.get_next, "n")
mapkey("[", vim.diagnostic.get_prev, "n")

vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({ border = "rounded" })
end)

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action)

vim.keymap.set("n", "<leader>k", function()
  vim.diagnostic.open_float({ border = "rounded" })
end)
