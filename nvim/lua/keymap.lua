-- Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local cmd = require("commands")

----------------------------------------------------------------------
-- Window Navigation
----------------------------------------------------------------------

map("n", "<C-J>", cmd.focus_split_down, { desc = "Focus split Down" })
map("n", "<C-H>", cmd.focus_split_left, { desc = "Focus split Left" })
map("n", "<C-K>", cmd.focus_split_up, { desc = "Focus split Up" })
map("n", "<C-L>", cmd.focus_split_right, { desc = "Focus split Right" })

map("n", "<leader>sv", cmd.split_vertical, { desc = "Split Vertical" })
map("n", "<leader>sh", cmd.split_horizontal, { desc = "Split Horizontal" })

----------------------------------------------------------------------
-- Editing Helpers
----------------------------------------------------------------------

map("v", "<C-p>", cmd.paste_no_registry, { desc = "Paste no registry" })
map("n", "<leader>v", cmd.visual_inner_word, { desc = "Select inner Word" })
map("n", "<leader>y", cmd.yank_inner_word, { desc = "Yank inner Word" })
map("n", "<leader>o", cmd.add_line_below, { desc = "Add line Below" })
map("n", "<leader>s", cmd.save_all, { desc = "Save All" })
map("n", "<leader>t", cmd.go_test, { desc = "Go Test" })
map("n", "<C-b>", cmd.toggle_quickfix, { desc = "Toggle Quickfix" })
map("n", "<leader>l", cmd.color_print, { desc = "Color print" })
map("n", "<C-s>", cmd.smart_replace, { desc = "Smart replace" })
map("n", "<leader>m", cmd.split_join_toggle, { desc = "Toggle split/join" })

----------------------------------------------------------------------
-- Diagnostics + LSP
----------------------------------------------------------------------

map("n", "]", vim.diagnostic.get_next, { desc = "Next Diagnostic" })
map("n", "[", vim.diagnostic.get_prev, { desc = "Prev Diagnostic" })

map("n", "K", function()
  vim.lsp.buf.hover({ border = "rounded" })
end, { desc = "LSP Hover" })

map("n", "<leader>r", vim.lsp.buf.rename, { desc = "LSP Rename" })
map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("n", "<leader>k", function()
  vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Diagnostic Float" })

----------------------------------------------------------------------
-- Snacks Picker Integrations
----------------------------------------------------------------------
map("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
map("n", "<leader>fl", function() Snacks.picker.grep() end, { desc = "Grep" })
map("n", "<leader>fr", function() Snacks.picker.lsp_references() end, { desc = "References", nowait = true })
map("n", "<leader>fc", function() Snacks.picker.git_status() end, { desc = "Git Status" })
map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Grep Word / Selection" })
map("n", "<leader>d", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
map("n", "<leader>fm", function() Snacks.picker.man() end, { desc = "Man Pages" })
map("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
map("n", "<leader>fq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
map("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto [D]efinition" })
map("n", "gt", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
map("n", "<leader>fs", function() Snacks.picker.resume() end, { desc = "Resume Last Picker" })
map("n", "<leader>u", function() Snacks.picker.undo() end, { desc = "Undo History" })

map("n", "<leader>ff", function()
  Snacks.picker.files({
    cmd = "rg",
    exclude = { ".git/", "node_modules/" },
    hidden = true,
    win = {
      list = {
        keys = {
          ["<C-Down>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["<Up>"]     = { "preview_scroll_up", mode = { "i", "n" } },
          ["<Left>"]   = { "preview_scroll_left", mode = { "i", "n" } },
          ["<Right>"]  = { "preview_scroll_right", mode = { "i", "n" } },
        },
      },
    },
  })
end, { desc = "Find Files" })

map("n", "<leader>gl", function()
  Snacks.picker.git_log_file({
    finder = "git_log",
    layout = "vertical",
    format = "git_log",
    preview = "git_show",
    confirm = "git_checkout",
  })
end, { desc = "Git Log (File)" })

map("n", "<leader>e", function()
  Snacks.explorer.open({ replace_netrw = true, hidden = true })
end, { desc = "Explorer" })

map({ "n", "v" }, "<leader>gh", function()
  Snacks.gitbrowse.open({ open = function(url) vim.fn.setreg("+", url) end })
end, { desc = "Git Browse (copy URL)" })
