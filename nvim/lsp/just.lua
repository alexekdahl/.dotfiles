return {
  filetypes = { "just" },
  cmd = { "just-lsp" },
  root_dir = function(bufnr, cb)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local start = vim.fs.dirname(filename)
    local git = vim.fs.root(start, { ".git" })
    if git then
      cb(git)
      return
    end

    cb(start)
  end
}
