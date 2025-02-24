-- Auto-format on save
local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	group = lsp_fmt_group,
	callback = function()
		-- Get active clients for both efm and gopls
		local efm = vim.lsp.get_active_clients({ name = "efm" })
		local gopls = vim.lsp.get_active_clients({ name = "gopls" })
		local nim_langserver = vim.lsp.get_active_clients({ name = "nim_langserver" })

		-- Check if both efm and gopls are not active, then return
		if vim.tbl_isempty(efm) and vim.tbl_isempty(gopls) then
			return
		end

		-- Format with gopls if available
		if not vim.tbl_isempty(gopls) then
			vim.lsp.buf.format({ name = "gopls", async = true })
		end

		-- Format with gopls if available
		if not vim.tbl_isempty(nim_langserver) then
            print("Formatting with nim_langserver")
			vim.lsp.buf.format({ name = "nim_langserver", async = true })
		end

		-- Format with efm if available
		if not vim.tbl_isempty(efm) then
			vim.lsp.buf.format({ name = "efm", async = true })
		end
	end,
})

local filetype_group = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })
-- Disable colorcolumn for Markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	group = filetype_group,
	pattern = { "markdown", "text" },
	command = "setlocal colorcolumn=",
})

-- Cursorline highlighting control
--  Only have it on in the active buffer
local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
	vim.api.nvim_create_autocmd(event, {
		group = group,
		pattern = pattern,
		callback = function()
			vim.opt_local.cursorline = value
		end,
	})
end

set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
