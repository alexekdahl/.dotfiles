local M = {}

local marks = {}
local current_project = nil

local function get_project_root()
	local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
	if vim.v.shell_error == 0 then
		return git_root
	end
	return vim.fn.getcwd()
end

local function get_marks_file()
	local project = get_project_root()
	local hash = vim.fn.sha256(project):sub(1, 8)
	local data_path = vim.fn.stdpath("data")
	return data_path .. "/project_marks_" .. hash .. ".json"
end

local function load_marks()
	current_project = get_project_root()
	local file = get_marks_file()

	if vim.fn.filereadable(file) == 1 then
		local content = vim.fn.readfile(file)
		if #content > 0 then
			marks = vim.json.decode(table.concat(content, "\n")) or {}
		end
	else
		marks = {}
	end
end

local function save_marks()
	local file = get_marks_file()
	local json = vim.json.encode(marks)
	vim.fn.writefile({ json }, file)
end

function M.add_mark(name)
	load_marks()

	local bufname = vim.fn.expand("%:p")
	local line = vim.fn.line(".")
	local col = vim.fn.col(".")

	if not name or name == "" then
		name = vim.fn.fnamemodify(bufname, ":t") .. ":" .. line
	end

	marks[name] = {
		file = bufname,
		line = line,
		col = col,
		text = vim.fn.getline("."):sub(1, 50),
	}

	save_marks()
	vim.notify("Mark added: " .. name)
end

function M.goto_mark(name_or_index)
	load_marks()

	local mark = nil

	-- Handle numeric index
	if type(name_or_index) == "number" then
		local mark_names = {}
		for name, _ in pairs(marks) do
			table.insert(mark_names, name)
		end
		table.sort(mark_names)

		if name_or_index > 0 and name_or_index <= #mark_names then
			local identifier = mark_names[name_or_index]
			mark = marks[identifier]
		end
	else
		-- Handle string name
		mark = marks[name_or_index]
	end

	if mark then
		vim.cmd("edit " .. mark.file)
		vim.fn.cursor(mark.line, mark.col)
	else
		vim.notify("Mark not found: " .. tostring(name_or_index), vim.log.levels.WARN)
	end
end

function M.delete_mark(name)
	load_marks()

	if marks[name] then
		marks[name] = nil
		save_marks()
		vim.notify("Mark deleted: " .. name)
	else
		vim.notify("Mark not found: " .. name, vim.log.levels.WARN)
	end
end

function M.show_marks()
	load_marks()

	if vim.tbl_isempty(marks) then
		vim.notify("No marks in current project", vim.log.levels.INFO)
		return
	end

	-- Create buffer content
	local lines = {}
	local mark_names = {}

	for name in pairs(marks) do
		table.insert(mark_names, name)
	end
	table.sort(mark_names)

	for i, name in ipairs(mark_names) do
		local mark = marks[name]
		local display = string.format("[%d] %s - %s:%d", i, name, vim.fn.fnamemodify(mark.file, ":~:."), mark.line)
		table.insert(lines, display)
		table.insert(lines, "    " .. (mark.text or ""))
	end

	-- Create floating window
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

	local width = math.min(80, vim.o.columns - 10)
	local height = math.min(#lines, vim.o.lines - 10)

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = (vim.o.lines - height) / 2,
		col = (vim.o.columns - width) / 2,
		border = "rounded",
		style = "minimal",
		title = " Project Marks - " .. vim.fn.fnamemodify(current_project, ":t") .. " ",
		title_pos = "center",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	-- Keymaps for the floating window
	local function close_window()
		vim.api.nvim_win_close(win, true)
	end

	local function goto_selected()
		local line = vim.fn.line(".")
		local idx = math.ceil(line / 2)
		if idx > 0 and idx <= #mark_names then
			close_window()
			M.goto_mark(mark_names[idx])
		end
	end

	vim.api.nvim_buf_set_keymap(buf, "n", "q", "", { callback = close_window, noremap = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "", { callback = close_window, noremap = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", { callback = goto_selected, noremap = true })

	-- Number key navigation
	for i = 1, math.min(9, #mark_names) do
		vim.api.nvim_buf_set_keymap(buf, "n", tostring(i), "", {
			callback = function()
				close_window()
				M.goto_mark(mark_names[i])
			end,
			noremap = true,
		})
	end
end

function M.get_marks_count()
	load_marks()
	return vim.tbl_count(marks)
end

function M.setup(_)
	vim.api.nvim_create_user_command("MarkAdd", function(args)
		M.add_mark(args.args ~= "" and args.args or nil)
	end, { nargs = "?" })

	vim.api.nvim_create_user_command("MarkGoto", function(args)
		if args.args == "" then
			M.show_marks()
		else
			M.goto_mark(args.args)
		end
	end, { nargs = "?" })

	vim.api.nvim_create_user_command("MarkDelete", function(args)
		M.delete_mark(args.args)
	end, { nargs = 1 })

	vim.api.nvim_create_user_command("MarkList", function()
		M.show_marks()
	end, {})

	vim.keymap.set("n", "<C-a>", M.add_mark, { desc = "Add mark" })
	vim.keymap.set("n", "<C-e>", M.show_marks, { desc = "Show marks" })
	vim.keymap.set("n", "<M-y>", function()
		M.goto_mark(1)
	end, { desc = "Goto mark" })
	vim.keymap.set("n", "<M-u>", function()
		M.goto_mark(2)
	end, { desc = "Goto mark" })
	vim.keymap.set("n", "<M-i>", function()
		M.goto_mark(3)
	end, { desc = "Goto mark" })
	vim.keymap.set("n", "<M-o>", function()
		M.goto_mark(4)
	end, { desc = "Goto mark" })
end

return M
