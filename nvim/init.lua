vim.loader.enable()

-- Disable unused builtin plugins
local disabled = {
  "gzip", "matchit", "matchparen", "netrwPlugin",
  "tarPlugin", "tutor_mode_plugin", "zipPlugin", "spellfile_plugin",
  "man", "shada_plugin",
}
for _, p in ipairs(disabled) do
  vim.g["loaded_" .. p] = 1
end
vim.g.termfeatures = { osc52 = false }

require("options")
require("keymap")
require("autocmds")
require("custom.statusline")
