local should_disable = require("util.disable").should_disable

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

		-- Format with gopls if available
		if not vim.tbl_isempty(gopls) then
			vim.lsp.buf.format({ name = "gopls", async = true })
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

-- Disables copilot if in a disabled folder
local copilot_group = vim.api.nvim_create_augroup("CopilotDisable", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
	group = copilot_group,
	callback = function()
		local current_dir = vim.fn.getcwd()
		local disabled_folders = vim.env.DISABLED_COPILOT
		if should_disable(current_dir, disabled_folders) then
			vim.cmd("Copilot disable")
		end
	end,
})

local copilot_on = true
vim.api.nvim_create_user_command("CopilotToggle", function()
	if copilot_on then
		vim.cmd("Copilot disable")
		print("Copilot OFF")
	else
		vim.cmd("Copilot enable")
		print("Copilot ON")
	end
	copilot_on = not copilot_on
end, { nargs = 0 })

set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)
set_cursorline("FileType", false, "TelescopePrompt")
