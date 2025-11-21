return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        build = ":TSUpdate",
        auto_install = true,
        ensure_installed = {
          "markdown",
          "json",
          "yaml",
          "bash",
          "lua",
          "gitignore",
          "python",
          "go",
          "gomod",
          "markdown_inline",
        },
        event = { "BufReadPre", "BufNewFile" },
        indent = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        autopairs = {
          enable = true,
        },
        refactor = {
          highlight_definitions = {
            enable = true,
          },
          highlight_current_scope = {
            enable = false,
          },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
          },
        },
        playground = { enable = false },
      })
    end,
  },
}
