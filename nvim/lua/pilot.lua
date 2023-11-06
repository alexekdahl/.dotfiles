require('tabnine').setup({
  disable_auto_comment = true,
  accept_keymap = "<Tab>",
  dismiss_keymap = "<C-e>",
  debounce_ms = 400,
  suggestion_color = {gui = "#808080", cterm = 244},
  exclude_filetypes = {"help", "gitcommit", "svn", "cvs", "TelescopePrompt", "NvimTree"},
  log_file_path = nil, -- absolute path to Tabnine log file
})
