return {
  filetypes = { "nim" },

  cmd = { "nimlangserver" },

  flags = {
    debounce_text_changes = 150,
  },

  on_init = function(client)
    client.config.flags = client.config.flags or {}
    client.config.flags.debounce_text_changes = 150
  end,

  handlers = {
    ["window/showMessage"] = function(_, result, ctx)
      if result.type > 2 then
        return
      end
      vim.lsp.handlers["window/showMessage"](_, result, ctx)
    end,
    ["window/logMessage"] = function() end,
  },

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
