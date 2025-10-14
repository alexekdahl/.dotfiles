local lazyrepo = "https://github.com/folke/lazy.nvim.git"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local plugins = "plugins"

local opts = {
	defaults = { lazy = false },
	ui = {
        backdrop = 100,
        border = "rounded", -- or "single", "double", "shadow", "none"
    },
	performance = {
		cache = { enabled = true },
		reset_packpath = true,
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrw",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				"spellfile",
			},
		},
	},
	change_detection = { notify = false },
}
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("config.globals")
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("lazy").setup(plugins, opts)
