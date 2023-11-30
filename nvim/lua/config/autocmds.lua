-- Auto-format on save
local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = lsp_fmt_group,
	callback = function()
		-- Get active clients for both efm and gopls
		local efm = vim.lsp.get_active_clients({ name = "efm" })
		local gopls = vim.lsp.get_active_clients({ name = "gopls" })

		-- Check if both efm and gopls are not active, then return
		if vim.tbl_isempty(efm) and vim.tbl_isempty(gopls) then
			return
		end

		-- Format with efm if available
		if not vim.tbl_isempty(efm) then
			vim.lsp.buf.format({ name = "efm", async = true })
		end

		-- Format with gopls if available
		if not vim.tbl_isempty(gopls) then
			vim.lsp.buf.format({ name = "gopls", async = true })
		end
	end,
})
