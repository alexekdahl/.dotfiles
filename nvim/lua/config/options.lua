local opt = vim.opt
local cmd = vim.cmd

opt.relativenumber = true -- Displays relative line numbers
opt.hlsearch = false -- Disables search highlighting
opt.hidden = true -- Allows unsaved buffers to be hidden
opt.errorbells = false -- Disables error bells
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.number = true -- Enables line numbers
opt.swapfile = false -- Disables swap file creation
opt.backup = false -- Disables backup file creation
opt.undofile = true -- Sets undo directory
cmd.backupdir = os.getenv("HOME") .. "/.vim/undodir"
opt.incsearch = true -- Enables incremental search
opt.scrolloff = 18 -- Keeps 18 lines visible above/below cursor
opt.isfname:append("@-@") -- Adds '@-@' to 'isfname' option
opt.cmdheight = 1 -- Sets command line height to 1
opt.updatetime = 50 -- Sets buffer update time to 50 ms
opt.termguicolors = true -- Enables terminal GUI colors
opt.shortmess:append("c") -- Shortens certain messages
opt.clipboard = "unnamedplus" -- Uses the unnamed clipboard
opt.completeopt = "menu,menuone,noselect" -- Configures completion options
opt.splitbelow = true -- Opens horizontal splits below
opt.splitright = true -- Opens vertical splits to the right
opt.cursorline = true -- Highlights the current line
opt.signcolumn = "number" -- Highlights the current line
opt.diffopt = { "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" }
opt.wrap = false
opt.colorcolumn = "100"

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
