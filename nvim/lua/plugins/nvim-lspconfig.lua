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
				handlers = handlers,
				filetypes = { "go", "go.mod" },
				root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
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
						annotations = {
							inline = false,
						},
						-- staticcheck = true,
						gofumpt = true,
					},
				},
			})
		end,
		["nim_langserver"] = function()
			lspconfig.nim_langserver.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				handlers = handlers,
				filetypes = { "nim" },
				root_dir = lspconfig.util.root_pattern("nim.cfg", ".git", "*.nimble"),
				settings = {
					nim = {
						-- nimsuggestPath = vim.env.NIMBIN .. "/nimsuggest",
						autoCheckFile = true,
						maxNimsuggestProcesses = 2,
						-- projectMapping = {
						-- 	projectFile = "src/main.nim",
						-- 	fileRegex = ".*\\.nim",
						-- },
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
		["efm"] = function()
			lspconfig.efm.setup({
				filetypes = {
					"lua",
					"python",
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
						lua = {
							require("efmls-configs.linters.luacheck"),
							require("efmls-configs.formatters.stylua"),
						},
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
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"creativenull/efmls-configs-nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
	},
}
