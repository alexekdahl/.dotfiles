vim.schedule(function()
  vim.pack.add({ "https://github.com/alexekdahl/marksman.nvim" })

  require("marksman").setup({
    max_marks = 4,
    silent = true,
    minimal = true,
    disable_default_keys = true,
    debounce_ms = 100,
    highlights = {
      ProjectMarksTitle = { fg = "#FFE591" },
      ProjectMarksNumber = { fg = "#525252" },
      ProjectMarksName = { fg = "#85B884" },
      ProjectMarksFile = { fg = "#ABBAB5" },
      ProjectMarksLine = { fg = "#D19B6E" },
      ProjectMarksText = { fg = "#727272" },
      ProjectMarksHelp = { fg = "#525252" },
      ProjectMarksBorder = { fg = "#525252" },
      ProjectMarksSearch = { fg = "#FFE591" },
    },
  })

  local marksman = require("marksman")
  vim.keymap.set("n", "<C-a>", marksman.add_mark, { desc = "Add mark" })
  vim.keymap.set("n", "<C-e>", marksman.show_marks, { desc = "Show marks" })
  vim.keymap.set("n", "<M-y>", function() marksman.goto_mark(1) end, { desc = "Go to mark 1" })
  vim.keymap.set("n", "<M-u>", function() marksman.goto_mark(2) end, { desc = "Go to mark 2" })
  vim.keymap.set("n", "<M-i>", function() marksman.goto_mark(3) end, { desc = "Go to mark 3" })
  vim.keymap.set("n", "<M-o>", function() marksman.goto_mark(4) end, { desc = "Go to mark 4" })
end)
