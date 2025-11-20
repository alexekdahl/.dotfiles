local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("InsertEnter", {
  once = true,
  callback = function()
    local pairs = { ["("] = ")", ["["] = "]", ["{"] = "}", }
    local ns = vim.api.nvim_create_namespace("my_autopairs")

    vim.on_key(function(ch)
      if vim.fn.mode() == "i" then
        local r = pairs[ch]
        if r then vim.api.nvim_feedkeys(r, "n", false) end
      end
    end, ns)
  end,
})

local grp_cursor = augroup("CursorLineControl", { clear = true })
local function set_cursorline(event, value)
  autocmd(event, {
    group = grp_cursor,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end

set_cursorline("WinEnter", true)
set_cursorline("WinLeave", false)
