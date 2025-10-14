local on_attach = require("util.lsp").on_attach
local handlers = require("util.lsp").handlers

local function base(common_caps)
	return {
		on_attach = on_attach,
		handlers = handlers,
		capabilities = common_caps,
	}
end

local function config()
	local caps = vim.lsp.protocol.make_client_capabilities()
	local ok, cmp = pcall(require, "cmp_nvim_lsp")
	if ok then
		caps = cmp.default_capabilities(caps)
	end

	local common = base(caps)

	vim.lsp.config(
		"rust_analyzer",
		vim.tbl_deep_extend("force", common, {
			filetypes = { "rust" },
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
					},
					checkOnSave = {
						command = "clippy",
					},
				},
			},
		})
	)

	vim.lsp.config(
		"gopls",
		vim.tbl_deep_extend("force", common, {
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
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
		})
	)

	vim.lsp.config(
		"nim_langserver",
		vim.tbl_deep_extend("force", common, {
			filetypes = { "nim" },
			settings = { nim = { autoCheckFile = true, maxNimsuggestProcesses = 2 } },
		})
	)

	vim.lsp.config(
		"lua_ls",
		vim.tbl_deep_extend("force", common, {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = { [vim.fn.expand("$VIMRUNTIME/lua")] = true },
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		})
	)

	vim.lsp.config(
		"pyright",
		vim.tbl_deep_extend("force", common, {
			settings = {
				pyright = { disableOrganizeImports = false },
				python = {
					analysis = {
						useLibraryCodeForTypes = true,
						autoSearchPaths = true,
						diagnosticMode = "workspace",
						autoImportCompletions = true,
					},
				},
			},
		})
	)

	vim.lsp.config(
		"efm",
		vim.tbl_deep_extend("force", common, {
			filetypes = { "lua" },
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
	)
end

return {
	"neovim/nvim-lspconfig",
	ft = { "go", "lua", "python", "rust", "nim", "just" },
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"creativenull/efmls-configs-nvim",
	},
	config = config,
}
