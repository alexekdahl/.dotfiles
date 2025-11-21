local M = {}

local function vim_navigate(direction)
  -- returns true if we actually changed window
  local before = vim.api.nvim_get_current_win()
  local ok = pcall(vim.cmd, "wincmd " .. direction)
  if not ok then
    -- match original behavior a bit: show friendly message on error
    vim.api.nvim_echo({
      { "E11: Invalid in command-line window; <CR> executes, CTRL-C quits: wincmd " .. direction, "ErrorMsg" },
    }, false, {})
    return false
  end
  local after = vim.api.nvim_get_current_win()
  return before ~= after
end

local function tmux_executable()
  local tmux_env = os.getenv("TMUX") or ""
  if tmux_env:match("tmate") then
    return "tmate"
  else
    return "tmux"
  end
end

local function tmux_socket()
  -- $TMUX is "socket,client,tty"
  local tmux_env = os.getenv("TMUX") or ""
  return tmux_env:match("([^,]+)")
end

local function tmux_command(args)
  local socket = tmux_socket()
  if not socket or socket == "" then
    return
  end
  local exe = tmux_executable()
  -- use -S <socket> like the original plugin
  local cmd = string.format("%s -S %q %s", exe, socket, args)
  os.execute(cmd)
end

function M.navigate(direction)
  local tmux = os.getenv("TMUX")
  if not tmux or tmux == "" then
    -- Not inside tmux: only do Vim navigation
    vim_navigate(direction)
    return
  end

  -- Try moving inside Vim first
  local moved_in_vim = vim_navigate(direction)
  if moved_in_vim then
    return
  end

  -- If we couldn't move in Vim, forward to tmux
  local pane = os.getenv("TMUX_PANE")
  local tmux_map = { h = "L", j = "D", k = "U", l = "R" }
  local flag = tmux_map[direction]
  if not flag then
    return
  end

  local args
  if pane and pane ~= "" then
    args = string.format("select-pane -t %q -%s", pane, flag)
  else
    -- fallback without explicit -t (less reliable, but better than nothing)
    args = string.format("select-pane -%s", flag)
  end
  tmux_command(args)
end

return M
