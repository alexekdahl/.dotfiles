return {
  filetypes = { "lua" },

  cmd = { "lua-language-server" },

  root_dir = function(bufnr, cb)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local start = vim.fs.dirname(filename)

    local stylua = vim.fs.root(start, { "stylua.toml", ".stylua.toml" })
    if stylua then
      cb(stylua)
      return
    end

    local lua_dir = vim.fs.root(start, { "lua" })
    if lua_dir then
      cb(lua_dir)
      return
    end

    local init = vim.fs.root(start, { "init.lua" })
    if init then
      cb(init)
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
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
        },
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
