local M = {}

local state = {
  active = false,
  left = nil,
  right = nil,
  content = nil,
  augroup = nil,
  width = 120,
}

local function is_win_valid(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function create_pad_buf()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = "zen_pad"
  return buf
end

local function set_pad_opts(win)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].cursorline = false
  vim.wo[win].colorcolumn = ""
  vim.wo[win].statusline = " "
  vim.wo[win].winfixwidth = true
  vim.wo[win].fillchars = "eob: "
  vim.wo[win].winhighlight = "Normal:Normal,NormalNC:Normal"
end

local function calc_pad_width()
  local total = vim.o.columns
  local pad = math.floor((total - state.width) / 2)
  return math.max(pad, 1)
end

local function close_pads()
  for _, key in ipairs({ "left", "right" }) do
    local win = state[key]
    if is_win_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      -- last window can't be closed via nvim_win_close; wipe its buffer instead
      if #vim.api.nvim_list_wins() == 1 then
        vim.api.nvim_buf_delete(buf, { force = true })
      else
        vim.api.nvim_win_close(win, true)
      end
    end
    state[key] = nil
  end
end

local function cleanup()
  close_pads()
  if state.augroup then
    vim.api.nvim_del_augroup_by_id(state.augroup)
    state.augroup = nil
  end
  state.active = false
  state.content = nil
end

local function open()
  if state.active then return end

  -- only works with a single window
  if #vim.api.nvim_tabpage_list_wins(0) > 1 then
    vim.notify("zen: close other splits first", vim.log.levels.WARN)
    return
  end

  state.content = vim.api.nvim_get_current_win()
  local pad_w = calc_pad_width()

  -- left pad
  vim.cmd("topleft vsplit")
  state.left = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(state.left, create_pad_buf())
  vim.api.nvim_win_set_width(state.left, pad_w)
  set_pad_opts(state.left)

  -- return to content
  vim.api.nvim_set_current_win(state.content)

  -- right pad
  vim.cmd("botright vsplit")
  state.right = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(state.right, create_pad_buf())
  vim.api.nvim_win_set_width(state.right, pad_w)
  set_pad_opts(state.right)

  -- return to content
  vim.api.nvim_set_current_win(state.content)

  state.active = true
  state.augroup = vim.api.nvim_create_augroup("zen", { clear = true })

  -- resize pads on terminal resize
  vim.api.nvim_create_autocmd("VimResized", {
    group = state.augroup,
    callback = function()
      if not state.active then return end
      local w = calc_pad_width()
      if is_win_valid(state.left) then vim.api.nvim_win_set_width(state.left, w) end
      if is_win_valid(state.right) then vim.api.nvim_win_set_width(state.right, w) end
    end,
  })

  -- if user enters a pad window, bounce back to content
  vim.api.nvim_create_autocmd("WinEnter", {
    group = state.augroup,
    callback = function()
      if not state.active then return end
      local cur = vim.api.nvim_get_current_win()
      if (cur == state.left or cur == state.right) and is_win_valid(state.content) then
        vim.api.nvim_set_current_win(state.content)
      end
    end,
  })

  -- if any zen window gets closed, tear down and quit if content was closed
  vim.api.nvim_create_autocmd("WinClosed", {
    group = state.augroup,
    callback = function(ev)
      if not state.active then return end
      local closed = tonumber(ev.match)
      if closed == state.content then
        vim.schedule(function()
          close_pads()
          if state.augroup then
            vim.api.nvim_del_augroup_by_id(state.augroup)
            state.augroup = nil
          end
          state.active = false
          state.content = nil
          -- quit if only empty pad buffers remain
          local remaining = vim.api.nvim_list_wins()
          if #remaining <= 1 then
            vim.cmd("qa!")
          end
        end)
      elseif closed == state.left or closed == state.right then
        vim.schedule(cleanup)
      end
    end,
  })
end

function M.toggle()
  if state.active then
    cleanup()
  else
    open()
  end
end

return M
