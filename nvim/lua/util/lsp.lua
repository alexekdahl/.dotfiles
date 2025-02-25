local autocmd_clear = vim.api.nvim_clear_autocmds
local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
local mapkey = require("util.keymapper").mapkey

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

local M = {}

-- set keymaps on the active lsp server
M.on_attach = function(client, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
	client.server_capabilities.document_formatting = true

	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	mapkey("<leader>r", vim.lsp.buf.rename, "n", bufopts)

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		autocmd_clear({ group = augroup_highlight, buffer = bufnr })
		autocmd({ "CursorHold", augroup_highlight, vim.lsp.buf.document_highlight, bufnr })
		autocmd({ "CursorMoved", augroup_highlight, vim.lsp.buf.clear_references, bufnr })
	end
end

M.handlers = {
	["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { signs = false }),
}

return M
