local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lsp = require('lspconfig')
local util = require "lspconfig/util"
local plenary_job = require("plenary.job")

local function watch_go_files()
    local watcher = require("plenary.filewatcher").new()
    watcher:add_dir(vim.fn.getcwd(), {search_pattern = "%.go$"})
    watcher:on_event(function(event)
        if event.type == "file_changed" then
            plenary_job:new({
                command = "gci",
                args = {"write", event.file, "-s", "standard", "-s", "default", "-s", "prefix(controllers/)"},
            }):start()
        end
    end)
    watcher:start()
end

local common_on_publish_diagnostics = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = false,
  }
)

local function go_on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set("n","gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n","gD", "<cmd>vsp | lua vim.lsp.buf.definition()<CR>", bufopts)
  vim.keymap.set("n","gt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n","K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n","<leader>k", vim.diagnostic.open_float, bufopts)
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
  watch_go_files()
end

local js_on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = true
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set("n","gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n","gD", "<cmd>vsp | lua vim.lsp.buf.definition()<CR>", bufopts)
    vim.keymap.set("n","gt", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n","K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n","<leader>r", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n","<leader>k", vim.diagnostic.open_float, bufopts)
    vim.keymap.set("n","<leader>a", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n","<leader>d", "<cmd>Telescope diagnostics<cr>", bufopts)
    vim.keymap.set("n","<leader>l", "y<esc>oconsole.log('\\x1b[33m<c-r>\" ->', <c-r>\", '\\x1b[0m');<esc>", bufopts)
    vim.cmd[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
      augroup END
    ]]
  end

local py_on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = true
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set("n","gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n","gD", "<cmd>vsp | lua vim.lsp.buf.definition()<CR>", bufopts)
    vim.keymap.set("n","gt", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n","K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n","<leader>r", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n","<leader>k", vim.diagnostic.open_float, bufopts)
    vim.keymap.set("n","<leader>a", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n","<leader>d", "<cmd>Telescope diagnostics<cr>", bufopts)
    vim.keymap.set("n", "<leader>l", "y<esc>oprint('\\x1b[33m<c-r>\" ->', f'{<c-r>\"}', '\\x1b[0m')<esc>", bufopts)
    vim.cmd[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
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
          gofumpt = false,
        },
      },
      on_attach = go_on_attach,
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
      root_dir = util.root_pattern("go.work", "go.mod", ".git"),
      on_attach = go_on_attach,
    })
  end,
  ["tsserver"] = function()
    lsp.tsserver.setup({
      handlers = {
        ["textDocument/publishDiagnostics"] = common_on_publish_diagnostics,
      },
      filetypes = { "typescript", "javascript" },
      capabilities = capabilities,
      on_attach = js_on_attach,
    })
  end,
  ["pylsp"] = function()
    lsp.pylsp.setup({
      root_dir = util.root_pattern("setup.py", "pyproject.toml", "setup.cfg"),
      on_attach = py_on_attach,
      settings = {
        pylsp = {
          configurationSources = {"flake8", "black", "mypy", "pycodestyle"},
          plugins = {
            black = {
              enabled = true,
              maxLineLength = 120,
            },
            flake8 = {
              enabled = true,
              maxLineLength = 120,
            },
            -- pylint = {
            --   enabled = true,
            --   maxLineLength = 120,
            --   args = {
            --     "--disable=wrong-import-position,missing-function-docstring,line-too-long,missing-class-docstring",
            --     "--enable=unused-variable"
            --   },
            -- },
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
