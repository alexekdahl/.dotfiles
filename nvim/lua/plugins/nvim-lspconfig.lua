local on_attach = require("util.lsp").on_attach
local handlers = require("util.lsp").handlers

local config = function()
	require("neoconf").setup({})
	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

	require("mason-lspconfig").setup_handlers({
		["gopls"] = function()
			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = { "gopls", "serve" },
				handlers = handlers,
				filetypes = { "go", "gomod" },
				root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					gopls = {
						analyses = {
							unsusedparams = true,
							unreachable = true,
							nilness = true,
							unusedwrite = true,
							unusedvariable = true,
						},
						staticcheck = true,
						gofumpt = false,
					},
				},
			})
		end,
		["golangci_lint_ls"] = function()
			lspconfig.golangci_lint_ls.setup({
				cmd = { "golangci-lint-langserver" },
				handlers = handlers,
				on_attach = on_attach,
				filetypes = { "go", "gomod" },
				init_options = {
					command = { "golangci-lint", "run", "--out-format", "json", "--issues-exit-code=1" },
				},
				root_dir = lspconfig.util.root_pattern(
					".golangci.yml",
					".golangci.yaml",
					".golangci.toml",
					".golangci.json",
					"go.work",
					"go.mod",
					".git"
				),
			})
		end,
		["lua_ls"] = function()
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})
		end,
		["jsonls"] = function()
			lspconfig.jsonls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "json", "jsonc" },
			})
		end,
		["pyright"] = function()
			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					pyright = {
						disableOrganizeImports = false,
						analysis = {
							useLibraryCodeForTypes = true,
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							autoImportCompletions = true,
						},
					},
				},
			})
		end,
		["tsserver"] = function()
			lspconfig.tsserver.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = {
					"typescript",
				},
				root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
			})
		end,
		["dockerls"] = function()
			lspconfig.dockerls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end,
		["bashls"] = function()
			lspconfig.bashls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "sh" },
			})
		end,
		["yamlls"] = function()
			lspconfig.yamlls.setup({
				settings = {
					yaml = {
						completion = true,
						-- schemaStore = { enable = true },
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
							["https://raw.githubusercontent.com/aws/serverless-application-model/main/samtranslator/schema/schema.json"] = "*cloudformation*.yaml",
						},
					},
				},
			})
		end,
		["efm"] = function()
			lspconfig.efm.setup({
				filetypes = {
					"lua",
					"python",
					"json",
					"jsonc",
					"sh",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					-- "markdown",
					"docker",
					"dockerfile",
					"html",
					"css",
					"c",
					"cpp",
				},
				init_options = {
					documentFormatting = true,
					documentRangeFormatting = true,
					hover = true,
					documentSymbol = true,
					codeAction = true,
					completion = true,
				},
				settings = {
					languages = {
						lua = { require("efmls-configs.linters.luacheck"), require("efmls-configs.formatters.stylua") },
						python = { require("efmls-configs.linters.flake8"), require("efmls-configs.formatters.black") },
						-- go = { require("efmls-configs.formatters.gofmt"), require("efmls-configs.linters.golangci_lint") },
						typescript = {
							require("efmls-configs.linters.eslint_d"),
							require("efmls-configs.formatters.prettier_d"),
						},
						json = { require("efmls-configs.formatters.fixjson") },
						jsonc = { require("efmls-configs.formatters.fixjson") },
						sh = { require("efmls-configs.linters.shellcheck"), require("efmls-configs.formatters.shfmt") },
						javascript = {
							require("efmls-configs.linters.eslint_d"),
							require("efmls-configs.formatters.prettier_d"),
						},
						javascriptreact = {
							require("efmls-configs.linters.eslint_d"),
							require("efmls-configs.formatters.prettier_d"),
						},
						typescriptreact = {
							require("efmls-configs.linters.eslint_d"),
							require("efmls-configs.formatters.prettier_d"),
						},
						-- markdown = {
						-- 	require("efmls-configs.linters.markdownlint"),
						-- 	require("efmls-configs.formatters.mdformat"),
						-- },
						docker = { require("efmls-configs.linters.hadolint") },
						dockerfile = { require("efmls-configs.linters.hadolint") },
					},
				},
			})
		end,
	})
	--
end

return {
	"neovim/nvim-lspconfig",
	config = config,
	dependencies = {
		"windwp/nvim-autopairs",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"creativenull/efmls-configs-nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
	},
}
