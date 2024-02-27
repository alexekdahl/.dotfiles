local autocmd_clear = vim.api.nvim_clear_autocmds
local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
local mapkey = require("util.keymapper").mapkey
local cmd = require("util.key_cmd")

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
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	client.server_capabilities.document_formatting = true

	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	mapkey("gd", cmd.lsp_goto_definition, "n", bufopts)
	mapkey("gD", cmd.lsp_peek_definition, "n", bufopts)
	mapkey("gt", cmd.lsp_goto_type_definition, "n", bufopts)
	mapkey("K", cmd.lsp_show_hover_doc, "n", bufopts)
	mapkey("<leader>r", cmd.lsp_rename_symbol, "n", bufopts)
	mapkey("<leader>k", cmd.lsp_open_diagnostic_float, "n", bufopts)
	mapkey("<leader>a", cmd.lsp_code_action, "n", bufopts)
	mapkey("<leader>p", cmd.lsp_show_outline, "n", bufopts)
	mapkey("<leader>lf", cmd.lsp_show_finder, "n", bufopts)

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
