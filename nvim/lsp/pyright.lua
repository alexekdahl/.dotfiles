return {
	filetypes = { "python" },

	cmd = { "pyright-langserver", "--stdio" },

	root_dir = function(bufnr, cb)
		local filename = vim.api.nvim_buf_get_name(bufnr)
		local start = vim.fs.dirname(filename)
		local root = vim.fs.root(start, {
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
		})
		if root then
			cb(root)
			return
		end

		local git = vim.fs.root(start, { ".git" })
		if git then
			cb(git)
			return
		end

		cb(start)
	end,

	settings = {
		pyright = {
			disableOrganizeImports = false,
		},
		python = {
			analysis = {
				typeCheckingMode = "standard",
				diagnosticMode = "openFilesOnly",
				autoImportCompletions = true,
				diagnosticSeverityOverrides = {
					reportUnusedImport = "error",
					reportUnusedVariable = "error",
					reportGenericTypeIssues = "error",
					reportOptionalMemberAccess = "warning",
					reportOptionalSubscription = "warning",
				},
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
			},
		},
	},
}
