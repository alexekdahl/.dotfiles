local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp = require('lspconfig')
local util = require "lspconfig/util"

local on_attach  = function(client, bufnr)
    -- client.resolved_capabilities.document_formatting = true
    vim.keymap.set("n","gd", vim.lsp.buf.definition, { buffer= 0})
    vim.keymap.set("n","gt", vim.lsp.buf.type_definition, { buffer= 0})
    vim.keymap.set("n","K", vim.lsp.buf.hover, { buffer= 0})
    vim.keymap.set("n","<leader>r", vim.lsp.buf.rename, { buffer= 0})
    vim.keymap.set("n","<leader>a", vim.lsp.buf.code_action, { buffer= 0})
    vim.keymap.set("n","<leader>d", "<cmd>Telescope diagnostics<cr>", { buffer= 0})
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.formatting, { buffer = 0 })
    vim.keymap.set("n", "<leader>de", vim.lsp.diagnostic.show_line_diagnostics, { buffer = 0 })
    vim.cmd[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        autocmd BufWritePre *.go lua vim.lsp.buf.formatting()
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
  on_attach = on_attach,
})

lsp.tsserver.setup({
  filetypes = { "typescript", "javascript" },
  -- disableAutomaticTypingAcquisition = true,
  -- init_options = {
  --   preferences = {
  --     disableSuggestions = true
  --   }
  -- },
  --
  capabilities = capabilites,
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true
    vim.keymap.set("n","gd", vim.lsp.buf.definition, { buffer= 0})
    vim.keymap.set("n","gD", "<cmd>vsp | lua vim.lsp.buf.definition()<CR>", { buffer= 0})
    vim.keymap.set("n","gt", vim.lsp.buf.type_definition, { buffer= 0})
    vim.keymap.set("n","K", vim.lsp.buf.hover, { buffer= 0})
    vim.keymap.set("n","<leader>r", vim.lsp.buf.rename, { buffer= 0})
    vim.keymap.set("n","<leader>a", vim.lsp.buf.code_action, { buffer= 0})
    vim.keymap.set("n","<leader>d", "<cmd>Telescope diagnostics<cr>", { buffer= 0})
    vim.keymap.set("n", "<leader>de", vim.lsp.diagnostic.show_line_diagnostics, { buffer = 0 })
    vim.cmd[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        autocmd BufWritePre *.js,ts lua vim.lsp.buf.formatting_sync()
      augroup END
    ]]
  end,
})

