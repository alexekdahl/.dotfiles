local feedkeys = vim.api.nvim_feedkeys

local format_strings = {
	lua = 'print("\\27[33m%s:\\27[0m", %s)',
	go = 'fmt.Printf("\\033[33m%s:\\033[0m %%v\\n", %s)',
	javascript = 'console.log("\\x1b[33m%s:\\x1b[0m", %s);',
	typescript = 'console.log("\\x1b[33m%s:\\x1b[0m", %s);',
	python = 'print(f"\\033[33m{%s=}\\033[0m")',
	rust = 'println!("\\x1b[33m{}: {:?}\\x1b[0m", %s);',
	c = 'printf("\\033[33m%s: %%d\\033[0m\\n", %s);',
	nim = 'echo "\\e[33m%s: \\e[0m", $%s',
}

local M = {}

function M.save_all()
	vim.api.nvim_exec(":wa!", true)
end

function M.paste_no_registry()
	feedkeys('"_dP', "n", true)
end

function M.visual_inner_word()
	feedkeys("viw", "n", true)
end

function M.yank_inner_word()
	feedkeys("yiw", "n", true)
end

function M.add_line_below()
	vim.api.nvim_input("o<Esc>")
end

function M.focus_split_down()
	vim.api.nvim_exec("<C-W><C-J>", true)
end

function M.focus_split_left()
	vim.api.nvim_exec("<C-W><C-H>", true)
end

function M.focus_split_up()
	vim.api.nvim_exec("<C-W><C-K>", true)
end

function M.focus_split_right()
	vim.api.nvim_exec("<C-W><C-L>", true)
end

function M.split_vertical()
	vim.api.nvim_exec("vsplit", true)
end

function M.split_horizontal()
	vim.api.nvim_exec("split", true)
end

function M.go_test()
	vim.api.nvim_exec("GoTestFunc", true)
end

function M.toggle_quickfix()
	local qf_exists = false
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			qf_exists = true
		end
	end
	if qf_exists == true then
		vim.cmd("cclose")
		return
	end
	if not vim.tbl_isempty(vim.fn.getqflist()) then
		vim.cmd("copen")
	end
end

function M.color_print()
	local clipboard = vim.fn.getreg("+")
	if clipboard == "" then
		vim.notify("Clipboard is empty", vim.log.levels.WARN)
		return
	end

	local filetype = vim.bo.filetype
	local format_string = format_strings[filetype] or 'print("\\27[33m%s:\\27[0m", %s)'
	local print_statement = string.format(format_string, clipboard, clipboard)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line = cursor_pos[1]
	local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1] or ""
	local indentation = current_line:match("^%s*") or ""

	vim.api.nvim_buf_set_lines(0, line, line, false, { indentation .. print_statement })
	vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
end

function M.toggle_copilot()
	vim.api.nvim_exec(":CopilotToggle", true)
end

return M
