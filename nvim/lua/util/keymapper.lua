local vim_modes = {
	n = "n",
	i = "i",
	v = "v",
}

local default_opts = {
	noremap = true,
	silent = true,
}

local get_opts = function(opts)
	local all_opts = opts or {}
	for k, v in pairs(default_opts) do
		all_opts[k] = all_opts[k] or v
	end
	return all_opts
end

local get_mode = function(vimmode)
	return vim_modes[vimmode] or "n"
end

local get_cmd_string = function(command)
	return type(command) == "function" and command or ("<cmd>" .. command .. "<CR>")
end

local mapkey = function(keymaps, command, vimmode, options)
	local mode = get_mode(vimmode)
	local lhs = keymaps
	local rhs = get_cmd_string(command)
	local opts = get_opts(options)
	vim.keymap.set(mode, lhs, rhs, opts)
end

return { mapkey = mapkey }
