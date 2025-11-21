local cmd = require("commands")

-- convenience defaults
local opts = { noremap = true, silent = true }

-- window movement
vim.keymap.set("n", "<C-J>", cmd.focus_split_down, { desc = "[F]ocus split [D]own", unpack(opts) })
vim.keymap.set("n", "<C-H>", cmd.focus_split_left, { desc = "[F]ocus split [L]eft", unpack(opts) })
vim.keymap.set("n", "<C-K>", cmd.focus_split_up, { desc = "[F]ocus split [U]p", unpack(opts) })
vim.keymap.set("n", "<C-L>", cmd.focus_split_right, { desc = "[F]ocus split [R]ight", unpack(opts) })

-- splits
vim.keymap.set("n", "<leader>sv", cmd.split_vertical, { desc = "[S]plit [V]ertical", unpack(opts) })
vim.keymap.set("n", "<leader>sh", cmd.split_horizontal, { desc = "[S]plit [H]orizontal", unpack(opts) })

-- editing helpers
vim.keymap.set("v", "<C-p>", cmd.paste_no_registry, { desc = "[P]aste no registry", unpack(opts) })
vim.keymap.set("n", "<leader>v", cmd.visual_inner_word, { desc = "Select inner [W]ord", unpack(opts) })
vim.keymap.set("n", "<leader>y", cmd.yank_inner_word, { desc = "[Y]ank inner word", unpack(opts) })
vim.keymap.set("n", "<leader>o", cmd.add_line_below, { desc = "Add line [B]elow", unpack(opts) })
vim.keymap.set("n", "<leader>s", cmd.save_all, { desc = "[S]ave all", unpack(opts) })

-- test runner
vim.keymap.set("n", "<leader>t", cmd.go_test, { desc = "[T]est file", unpack(opts) })

-- misc
vim.keymap.set("n", "<C-b>", cmd.toggle_quickfix, { desc = "Toggle [Q]uickfix", unpack(opts) })
vim.keymap.set("n", "<leader>l", cmd.color_print, { desc = "[L]og color print", unpack(opts) })
vim.keymap.set("n", "<C-s>", cmd.smart_replace, { desc = "[S]mart replace", unpack(opts) })

-- diagnostics
vim.keymap.set("n", "]", vim.diagnostic.get_next, { desc = "Next diagnostic", unpack(opts) })
vim.keymap.set("n", "[", vim.diagnostic.get_prev, { desc = "Prev diagnostic", unpack(opts) })

vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({ border = "rounded" })
end, { desc = "LSP Hover" })

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "[R]ename symbol" })
vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code [A]ction" })

vim.keymap.set("n", "<leader>k", function()
  vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Diagnostic hover" })
