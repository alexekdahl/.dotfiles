local M = {}

local diag_cache = { value = "", ts = 0 }
local mode_cache = { value = "n", ts = 0 }

local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_idx = 1
local spinner_timer = nil
local lsp_progress = {}

local DIAG_TTL = 100
local MODE_TTL = 50

local icons = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.INFO] = " ",
  [vim.diagnostic.severity.HINT] = "󰌵 ",
}

local mode_colors = {
  n = "%#SLineNormal#",
  i = "%#SLineInsert#",
  v = "%#SLineVisual#",
  V = "%#SLineVisual#",
  ["\22"] = "%#SLineVisual#",
  c = "%#SLineCommand#",
  t = "%#SLineCommand#",
  s = "%#SLineVisual#",
  S = "%#SLineVisual#",
  ["\19"] = "%#SLineVisual#",
  R = "%#SLineInsert#",
  r = "%#SLineInsert#",
  ["!"] = "%#SLineCommand#",
}

local default_color = "%#SLineNormal#"

local function get_diagnostics()
  local now = vim.loop.now()
  if now - diag_cache.ts < DIAG_TTL then
    return diag_cache.value
  end

  local diags = vim.diagnostic.get(vim.api.nvim_get_current_buf())
  if #diags == 0 then
    diag_cache.value = ""
    diag_cache.ts = now
    return ""
  end

  local counts = { 0, 0, 0, 0 }

  for _, d in ipairs(diags) do
    counts[d.severity] = counts[d.severity] + 1
  end

  local parts = {}
  for sev, count in pairs(counts) do
    if count > 0 then
      parts[#parts + 1] = icons[sev] .. count
    end
  end

  diag_cache.value = table.concat(parts, " ")
  diag_cache.ts = now
  return diag_cache.value
end

local function get_git_blame()
  local blame = vim.b.gitsigns_blame_line
  if blame and blame ~= "" then
    return blame
  end
  return ""
end

local function get_lsp_status()
  if vim.tbl_isempty(lsp_progress) then
    return ""
  end
  local names = {}
  for name in pairs(lsp_progress) do
    names[#names + 1] = name
  end
  return spinner_frames[spinner_idx] .. " " .. table.concat(names, ", ") .. " "
end

local function start_spinner()
  if spinner_timer then return end
  spinner_timer = vim.uv.new_timer()
  spinner_timer:start(0, 80, vim.schedule_wrap(function()
    spinner_idx = spinner_idx % #spinner_frames + 1
    vim.cmd.redrawstatus()
  end))
end

local function stop_spinner()
  if spinner_timer then
    spinner_timer:stop()
    spinner_timer:close()
    spinner_timer = nil
  end
end

function M.statusline()
  local now = vim.loop.now()

  -- Mode with TTL cache
  local mode
  if now - mode_cache.ts < MODE_TTL then
    mode = mode_cache.value
  else
    mode = vim.api.nvim_get_mode().mode
    mode_cache.value = mode
    mode_cache.ts = now
  end

  return table.concat({
    mode_colors[mode] or default_color,
    " %{toupper(expand('%:t'))} ",
    "%#Comment# ",
    get_git_blame(),
    "%=",
    "%#Comment#",
    get_lsp_status(),
    get_diagnostics(),
    " %p%% %l:%c ",
  })
end

local function setup()
  _G.statusline = M.statusline
  vim.o.statusline = "%!v:lua.statusline()"
  vim.o.laststatus = 3

  local grp = vim.api.nvim_create_augroup("StatuslineOptimized", { clear = true })

  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = grp,
    callback = function()
      diag_cache.ts = 0
    end,
  })

  vim.api.nvim_create_autocmd("ModeChanged", {
    group = grp,
    callback = function()
      mode_cache.ts = 0
      vim.defer_fn(vim.cmd.redrawstatus, 40)
    end,
  })

  vim.api.nvim_create_autocmd("LspProgress", {
    group = grp,
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then return end
      local kind = ev.data.params.value.kind
      if kind == "begin" then
        lsp_progress[client.name] = true
        start_spinner()
      elseif kind == "end" then
        lsp_progress[client.name] = nil
        if vim.tbl_isempty(lsp_progress) then
          stop_spinner()
          vim.cmd.redrawstatus()
        end
      end
    end,
  })
end

setup()
