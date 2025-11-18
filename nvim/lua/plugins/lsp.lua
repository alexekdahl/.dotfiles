local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd


local grp_lsp_refs = augroup("CustomLspReferences", { clear = true })
local grp_format   = augroup("LspFormatting", { clear = true })

local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
  vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>k", function()
    vim.diagnostic.open_float({ border = "rounded" })
  end, opts)

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_clear_autocmds({ group = grp_lsp_refs, buffer = bufnr })

    autocmd("CursorHold", { group = grp_lsp_refs, buffer = bufnr, callback = vim.lsp.buf.document_highlight })
    autocmd("CursorMoved", { group = grp_lsp_refs, buffer = bufnr, callback = vim.lsp.buf.clear_references })
  end
end

return {
  "neovim/nvim-lspconfig",
  ft = { "go", "lua", "python", "rust", "nim", "just" },
  opts = {
    servers = {
      gopls = {
        settings = {
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
          },
        },
      },

      lua_ls = {
        settings = {
          Lua = {
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              },
            },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = { [vim.fn.expand("$VIMRUNTIME/lua")] = true },
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      },

      pyright = {
        settings = {
          pyright = { disableOrganizeImports = false },
          python = {
            analysis = {
              typeCheckingMode = "standard",
              useLibraryCodeForTypes = true,
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              autoImportCompletions = true,
              diagnosticSeverityOverrides = {
                reportUnusedImport = "error",
                reportUnusedVariable = "error",
                reportGenericTypeIssues = "error",
                reportOptionalMemberAccess = "warning",
                reportOptionalSubscription = "warning",
              },
            },
          },
        },
      },

      nim_langserver = {
        settings = {
          nim = {
            autoCheckFile = true,
            maxNimsuggestProcesses = 2,
          },
        },
      },

      just = {},

      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
          },
        },
      },
    },
  },

  config = function(_, opts)
    -- require("mason").setup()
    --
    -- require("mason-lspconfig").setup({
    --   ensure_installed = {
    --     "pyright",
    --     "lua_ls",
    --     "gopls",
    --     "nim_langserver",
    --     "just",
    --     "rust_analyzer",
    --   },
    --   automatic_enable = true,
    -- })

    autocmd("BufWritePre", {
      group = grp_format,
      callback = function(args)
        local bufnr = args.buf
        local ft = vim.bo[bufnr].filetype

        local preferred = {
          go   = "gopls",
          nim  = "nim_langserver",
          lua  = "lua_ls",
          rust = "rust_analyzer",
        }

        local want = preferred[ft]
        if not want then return end

        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        local ok_clients = vim.tbl_filter(function(c)
          return c.name == want and (
            c.server_capabilities.documentFormattingProvider
            or c.server_capabilities.documentRangeFormattingProvider
          )
        end, clients)

        if vim.tbl_isempty(ok_clients) then return end

        vim.lsp.buf.format({
          async = false,
          bufnr = bufnr,
          filter = function(c) return c.name == want end,
        })
      end,
    })

    for server, config in pairs(opts.servers) do
      config.on_attach = on_attach
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end,
}
