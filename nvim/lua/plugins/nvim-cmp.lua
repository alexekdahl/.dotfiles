return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		vim.opt.completeopt = "menu,menuone,noselect"
		cmp.setup({
			completion = {
				winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
				["<C-e>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
			}),
			formatting = {
				format = lspkind.cmp_format({
					with_text = true,
					menu = {
						nvim_lsp = "[LSP]",
						buffer = "[buf]",
						path = "[path]",
					},
				}),
			},
		})
	end,
}
