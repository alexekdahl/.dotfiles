return {
  filetypes = { "go", "gomod", "gowork", "gosum" },

  cmd = { "gopls" },

  root_dir = function(bufnr, cb)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local cwd = vim.fs.dirname(filename)

    -- First attempt: `go env -json GOMOD`
    local ok = pcall(vim.system, { "go", "env", "-json", "GOMOD" }, { cwd = cwd }, function(out)
      if out.code ~= 0 then return end

      local ok_json, data = pcall(vim.json.decode, out.stdout)
      if ok_json and data.GOMOD and data.GOMOD ~= "/dev/null" then
        local gomod_dir = vim.fs.dirname(data.GOMOD)
        if gomod_dir then
          cb(gomod_dir)
        end
      end
    end)

    if not ok then
      local root = vim.fs.root(bufnr, { "go.mod" })
      if root then
        local workspace = vim.fs.root(root, { "go.work" })
        if workspace then
          cb(workspace)
        else
          cb(root)
        end
      end
    end
  end,

  settings = {
    autoformat = true,
    gopls = {
      buildFlags = { "-tags=acap" },
      analyses = {
        unusedparams = true,
        unreachable = true,
        nilness = true,
        unusedwrite = true,
        unusedvariable = true,
        assign = false,
        shadow = true,
        fieldalignment = false,
      },
      annotations = { inline = false },
      gofumpt = true,
      semanticTokens = true,
      staticcheck = true,
    },
  },
}
