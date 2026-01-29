local function copy_go_test_command()
  local line = vim.api.nvim_get_current_line()

  local test_name = line:match("func%s+([%w_]+)%s*%(")

  if not test_name or not test_name:match("^Test") then
    vim.notify("Not on a Go test function", vim.log.levels.WARN)
    return
  end

  local file_dir = vim.fn.expand("%:h")
  if file_dir == "" then
    file_dir = "."
  elseif file_dir ~= "." then
    file_dir = "./" .. file_dir
  end

  local cmd = string.format("go test -run %s %s", test_name, file_dir)

  vim.fn.setreg("+", cmd)

  vim.notify("Copied to clipboard: " .. cmd, vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>gg", copy_go_test_command, { noremap = true, silent = false })
