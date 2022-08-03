require("nvim-autopairs").setup {}
require('nvim-treesitter.configs').setup{
highlight = { enable = true, additional_vim_regex_highlighting = false },
textobjects = { enable = true },
ensure_installed = {'javascript', 'typescript', 'lua', 'go', 'gomod', 'gowork'},
  indent = { enable = true },
  autopairs = { enable = true },
  rainbow = { enable = true },
}

