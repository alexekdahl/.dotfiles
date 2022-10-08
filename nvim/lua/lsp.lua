local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp = require('lspconfig')
local util = require "lspconfig/util"

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
    -- vim.keymap.set("n", "<leader>de", vim.lsp.diagnostic.show_line_diagnostics, bufopts)
    vim.cmd[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        autocmd BufWritePre *.js,ts lua vim.lsp.buf.formatting_sync()
      augroup END
    ]]
  end

lsp.gopls.setup({
  capabilities = capabilities,
  cmd = { 'gopls', 'serve' },
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
    -- vim.keymap.set("n", "<leader>de", vim.lsp.diagnostic.show_line_diagnostics, bufopts)
    vim.cmd[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync()
      augroup END
    ]]
  end
,
})

lsp.tsserver.setup({
  filetypes = { "typescript", "javascript" },
  capabilities = capabilites,
  on_attach = on_attach,
})

