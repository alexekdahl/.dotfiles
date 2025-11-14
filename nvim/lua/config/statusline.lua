local M = {}

local diag_cache = { value = "", ts = 0 }
local mode_cache = { value = "n", ts = 0 }
local blame_cache = {}
local last_blame = ""
local last_blame_ts = 0
local blame_timer

local DIAG_TTL = 100
local MODE_TTL = 50
local BLAME_TTL = 5000
local DEBOUNCE = 800
local MAX_BLAME = 50

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

local function parse_blame(output)
	local sha, author, time_str, summary
	for line in output:gmatch("[^\n]+") do
		sha = sha or line:match("^(%x+)")
		author = author or line:match("^author%s+(.*)")
		time_str = time_str or line:match("^author%-time%s+(%d+)")
		summary = summary or line:match("^summary%s+(.*)")
	end
	if not (sha and author and time_str and summary) then
		return ""
	end

	return string.format(
		"%s • %s • %s • %s",
		author,
		vim.fn.strftime("%b %d %Y", tonumber(time_str)),
		sha:sub(1, 7),
		summary
	)
end

local function get_git_blame()
	local bufnr = vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return ""
	end

	local file = vim.api.nvim_buf_get_name(bufnr)
	if file == "" or vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "" then
		return ""
	end

	local line = vim.api.nvim_win_get_cursor(0)[1]
	local key = bufnr * 100000 + line
	local now = vim.loop.now()

	-- Cache hit
	local cached = blame_cache[key]
	if cached and now - cached.ts < BLAME_TTL then
		last_blame = cached.val
		return cached.val
	end

	-- Too soon to run again
	if now - last_blame_ts < DEBOUNCE then
		return last_blame
	end

	-- Debounce git call
	if blame_timer then
		blame_timer:stop()
		blame_timer = nil
	end

	blame_timer = vim.defer_fn(function()
		last_blame_ts = vim.loop.now()

		vim.system(
			{ "git", "blame", "-L", line .. "," .. line, "--porcelain", file },
			{ text = true },
			vim.schedule_wrap(function(result)
				if result.code ~= 0 then
					blame_cache[key] = { val = "", ts = vim.loop.now() }
					last_blame = ""
					vim.cmd("redrawstatus")
					return
				end

				local formatted = parse_blame(result.stdout) or ""
				blame_cache[key] = { val = formatted, ts = vim.loop.now() }
				last_blame = formatted

				if vim.tbl_count(blame_cache) > MAX_BLAME then
					blame_cache = {}
				end

				vim.cmd("redrawstatus")
			end)
		)
	end, DEBOUNCE)

	return last_blame
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
		get_diagnostics(),
		" %p%% %l:%c ",
	})
end

local function setup()
	_G.statusline = M.statusline
	vim.o.statusline = "%!v:lua.statusline()"
	vim.o.laststatus = 3

	local bg = "#161716"
	local hls = {
		{ "SLineNormal", { fg = "#aa749f", bg = bg, bold = true } },
		{ "SLineInsert", { fg = "#89b4fa", bg = bg, bold = true } },
		{ "SLineVisual", { fg = "#85b884", bg = bg, bold = true } },
		{ "SLineCommand", { fg = "#f6ad6c", bg = bg, bold = true } },
		{ "StatusLine", { fg = "#525252", bg = bg, bold = true } },
		{ "StatusLineNC", { fg = "#3a3a3a", bg = bg, bold = true } },
	}

	for _, hl in ipairs(hls) do
		vim.api.nvim_set_hl(0, hl[1], hl[2])
	end

	local grp = vim.api.nvim_create_augroup("StatuslineOptimized", { clear = true })

	vim.api.nvim_create_autocmd("DiagnosticChanged", {
		group = grp,
		callback = function()
			diag_cache.ts = 0
		end,
	})

	vim.api.nvim_create_autocmd("CursorHold", {
		group = grp,
		callback = get_git_blame,
	})

	vim.api.nvim_create_autocmd("ModeChanged", {
		group = grp,
		callback = function()
			mode_cache.ts = 0
			vim.defer_fn(vim.cmd.redrawstatus, 40)
		end,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = grp,
		callback = function()
			for _, hl in ipairs(hls) do
				vim.api.nvim_set_hl(0, hl[1], hl[2])
			end
		end,
	})
end

setup()
