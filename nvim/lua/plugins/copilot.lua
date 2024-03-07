return {
	"zbirenbaum/copilot.lua",
	enabled = true,
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		panel = {
			enabled = false,
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
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-e>",
			},
		},
		filetypes = {
			["*"] = false,
			go = true,
			python = true,
			yaml = true,
			make = true,
			lua = true,
			bash = true,
			rust = true,
			c = true,
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
