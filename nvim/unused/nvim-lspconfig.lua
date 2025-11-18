local autocmd_clear = vim.api.nvim_clear_autocmds
local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
local mapkey = require("util.keymapper").mapkey

local handlers = {
	["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { signs = false }),
}

local autocmd = function(args)
	local event = args[1]
	local group = args[2]
	local callback = args[3]

	vim.api.nvim_create_autocmd(event, {
		group = group,
		buffer = args[4],
		callback = function()
			callback()
		end,
		once = args.once,
	})
end

local function on_attach(client, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	if client and client.server_capabilities then
		client.server_capabilities.documentFormattingProvider = true
	end

	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	mapkey("<leader>r", vim.lsp.buf.rename, "n", bufopts)

	-- Set autocommands conditional on server capabilities
	if client and client.server_capabilities.documentHighlightProvider then
		autocmd_clear({ group = augroup_highlight, buffer = bufnr })
		autocmd({ "CursorHold", augroup_highlight, vim.lsp.buf.document_highlight, bufnr })
		autocmd({ "CursorMoved", augroup_highlight, vim.lsp.buf.clear_references, bufnr })
	end
end

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
			filetypes = { "python" },
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
	enabled = false,
	ft = { "go", "lua", "python", "rust", "nim", "just" },
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
		"creativenull/efmls-configs-nvim",
	},
	config = config,
}
