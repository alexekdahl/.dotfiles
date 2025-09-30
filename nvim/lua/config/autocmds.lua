-- Auto-format on save
local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = lsp_fmt_group,
	callback = function(args)
		local bufnr = args.buf
		local ft = vim.bo[bufnr].filetype

		local preferred = {
			go = "gopls",
			nim = "nim_langserver",
			lua = "efm",
			python = "efm",
			rust = "rust_analyzer",
		}

		local want = preferred[ft]
		if not want then
			return
		end

		-- Only look at clients attached to this buffer
		local clients = vim.lsp.get_clients({ bufnr = bufnr })
		local available = vim.tbl_filter(function(c)
			return c.name == want
				and (
					c.server_capabilities.documentFormattingProvider
					or c.server_capabilities.documentRangeFormattingProvider
				)
		end, clients)

		if vim.tbl_isempty(available) then
			return
		end

		vim.lsp.buf.format({
			bufnr = bufnr,
			async = false,
			filter = function(c)
				return c.name == want
			end,
		})
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
