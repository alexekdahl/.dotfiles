return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	opts = function(_, opts)
		local function setOpts()
			if opts.routes == nil then
				opts.routes = {}
				return
			end
		end
		setOpts()
		table.insert(opts.routes, {
			view = "notify",
			filter = {
				{ event = "msg_showmode" },
				{
					event = "notify",
					find = "No information available",
				},
			},
		})

		opts.lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		}

		opts.presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			inc_rename = false,
			lsp_doc_border = true,
		}

		table.insert(opts.routes, {
			filter = {
				event = "notify",
				find = "No information available",
			},
			opts = { skip = true },
		})
	end,
}
