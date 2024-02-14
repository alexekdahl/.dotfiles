local autocmd_clear = vim.api.nvim_clear_autocmds
local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })

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

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>", bufopts)
	vim.keymap.set("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>", bufopts)
	vim.keymap.set("n", "K", "<cmd> Lspsaga hover_doc<CR>", bufopts)
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, bufopts)
	vim.keymap.set("n", "<leader>a", "<cmd> Lspsaga code_action<CR>", bufopts)
	vim.keymap.set("n", "<leader>p", "<cmd> Lspsaga outline<CR>", bufopts)
	vim.keymap.set("n", "<leader>lf", "<cmd> Lspsaga finder tyd+ref+imp+def<CR>", bufopts)

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.documentHighlightProvider then
		autocmd_clear({ group = augroup_highlight, buffer = bufnr })
		autocmd({ "CursorHold", augroup_highlight, vim.lsp.buf.document_highlight, bufnr })
		autocmd({ "CursorMoved", augroup_highlight, vim.lsp.buf.clear_references, bufnr })
	end

	if client.name == "pyright" then
		vim.keymap.set("n", "<leader>l", 'y<esc>oprint("\\x1b[33m<c-r>"->", <c-r>", "\\x1b[0m")<esc>', bufopts)
	elseif client.name == "gopls" then
		vim.keymap.set("n", "<leader>l", 'y<esc>ofmt.Println("\\x1b[33m<c-r>"->", <c-r>", "\\x1b[0m")<esc>', bufopts)
	elseif client.name == "tsserver" then
		vim.keymap.set("n", "<leader>l", 'y<esc>oconsole.log("\\x1b[33m<c-r>"->", <c-r>", "\\x1b[0m")<esc>', bufopts)
	end
end

M.handlers = {
	["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { signs = false }),
}

M.diagnostic_signs = {
	Error = " ",
	Warn = " ",
	Hint = "ﴞ ",
	Info = "",
}

return M
