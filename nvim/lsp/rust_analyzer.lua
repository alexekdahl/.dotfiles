return {
  filetypes = { "rust" },
  cmd = { "rust-analyzer" },
  root_dir = function(bufnr, cb)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local start = vim.fs.dirname(filename)
    local root = vim.fs.root(start, { "Cargo.toml", "rust-project.json" })
    if root then
      cb(root)
      return
    end

    local git = vim.fs.root(start, { ".git" })
    if git then
      cb(git)
      return
    end

    cb(start)
  end,

  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      procMacro = {
        enable = true,
      },
    },
  },
}
