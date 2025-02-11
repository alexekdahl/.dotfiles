local feedkeys = vim.api.nvim_feedkeys

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

function M.toggle_copilot()
	vim.api.nvim_exec(":CopilotToggle", true)
end

return M
