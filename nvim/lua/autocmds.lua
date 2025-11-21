local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function keys(str)
  return vim.api.nvim_replace_termcodes(str, true, false, true)
end

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    local pairs = {
      ["("] = { close = ")", inside = false },
      ["["] = { close = "]", inside = true },
      ["{"] = { close = "}", inside = true },
    }

    local ns = vim.api.nvim_create_namespace("my_autopairs")

    vim.on_key(function(ch)
      if vim.fn.mode() ~= "i" then return end

      local p = pairs[ch]
      if not p then return end

      -- Insert closing character
      vim.api.nvim_feedkeys(p.close, "n", false)

      -- Move cursor inside if needed
      if p.inside then
        vim.schedule(function()
          vim.api.nvim_feedkeys(keys("<Left>"), "n", false)
        end)
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
