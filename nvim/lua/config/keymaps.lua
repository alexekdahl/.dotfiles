local mapkey = require("util.keymapper").mapkey
local cmd = require("util.key_cmd")

mapkey("<C-p>", cmd.delete_and_paste_no_registry, "v")
mapkey("<C-J>", cmd.move_window_down, "n")
mapkey("<C-H>", cmd.move_window_left, "n")
mapkey("<C-K>", cmd.move_window_up, "n")
mapkey("<C-L>", cmd.move_window_right, "n")

mapkey("<leader>v", cmd.visual_inner_word, "n")
mapkey("<leader>y", cmd.yank_inner_word, "n")
mapkey("<leader>o", cmd.add_line_below, "n")
mapkey("<leader>if", cmd.insert_if_error, "n")
mapkey("<leader>sv", cmd.split_vertical, "n")
mapkey("<leader>sh", cmd.split_horizontal, "n")
mapkey("<leader>s", cmd.save_all, "n")

mapkey("<leader>fc", cmd.telescope_find_changed_files, "n")
mapkey("<leader>ff", cmd.telescope_find_files, "n")
mapkey("<leader>fl", cmd.telescope_live_grep, "n")
mapkey("<leader>fr", cmd.telescope_lsp_references, "n")
mapkey("<leader>d", cmd.telescope_diagnostics, "n")

mapkey("<leader>l", cmd.color_print, "n")
