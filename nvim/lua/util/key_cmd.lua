local feedkeys = vim.api.nvim_feedkeys

local M = {}

M.save_all = function()
	feedkeys("wa!", "n", true)
end

M.delete_and_paste_no_registry = function()
	feedkeys('"_dP', "n", true)
end

M.visual_inner_word = function()
	feedkeys("viw", "n", true)
end

M.yank_inner_word = function()
	feedkeys("yiw", "n", true)
end

M.add_line_below = function()
	feedkeys("o<Esc>", "n", true)
end

M.insert_if_error = function()
	feedkeys("oif err != nil {<CR>}<Esc>Oreturn err<Esc>", "n", true)
end

M.move_window_down = function()
	vim.api.nvim_exec("<C-W><C-J>", true)
end

M.move_window_left = function()
	vim.api.nvim_exec("<C-W><C-H>", true)
end

M.move_window_up = function()
	vim.api.nvim_exec("<C-W><C-K>", true)
end

M.move_window_right = function()
	vim.api.nvim_exec("<C-W><C-L>", true)
end
M.split_vertical = function()
	vim.api.nvim_exec("vsplit", true)
end

M.split_horizontal = function()
	vim.api.nvim_exec("split", true)
end

M.telescope_find_changed_files = function()
	require("telescope.builtin").find_files({ find_command = { "git", "--no-pager", "diff", "--name-only" } })
end

M.telescope_find_files = function()
	require("telescope.builtin").find_files()
end

M.telescope_live_grep = function()
	require("telescope.builtin").live_grep()
end

M.telescope_lsp_references = function()
	require("telescope.builtin").lsp_references()
end

M.telescope_diagnostics = function()
	require("telescope.builtin").diagnostics()
end

M.lsp_goto_definition = function()
	vim.lsp.buf.definition()
end

M.lsp_peek_definition = function()
	vim.api.nvim_exec(":Lspsaga peek_definition<CR>", true)
end

M.lsp_goto_type_definition = function()
	vim.api.nvim_exec(":Lspsaga goto_type_definition<CR>", true)
end

M.lsp_show_hover_doc = function()
	vim.api.nvim_exec(":Lspsaga hover_doc<CR>", true)
end

M.lsp_rename_symbol = function()
	vim.lsp.buf.rename()
end

M.lsp_open_diagnostic_float = function()
	vim.diagnostic.open_float()
end

M.lsp_code_action = function()
	vim.api.nvim_exec(":Lspsaga code_action<CR>", true)
end

M.lsp_show_outline = function()
	vim.api.nvim_exec(":Lspsaga outline<CR>", true)
end

M.lsp_show_finder = function()
	vim.api.nvim_exec(":Lspsaga finder tyd+ref+imp+def<CR>", true)
end

M.color_print = function()
	local filetype = vim.bo.filetype
	local default = '<esc>oprint("\\x1b[33m<c-r>"->", <c-r>", "\\x1b[0m")<esc>xxxxx'

	if filetype == "go" then
		vim.api.nvim_input('<esc>ofmt.Println("\\x1b[33m<c-r>"->", <c-r>", "\\x1b[0m")<esc>xxxxx')
	elseif filetype == "typescript" then
		vim.api.nvim_input('<esc>oconsole.log("\\x1b[33m<c-r>"->", <c-r>", "\\x1b[0m")<esc>xxxxx')
	elseif filetype == "javascript" then
		vim.api.nvim_input('<esc>oconsole.log("\\x1b[33m<c-r>"->", <c-r>", "\\x1b[0m")<esc>xxxxx')
	else
		vim.api.nvim_input(default)
	end
end

return M
