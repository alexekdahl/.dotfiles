local M = {}
local function float_input(opts, on_confirm)
  if type(opts) ~= "table" then
    opts = {}
  end

  local prompt  = opts.prompt or ""
  local default = opts.default or ""
  local buf     = vim.api.nvim_create_buf(false, true)
  local width   = opts.width or math.floor(vim.o.columns * 0.35)
  local height  = 1

  -- Ensure border is always valid
  local border  = opts.border
  if border == nil or border == true then
    border = "rounded"
  elseif border == false then
    border = "none"
  end

  -- Create floating window config as a separate table
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor(vim.o.lines * 0.3),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = border,
    title = prompt,
    title_pos = "center",
    noautocmd = true,
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { default })

  -- Insert mode
  vim.cmd("startinsert")

  -- Confirm input
  vim.keymap.set("i", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    vim.cmd("stopinsert")
    pcall(vim.api.nvim_win_close, win, true)
    on_confirm(line)
  end, { buffer = buf })

  -- Cancel
  vim.keymap.set("i", "<Esc>", function()
    vim.cmd("stopinsert")
    pcall(vim.api.nvim_win_close, win, true)
    on_confirm(nil)
  end, { buffer = buf })
end

function M.smart_replace()
  float_input({ prompt = " : Search" }, function(search)
    if not search or search == "" then return end
    float_input({ prompt = "󰛔 : Replace ", default = "" }, function(replace)
      if replace == nil then return end
      float_input({ prompt = "Scope", default = "%" }, function(scope)
        scope = (scope == nil or scope == "") and "%" or scope
        local cmd = string.format(
          "%ss/%s/%s/g",
          scope,
          vim.fn.escape(search, "/\\"),
          vim.fn.escape(replace, "/\\")
        )
        vim.cmd(cmd)
      end)
    end)
  end)
end

return M
