function SpellBee()
  local line_number = vim.fn.line(".")
  local line_text = vim.fn.getline(line_number)

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local selected_text = string.sub(line_text, start_pos[3], end_pos[3])

  selected_text = string.lower(selected_text)

  local command = "sp " .. selected_text
  local output = vim.fn.system(command)
  vim.api.nvim_echo({{output}}, false, {})
end

vim.api.nvim_set_keymap('v', '<C-t>', ':lua SpellBee()<CR>', { noremap = true })
