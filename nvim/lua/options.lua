local opt = vim.opt
local cmd = vim.cmd
local global = vim.g

global.mapleader = " "
global.maplocalleader = " "
global.editorconfig = true
global.background = "dark"
global.lsp_autostart = true

opt.relativenumber = true
opt.showmode = false
opt.hlsearch = false
opt.hidden = true
opt.errorbells = false
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.smartindent = true
opt.number = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.incsearch = true
opt.scrolloff = 18
opt.isfname:append("@-@")
opt.cmdheight = 0
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

cmd.backupdir = os.getenv("HOME") .. "/.vim/undodir"
cmd.colorscheme("tachyon")

vim.diagnostic.config({ signs = false })
