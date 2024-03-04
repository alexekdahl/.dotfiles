local on_attach = require("util.lsp").on_attach
local handlers = require("util.lsp").handlers

local config = function()
	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

	require("mason-lspconfig").setup_handlers({
		["gopls"] = function()
			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = { "gopls", "serve" },
				handlers = handlers,
				filetypes = { "go", "go.mod" },
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
						annotations = {
							inline = false,
						},
						staticcheck = true,
						gofumpt = false,
					},
				},
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
					"javascript",
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
				filetypes = { "sh", "bash", "zsh" },
			})
		end,
		["efm"] = function()
			lspconfig.efm.setup({
				filetypes = {
					"lua",
					"python",
					"json",
					"javascript",
					"typescript",
					"docker",
					"dockerfile",
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
						typescript = {
							require("efmls-configs.linters.eslint_d"),
							require("efmls-configs.formatters.prettier_d"),
						},
						json = { require("efmls-configs.formatters.fixjson") },
						javascript = {
							require("efmls-configs.linters.eslint_d"),
							require("efmls-configs.formatters.prettier_d"),
						},
						docker = { require("efmls-configs.linters.hadolint") },
						dockerfile = { require("efmls-configs.linters.hadolint") },
					},
				},
			})
		end,
	})
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
