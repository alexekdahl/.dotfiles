return {
  filetypes = { "nim" },

  cmd = { "nimlangserver" },

  root_dir = function(bufnr, cb)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local start = vim.fs.dirname(filename)
    local root = vim.fs.root(start, { "nim.cfg", "config.nims" })
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
    nim = {
      autoCheckFile = true,
      maxNimsuggestProcesses = 2,
      diagnostics = true,
      formatOnSave = true,
      workspace = {},
    },
  },
}
