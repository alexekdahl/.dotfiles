local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function keys(str)
  return vim.api.nvim_replace_termcodes(str, true, false, true)
end

autocmd("InsertEnter", {
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

vim.opt.cmdheight = 0
autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
  group = augroup("cmdline-auto-hide", { clear = true }),
  callback = function(args)
    local entering = args.event == "CmdlineEnter"
    local target_height = entering and 1 or 0
    if vim.opt_local.cmdheight:get() ~= target_height then
      vim.opt_local.cmdheight = target_height
    end
    vim.o.laststatus = entering and 0 or 3
    vim.cmd.redrawstatus()
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
