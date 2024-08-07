return {
	"zbirenbaum/copilot.lua",
	enabled = true,
	cmd = "Copilot",
	event = "InsertEnter",
	cond = function()
		local should_disable = require("util.folder").should_disable
		local current_dir = vim.fn.getcwd()
		local ONPREM_REPO = vim.env.ONPREM_REPO or ""
		return should_disable(current_dir, ONPREM_REPO)
	end,
	opts = {
		panel = {
			enabled = true,
			auto_refresh = false,
			layout = {
				position = "right",
				ratio = 0.5,
			},
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
			["*"] = false,
			python = true,
			go = true,
			yaml = true,
			lua = true,
			sh = function()
				if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
					return false
				end
				return true
			end,
		},
		copilot_node_command = vim.fn.expand("$HOME") .. "/.config/node",
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
