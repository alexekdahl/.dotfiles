local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp = require('lspconfig')
local configs = require 'lspconfig/configs'
local util = require "lspconfig/util"

local common_on_publish_diagnostics = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = false, -- disables signs
  }
)

lsp.gopls.setup({
  capabilities = capabilities,
  cmd = { 'gopls', 'serve' },
  handlers = {
    ["textDocument/publishDiagnostics"] = common_on_publish_diagnostics,
  },
  filetypes = {"go", "gomod"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unsusedparams = true,
        nilness = true,
        staticcheck = true,
      },
      gofumpt = true,
    },
  },
  on_attach = function(client, bufnr)
    -- client.server_capabilities.document_formatting = true
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set("n","gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n","gD", "<cmd>vsp | lua vim.lsp.buf.definition()<CR>", bufopts)
    vim.keymap.set("n","gt", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n","K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n","<leader>r", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n","<leader>a", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n","<leader>d", "<cmd>Telescope diagnostics<cr>", bufopts)
    vim.keymap.set("n","<leader>l", "y<esc>ofmt.Println(\"<c-r>\"\", <c-r>\")<esc>", bufopts)
    vim.cmd[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        autocmd BufWritePre *.go lua vim.lsp.buf.format()
      augroup END
    ]]
  end
,
})

lsp.golangci_lint_ls.setup {
  cmd = { "golangci-lint-langserver" },
  handlers = {
    ["textDocument/publishDiagnostics"] = common_on_publish_diagnostics,
  },
  filetypes = {'go','gomod'},
  init_options = {
    command = { "golangci-lint", "run", "--out-format", "json", "--issues-exit-code=1" }
  },
  root_dir = util.root_pattern('.golintci.yml', '.golintci.yaml')
}

local function on_list(options)
  local items = options.items
  if #items > 1 then
    items = filter(items, filterReactDTS)
  end

  vim.fn.setqflist({}, ' ', { title = options.title, items = items, context = options.context })
  vim.api.nvim_command('cfirst')
end

local on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = true
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set("n","gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n","gD", "<cmd>vsp | lua vim.lsp.buf.definition()<CR>", bufopts)
    vim.keymap.set("n","gt", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n","K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n","<leader>r", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n","<leader>a", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n","<leader>d", "<cmd>Telescope diagnostics<cr>", bufopts)
    vim.keymap.set("n","<leader>l", "y<esc>oconsole.log('\\x1b[33m<c-r>\" ->', <c-r>\", '\\x1b[0m');<esc>", bufopts)
    -- vim.keymap.set("n", "<leader>de", vim.lsp.diagnostic.show_line_diagnostics, bufopts)
    vim.cmd[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
      augroup END
    ]]
  end
lsp.tsserver.setup({
  handlers = {
    ["textDocument/publishDiagnostics"] = common_on_publish_diagnostics,
  },
  filetypes = { "typescript", "javascript" },
  capabilities = capabilites,
  on_attach = on_attach,
})

lsp.pyright.setup{
  on_attach = on_attach,
  capabilities = capabilites,
  handlers = {
    ["textDocument/publishDiagnostics"] = common_on_publish_diagnostics,
  },
}
