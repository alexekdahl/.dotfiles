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

mapkey("<leader>fr", cmd.lsp_find_references, "n")
mapkey("<leader>fc", cmd.telescope_find_changed_files, "n")
mapkey("<leader>ff", cmd.telescope_find_files, "n")
mapkey("<leader>fl", cmd.telescope_live_grep, "n")
mapkey("<leader>d", cmd.telescope_diagnostics, "n")
mapkey("<leader>hf", cmd.telescope_git_history, "n")
mapkey("<leader>t", cmd.go_test, "n")
mapkey("<leader>ghc", cmd.goto_commit, "n")

mapkey("<C-b>", cmd.toggle_quickfix, "n")
mapkey("<leader>l", cmd.color_print, "n")
mapkey("]", vim.diagnostic.goto_next, "n")
mapkey("[", vim.diagnostic.goto_prev, "n")
