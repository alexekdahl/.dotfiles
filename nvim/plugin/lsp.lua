local autocmd = vim.api.nvim_create_autocmd
local lsp_group = vim.api.nvim_create_augroup("lsp#", {})

-- Set LSP log level to only show warnings and errors
vim.lsp.set_log_level("warn")

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(args)
    local buf = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client:supports_method("textDocument/documentHighlight") then
      autocmd({ "CursorHold", "InsertLeave" }, {
        buffer = buf,
        group = lsp_group,
        callback = vim.lsp.buf.document_highlight,
      })
      autocmd({ "CursorMoved", "InsertEnter" }, {
        buffer = buf,
        group = lsp_group,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client and client.server_capabilities.documentFormattingProvider then
      autocmd("BufWritePre", {
        buffer = buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = buf, async = false })
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = lsp_group,
  callback = function(args)
    local buf = args.buf
    vim.b[buf].lsp = nil
    vim.api.nvim_clear_autocmds({ group = lsp_group, buffer = buf })
  end,
})

local function enable()
  vim.g.lsp_autostart = true
  vim.cmd("doautoall <nomodeline> FileType")
end

local function disable()
  vim.g.lsp_autostart = false
  vim.lsp.stop_client(vim.lsp.get_clients())
end

vim.api.nvim_create_user_command("LspStart", enable, {})
vim.api.nvim_create_user_command("LspStop", disable, {})

local names = {}
for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local name = vim.fn.fnamemodify(path, ":t:r")
  table.insert(names, name)
end

vim.lsp.enable(names)
