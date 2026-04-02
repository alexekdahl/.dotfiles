vim.loader.enable()

-- Disable unused builtin plugins
local disabled = {
  "gzip", "matchit", "matchparen", "netrw", "netrwPlugin",
  "tarPlugin", "tohtml", "tutor", "zipPlugin", "spellfile",
  "man", "shada", "osc52",
}
for _, p in ipairs(disabled) do
  vim.g["loaded_" .. p] = 1
end

require("options")
require("keymap")
require("autocmds")

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end
})
