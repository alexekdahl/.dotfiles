local feedkeys = vim.api.nvim_feedkeys
local M = {}

function M.save_all()
  vim.cmd("silent! wa!")
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
  vim.cmd("TmuxNavigateDown")
end

function M.focus_split_left()
  vim.cmd("TmuxNavigateLeft")
end

function M.focus_split_up()
  vim.cmd("TmuxNavigateUp")
end

function M.focus_split_right()
  vim.cmd("TmuxNavigateRight")
end

function M.split_vertical()
  vim.cmd("vsplit")
end

function M.split_horizontal()
  vim.cmd("split")
end

function M.split_join_toggle()
  vim.cmd("SplitJoinToggle")
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

function M.smart_replace()
  vim.cmd("SmartReplace")
end

return M
