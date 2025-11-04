local M = {}

-- Cache store with TTLs
local cache = {
	diagnostics = { value = "", time = 0, ttl = 100 },
	mode = { value = "n", time = 0, ttl = 50 }, -- Cache mode with 50ms TTL
}

local function now()
	return vim.loop.now()
end

local function is_cache_valid(key)
	local c = cache[key]
	return c.value ~= "" and (now() - c.time) < c.ttl
end

-- Get cached mode with debouncing
local function get_cached_mode()
	if is_cache_valid("mode") then
		return cache.mode.value
	end

	local mode = vim.api.nvim_get_mode().mode
	cache.mode.value = mode
	cache.mode.time = now()
	return mode
end

-- Diagnostics with caching
local function get_diagnostics()
	if is_cache_valid("diagnostics") then
		return cache.diagnostics.value
	end

	local levels = {
		{ vim.diagnostic.severity.ERROR, " " },
		{ vim.diagnostic.severity.WARN, " " },
		{ vim.diagnostic.severity.INFO, " " },
		{ vim.diagnostic.severity.HINT, "󰌵 " },
	}

	local parts = {}
	local bufnr = vim.api.nvim_get_current_buf()

	for _, level in ipairs(levels) do
		local count = #vim.diagnostic.get(bufnr, { severity = level[1] })
		if count > 0 then
			table.insert(parts, level[2] .. count)
		end
	end

	cache.diagnostics.value = table.concat(parts, " ")
	cache.diagnostics.time = now()
	return cache.diagnostics.value
end

-- Git blame with aggressive caching and async support
local blame_cache = {}
local blame_timer = nil
local last_fetch_time = 0
local last_displayed_blame = ""
local DEBOUNCE_MS = 800

local function get_git_blame()
	local bufnr = vim.api.nvim_get_current_buf()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local cache_key = bufnr .. ":" .. line

	-- If we have fresh cached value for this exact line, use it
	if blame_cache[cache_key] then
		local cached = blame_cache[cache_key]
		if (now() - cached.time) < 5000 then
			last_displayed_blame = cached.value
			return cached.value
		end
	end

	-- Prevent fetching too frequently (global rate limit)
	if (now() - last_fetch_time) < DEBOUNCE_MS then
		-- Keep showing the last displayed blame while waiting
		return last_displayed_blame
	end

	-- Debounce: cancel previous timer
	if blame_timer then
		vim.loop.timer_stop(blame_timer)
		blame_timer = nil
	end

	-- Schedule async blame fetch
	blame_timer = vim.defer_fn(function()
		last_fetch_time = now()

		local file = vim.api.nvim_buf_get_name(bufnr)
		if file == "" or not vim.loop.fs_stat(file) then
			return
		end

		-- Run git blame asynchronously
		vim.system(
			{ "git", "blame", "-L", line .. "," .. line, "--porcelain", file },
			{ text = true },
			vim.schedule_wrap(function(result)
				if result.code ~= 0 then
					blame_cache[cache_key] = { value = "", time = now() }
					last_displayed_blame = ""
					vim.cmd("redrawstatus")
					return
				end

				local output = result.stdout
				local sha = output:match("^(%x+)")
				local author = output:match("author ([^\n]+)")
				local time_str = output:match("author%-time (%d+)")
				local summary = output:match("summary ([^\n]+)")

				if sha and author and time_str and summary then
					-- Shorten SHA to 7 characters
					sha = sha:sub(1, 7)
					-- Format date
					local date = os.date("%b %d %Y", tonumber(time_str))
					-- Format: <author> • <date> • <sha> • <summary>
					local formatted = string.format("%s • %s • %s • %s", author, date, sha, summary)

					blame_cache[cache_key] = { value = formatted, time = now() }
					last_displayed_blame = formatted
					vim.cmd("redrawstatus")
				end
			end)
		)
	end, DEBOUNCE_MS)

	-- Keep showing the last displayed blame while waiting for new data
	return last_displayed_blame
end

-- Trim blame cache to prevent memory leaks
local function trim_blame_cache()
	local count = 0
	for _ in pairs(blame_cache) do
		count = count + 1
	end

	if count > 50 then
		blame_cache = {}
	end
end

-- Build statusline
function M.statusline()
	local mode = get_cached_mode() -- Use cached mode
	local mode_map = {
		n = "%#SLineNormal#",
		i = "%#SLineInsert#",
		v = "%#SLineVisual#",
		V = "%#SLineVisual#",
		["\22"] = "%#SLineVisual#", -- <C-v> (block visual)
		c = "%#SLineCommand#",
		s = "%#SLineVisual#",
		S = "%#SLineVisual#",
		["\19"] = "%#SLineVisual#", -- <C-s>
		R = "%#SLineInsert#",
		r = "%#SLineInsert#",
		["!"] = "%#SLineCommand#",
		t = "%#SLineCommand#",
	}

	local color = mode_map[mode] or "%#SLineNormal#"

	return table.concat({
		color,
		" %t", -- filename (tail only)
		" ",
		"%#Comment#",
		" ",
		get_git_blame(),
		"%=", -- right align
		"%#Comment#",
		get_diagnostics(),
		" %p%% %l:%c ",
	}, "")
end

-- Setup function
function M.setup()
	-- Make function globally available
	_G.statusline = M.statusline

	-- Set statusline
	vim.o.statusline = "%!v:lua.statusline()"
	vim.o.laststatus = 3 -- global statusline

	-- Increase updatetime for less frequent CursorHold triggers
	vim.o.updatetime = 1000 -- 1 second

	-- Define highlight groups with force=true to override
	local bg = "#161716"
	vim.api.nvim_set_hl(0, "SLineNormal", { fg = "#aa749f", bg = bg, bold = true })
	vim.api.nvim_set_hl(0, "SLineInsert", { fg = "#89b4fa", bg = bg, bold = true })
	vim.api.nvim_set_hl(0, "SLineVisual", { fg = "#85b884", bg = bg, bold = true })
	vim.api.nvim_set_hl(0, "SLineCommand", { fg = "#f6ad6c", bg = bg, bold = true })

	-- Override default statusline highlights
	vim.api.nvim_set_hl(0, "StatusLine", { fg = "#525252", bg = bg, bold = true })
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#3a3a3a", bg = bg, bold = true })

	-- Efficient autocmds with grouped updates
	local group = vim.api.nvim_create_augroup("StatuslineOptimized", { clear = true })

	-- Update diagnostics on changes
	vim.api.nvim_create_autocmd("DiagnosticChanged", {
		group = group,
		callback = function()
			cache.diagnostics.time = 0 -- invalidate cache
			vim.cmd.redrawstatus()
		end,
	})

	-- Update blame on cursor hold (not on every move!)
	vim.api.nvim_create_autocmd("CursorHold", {
		group = group,
		callback = function()
			get_git_blame() -- trigger async fetch
		end,
	})

	-- Trim blame cache periodically
	vim.api.nvim_create_autocmd("BufDelete", {
		group = group,
		callback = trim_blame_cache,
	})

	-- Mode change updates with debouncing
	local mode_timer = nil
	vim.api.nvim_create_autocmd("ModeChanged", {
		group = group,
		callback = function()
			-- Cancel previous timer if exists
			if mode_timer then
				vim.loop.timer_stop(mode_timer)
				mode_timer = nil
			end

			-- Invalidate mode cache immediately
			cache.mode.time = 0

			-- Schedule redraw after a small delay
			mode_timer = vim.defer_fn(function()
				vim.cmd.redrawstatus()
				mode_timer = nil
			end, 50) -- 50ms delay
		end,
	})

	-- Re-apply highlights after colorscheme changes
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			vim.api.nvim_set_hl(0, "SLineNormal", { fg = "#aa749f", bg = bg })
			vim.api.nvim_set_hl(0, "SLineInsert", { fg = "#89b4fa", bg = bg })
			vim.api.nvim_set_hl(0, "SLineVisual", { fg = "#f5c2e7", bg = bg })
			vim.api.nvim_set_hl(0, "SLineCommand", { fg = "#fab387", bg = bg })
			vim.api.nvim_set_hl(0, "StatusLine", { fg = "#525252", bg = bg })
			vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#3a3a3a", bg = bg })
		end,
	})
end

return M
