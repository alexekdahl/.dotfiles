local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require'lspconfig'.tsserver.setup{
  filetypes = { "typescript", "javascript" },
  -- disableAutomaticTypingAcquisition = true,
  -- init_options = {
  --   preferences = {
  --     disableSuggestions = true
  --   }
  -- },
  capabilities = capabilites,
  on_attach = function()
    vim.keymap.set("n","gd", vim.lsp.buf.definition, { buffer= 0})
    vim.keymap.set("n","gt", vim.lsp.buf.type_definition, { buffer= 0})
    vim.keymap.set("n","K", vim.lsp.buf.hover, { buffer= 0})
    vim.keymap.set("n","<leader>r", vim.lsp.buf.rename, { buffer= 0})
    vim.keymap.set("n","<leader>a", vim.lsp.buf.code_action, { buffer= 0})
    vim.keymap.set("n","<leader>d", "<cmd>Telescope diagnostics<cr>", { buffer= 0})
    vim.cmd[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end,
}
