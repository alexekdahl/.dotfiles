vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
  picker = {
    enabled = true,
    layout = { cycle = false },
  },
  explorer = { enabled = true },
  gitbrowse = { enabled = true },
  indent = {
    enabled = true,
    animate = { enabled = false },
    scope = { enabled = false },
  },
})
