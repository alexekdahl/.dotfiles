local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp = require('lspconfig')
local util = require "lspconfig/util"

local common_on_publish_diagnostics = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = false,
  }
)

local function on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set("n","gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n","gD", "<cmd>vsp | lua vim.lsp.buf.definition()<CR>", bufopts)
  vim.keymap.set("n","gt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n","K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n","<leader>r", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n","<leader>a", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n","<leader>d", "<cmd>Telescope diagnostics<cr>", bufopts)
  vim.cmd[[
    augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      autocmd BufWritePre *.go lua vim.lsp.buf.format()
    augroup END
  ]]
end

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "gopls", "golangci_lint_ls", "tsserver", "pylsp" },

  automatic_installation = true,
})

require("mason-lspconfig").setup_handlers({
  function(server_name)
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }
    lsp[server_name].setup(opts)
  end,
  ["gopls"] = function()
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
      on_attach = on_attach,
    })
  end,
  ["golangci_lint_ls"] = function()
    lsp.golangci_lint_ls.setup({
      cmd = { "golangci-lint-langserver" },
      handlers = {
        ["textDocument/publishDiagnostics"] = common_on_publish_diagnostics,
      },
      filetypes = {'go','gomod'},
      init_options = {
        command = { "golangci-lint", "run", "--out-format", "json" }
      },
      root_dir = util.root_pattern('.golintci.yml', '.golintci.yaml'),
      on_attach = on_attach,
    })
  end,
  ["tsserver"] = function()
    lsp.tsserver.setup({
      handlers = {
        ["textDocument/publishDiagnostics"] = common_on_publish_diagnostics,
      },
      filetypes = { "typescript", "javascript" },
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
  ["pylsp"] = function()
    lsp.pylsp.setup({
      on_attach = on_attach,
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = {
              enabled = true,
              maxLineLength = 120
            },
            black = {
              enabled = true,
              line_length = 120
            },
          },
        },
      },
      flags = {
        debounce_text_changes = 200,
      },
      capabilities = capabilities,
      handlers = {
        ["textDocument/publishDiagnostics"] = common_on_publish_diagnostics,
      },
    })
  end,
})
