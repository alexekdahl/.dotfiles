local feedkeys = vim.api.nvim_feedkeys
local M = {}

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

function M.save_all()
	vim.cmd("wa!")
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
	vim.cmd.wincmd("j")
end
function M.focus_split_left()
	vim.cmd.wincmd("h")
end
function M.focus_split_up()
	vim.cmd.wincmd("k")
end
function M.focus_split_right()
	vim.cmd.wincmd("l")
end
function M.split_vertical()
	vim.cmd("vsplit")
end
function M.split_horizontal()
	vim.cmd("split")
end
function M.go_test()
	vim.cmd("GoTestFunc")
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
	vim.cmd("CopilotToggle")
end

function M.telescope_marksman()
	local ok, marksman = pcall(require, "marksman")
	if not ok then
		return
	end
	local ok, _ = pcall(require, "telescope")
	if not ok then
		marksman.show_marks()
		return
	end

	local marks = marksman.get_marks()

	if vim.tbl_isempty(marks) then
		vim.notify("No marks in current project", vim.log.levels.INFO)
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local entries = {}
	for name, mark in pairs(marks) do
		table.insert(entries, {
			value = name,
			display = name .. " - " .. vim.fn.fnamemodify(mark.file, ":~:.") .. ":" .. mark.line,
			ordinal = name .. " " .. mark.file .. " " .. (mark.text or ""),
			filename = mark.file,
			lnum = mark.line,
			col = mark.col,
			text = mark.text,
		})
	end

	table.sort(entries, function(a, b)
		local mark_a = marks[a.value]
		local mark_b = marks[b.value]
		return (mark_a.created_at or 0) > (mark_b.created_at or 0)
	end)

	pickers
		.new({}, {
			prompt_title = "Project Marks",
			finder = finders.new_table({
				results = entries,
				entry_maker = function(entry)
					return entry
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = conf.grep_previewer({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection then
						marksman.goto_mark(selection.value)
					end
				end)

				return true
			end,
		})
		:find()
end

function M.snacks_marksman()
	local ok, marksman = pcall(require, "marksman")
	if not ok then
		return {}
	end

	local marks = marksman.get_marks()
	if vim.tbl_isempty(marks) then
		return {}
	end

	local results = {}
	for name, mark in pairs(marks) do
		local entry = {
			text = name,
			file = mark.file,
			pos = { tonumber(mark.line) or 1, tonumber(mark.col) or 1 },
			display = string.format("%s %s:%d", name, vim.fn.fnamemodify(mark.file, ":~:."), tonumber(mark.line) or 1),
			ordinal = name .. " " .. vim.fn.fnamemodify(mark.file, ":t"),
			mark_name = name,
		}
		table.insert(results, entry)
	end

	-- Sort by creation time (newest first)
	table.sort(results, function(a, b)
		local mark_a = marks[a.mark_name]
		local mark_b = marks[b.mark_name]
		return (mark_a.created_at or 0) > (mark_b.created_at or 0)
	end)

	return results
end

-- %        whole file
-- .        current line
-- $        last line
-- 1,10     explicit line span
-- .,$      from current to end
function M.smart_replace()
	vim.ui.input({ prompt = " : search" }, function(search)
		if not search or search == "" then
			return
		end

		vim.ui.input({ prompt = "󰛔 : replace " .. search }, function(replace)
			if not replace then
				return
			end

			vim.ui.input({
				prompt = " Scope: ",
				default = "%",
			}, function(scope)
				scope = (scope == "" or scope == nil) and "%" or scope

				local cmd =
					string.format("%ss/%s/%s/g", scope, vim.fn.escape(search, "/\\"), vim.fn.escape(replace, "/\\"))

				vim.cmd(cmd)
			end)
		end)
	end)
end

return M
