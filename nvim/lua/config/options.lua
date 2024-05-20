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
