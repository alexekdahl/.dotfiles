return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  config = function()
    require("nvim-treesitter").setup({})

    require("nvim-treesitter").install({
      "markdown",
      "markdown_inline",
      "json",
      "yaml",
      "bash",
      "lua",
      "gitignore",
      "python",
      "go",
      "nim",
      "gomod",
      "rust",
      "just",
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
