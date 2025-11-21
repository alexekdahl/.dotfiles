local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd("InsertCharPre", {
  callback = function()
    local char = vim.v.char

    -- ( ) → cursor AFTER closing
    if char == "(" then
      vim.v.char = "()"                        -- replace typed char
      vim.schedule(function()
        vim.api.nvim_feedkeys("l", "n", false) -- move right into after ')'
      end)
      return
    end

    -- { } → cursor INSIDE
    if char == "{" then
      vim.v.char = "{}"
      vim.schedule(function()
        vim.api.nvim_feedkeys("ha", "n", false) -- move left + insert
      end)
      return
    end

    -- [ ] → cursor INSIDE
    if char == "[" then
      vim.v.char = "[]"
      vim.schedule(function()
        vim.api.nvim_feedkeys("ha", "n", false)
      end)
      return
    end
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
