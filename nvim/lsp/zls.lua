return {
  filetypes = { "zig", "zir" },
  cmd = { "zls" },
  root_dir = function(bufnr, cb)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local start = vim.fs.dirname(filename)

    local stylua = vim.fs.root(start, { ".zig", ".zon" })
    if stylua then
      cb(stylua)
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
    zls = {
      semantic_tokens = "partial",
    },
  },
}
