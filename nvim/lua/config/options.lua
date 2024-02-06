local opt = vim.opt
local cmd = vim.cmd

opt.relativenumber = true
opt.hlsearch = false
opt.hidden = true
opt.errorbells = false
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.number = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
cmd.backupdir = os.getenv("HOME") .. "/.vim/undodir"
opt.incsearch = true
opt.scrolloff = 18
opt.isfname:append("@-@")
opt.cmdheight = 1
opt.updatetime = 50
opt.termguicolors = true
opt.shortmess:append("c")
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.splitbelow = true
opt.splitright = true
opt.cursorline = true
opt.signcolumn = "number"
opt.diffopt = { "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" }
opt.wrap = false
opt.colorcolumn = "100"
cmd.colorscheme("onedark")

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
set_cursorline("FileType", false, "TelescopePrompt")
