local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Cursorline only in active window
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
