local M = {}

-- Pre-allocate and reuse tables to reduce GC pressure
local diag_parts = {}
local statusline_parts = {}

-- Flatten cache structure and use numeric indices for faster access
local cache_diag_value = ""
local cache_diag_time = 0
local cache_mode_value = "n"
local cache_mode_time = 0

-- Pre-compute constants
local DIAG_TTL = 100
local MODE_TTL = 50
local BLAME_TTL = 5000
local DEBOUNCE_MS = 800
local MAX_BLAME_ENTRIES = 50

-- Use locals for frequently accessed functions
local vim_loop_now = vim.loop.now
local vim_diagnostic_get = vim.diagnostic.get
local vim_api_nvim_get_current_buf = vim.api.nvim_get_current_buf
local vim_api_nvim_get_mode = vim.api.nvim_get_mode
local vim_api_nvim_win_get_cursor = vim.api.nvim_win_get_cursor
local vim_api_nvim_buf_get_name = vim.api.nvim_buf_get_name
local string_format = string.format
local table_concat = table.concat

-- Pre-define diagnostic levels with icons (avoid recreating)
local DIAG_ERROR = vim.diagnostic.severity.ERROR
local DIAG_WARN = vim.diagnostic.severity.WARN
local DIAG_INFO = vim.diagnostic.severity.INFO
local DIAG_HINT = vim.diagnostic.severity.HINT
local DIAG_ICONS = { " ", " ", " ", "󰌵 " }

-- Git blame state
local blame_cache = {}
local blame_timer = nil
local last_fetch_time = 0
local last_displayed_blame = ""
local blame_cache_count = 0

-- Pre-computed mode color map (faster lookup)
local MODE_COLORS = {
	n = "%#SLineNormal#",
	i = "%#SLineInsert#",
	v = "%#SLineVisual#",
	V = "%#SLineVisual#",
	["\22"] = "%#SLineVisual#",
	c = "%#SLineCommand#",
	s = "%#SLineVisual#",
	S = "%#SLineVisual#",
	["\19"] = "%#SLineVisual#",
	R = "%#SLineInsert#",
	r = "%#SLineInsert#",
	["!"] = "%#SLineCommand#",
	t = "%#SLineCommand#",
}
local DEFAULT_COLOR = "%#SLineNormal#"

-- Optimized diagnostics function
local function get_diagnostics()
	local now = vim_loop_now()
	if cache_diag_value ~= "" and (now - cache_diag_time) < DIAG_TTL then
		return cache_diag_value
	end

	-- Clear parts table instead of creating new one
	for i = 1, #diag_parts do
		diag_parts[i] = nil
	end

	local bufnr = vim_api_nvim_get_current_buf()
	local part_count = 0

	-- Unrolled loop for better performance
	local count = #vim_diagnostic_get(bufnr, { severity = DIAG_ERROR })
	if count > 0 then
		part_count = part_count + 1
		diag_parts[part_count] = DIAG_ICONS[1] .. count
	end

	count = #vim_diagnostic_get(bufnr, { severity = DIAG_WARN })
	if count > 0 then
		part_count = part_count + 1
		diag_parts[part_count] = DIAG_ICONS[2] .. count
	end

	count = #vim_diagnostic_get(bufnr, { severity = DIAG_INFO })
	if count > 0 then
		part_count = part_count + 1
		diag_parts[part_count] = DIAG_ICONS[3] .. count
	end

	count = #vim_diagnostic_get(bufnr, { severity = DIAG_HINT })
	if count > 0 then
		part_count = part_count + 1
		diag_parts[part_count] = DIAG_ICONS[4] .. count
	end

	cache_diag_value = part_count > 0 and table_concat(diag_parts, " ", 1, part_count) or ""
	cache_diag_time = now
	return cache_diag_value
end

-- Optimized git blame function
local function get_git_blame()
	local bufnr = vim_api_nvim_get_current_buf()
	local line = vim_api_nvim_win_get_cursor(0)[1]
	local cache_key = bufnr * 100000 + line -- Numeric key is faster

	local cached = blame_cache[cache_key]
	if cached then
		local now = vim_loop_now()
		if (now - cached.t) < BLAME_TTL then
			last_displayed_blame = cached.v
			return cached.v
		end
	end

	local now = vim_loop_now()
	if (now - last_fetch_time) < DEBOUNCE_MS then
		return last_displayed_blame
	end

	if blame_timer then
		vim.loop.timer_stop(blame_timer)
		blame_timer = nil
	end

	blame_timer = vim.defer_fn(function()
		last_fetch_time = vim_loop_now()

		local file = vim_api_nvim_buf_get_name(bufnr)
		if file == "" then
			return
		end

		-- Faster file check
		local stat = vim.loop.fs_stat(file)
		if not stat or not stat.type == "file" then
			return
		end

		vim.system(
			{ "git", "blame", "-L", line .. "," .. line, "--porcelain", file },
			{ text = true },
			vim.schedule_wrap(function(result)
				if result.code ~= 0 then
					blame_cache[cache_key] = { v = "", t = vim_loop_now() }
					last_displayed_blame = ""
					vim.cmd("redrawstatus")
					return
				end

				local output = result.stdout
				-- Use single pattern match for efficiency
				local sha, author, time_str, summary =
					output:match("^(%x+).-\nauthor ([^\n]+).-\nauthor%-time (%d+).-\nsummary ([^\n]+)")

				if sha and author and time_str and summary then
					local formatted = string_format(
						"%s • %s • %s • %s",
						author,
						os.date("%b %d %Y", tonumber(time_str)),
						sha:sub(1, 7),
						summary
					)

					blame_cache[cache_key] = { v = formatted, t = vim_loop_now() }
					last_displayed_blame = formatted
					blame_cache_count = blame_cache_count + 1

					-- Trim cache if needed
					if blame_cache_count > MAX_BLAME_ENTRIES then
						blame_cache = {}
						blame_cache_count = 0
					end

					vim.cmd("redrawstatus")
				end
			end)
		)
	end, DEBOUNCE_MS)

	return last_displayed_blame
end

-- Main statusline function - optimized for minimal allocations
function M.statusline()
	local now = vim_loop_now()

	-- Get mode with cache
	local mode
	if cache_mode_value ~= "" and (now - cache_mode_time) < MODE_TTL then
		mode = cache_mode_value
	else
		mode = vim_api_nvim_get_mode().mode
		cache_mode_value = mode
		cache_mode_time = now
	end

	-- Build statusline with pre-allocated table
	statusline_parts[1] = MODE_COLORS[mode] or DEFAULT_COLOR
	statusline_parts[2] = " %t "
	statusline_parts[3] = "%#Comment#"
	statusline_parts[4] = " "
	statusline_parts[5] = get_git_blame()
	statusline_parts[6] = "%="
	statusline_parts[7] = "%#Comment#"
	statusline_parts[8] = get_diagnostics()
	statusline_parts[9] = " %p%% %l:%c "

	return table_concat(statusline_parts, "", 1, 9)
end

-- Setup function
local function setup()
	_G.statusline = M.statusline
	vim.o.statusline = "%!v:lua.statusline()"
	vim.o.laststatus = 3
	vim.o.updatetime = 1000

	-- Batch highlight settings
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

	-- Single augroup for all autocmds
	local group = vim.api.nvim_create_augroup("StatuslineOptimized", { clear = true })

	-- Combine related autocmds
	vim.api.nvim_create_autocmd("DiagnosticChanged", {
		group = group,
		callback = function()
			cache_diag_time = 0
			vim.cmd.redrawstatus()
		end,
	})

	vim.api.nvim_create_autocmd("CursorHold", {
		group = group,
		callback = get_git_blame,
	})

	-- Simplified mode change handler
	vim.api.nvim_create_autocmd("ModeChanged", {
		group = group,
		callback = function()
			cache_mode_time = 0
			vim.defer_fn(vim.cmd.redrawstatus, 50)
		end,
	})

	-- ColorScheme handler with cached highlight definitions
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			for _, hl in ipairs(hls) do
				vim.api.nvim_set_hl(0, hl[1], hl[2])
			end
		end,
	})
end

setup()
