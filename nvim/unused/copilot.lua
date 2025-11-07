local function should_disable(current_dir, disabled_folders)
	disabled_folders = disabled_folders or ""
	for folder in string.gmatch(disabled_folders, "([^,]+)") do
		-- Check if the current directory path contains the disabled folder path
		if string.find(current_dir, folder, 1, true) then
			return true
		end
	end
	return false
end

return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	enabled = false,
	cond = function()
		local current_dir = vim.fn.getcwd()
		local ONPREM_REPO = vim.env.ONPREM_REPO or ""
		return not should_disable(current_dir, ONPREM_REPO)
	end,
	opts = {
		server = {
			type = "binary",
			custom_server_filepath = nil,
		},
		server_opts_overrides = {
			settings = {
				advanced = {
					inlineSuggestCount = 1,
				},
				telemetry = {
					telemetryLevel = "off",
				},
			},
		},
		panel = {
			enabled = false,
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			debounce = 75,
			keymap = {
				accept = false,
				accept_word = false,
				accept_line = false,
				next = "<M-v>",
				prev = "<M-c>",
				dismiss = "<C-e>",
			},
		},
		filetypes = {
			["*"] = true,
			python = true,
			go = true,
			yaml = true,
			lua = true,
			nim = true,
			rust = true,
			gitcommit = true,
			sh = function()
				if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
					return false
				end
				return true
			end,
		},
	},
	config = function(_, opts)
		require("copilot").setup(opts)
		vim.keymap.set("i", "<Tab>", function()
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").accept()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
			end
		end, {
			silent = true,
		})
	end,
}
