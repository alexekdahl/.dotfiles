return {
  "saghen/blink.cmp",
  version = "1.*",

  opts = {
    keymap = {
      preset = "default",
      ["<C-k>"]     = { "select_prev" },
      ["<C-j>"]     = { "select_next" },
      ["<C-Space>"] = { "show" },
      ["<C-e>"]     = { "hide" },
      ["<CR>"]      = { "accept" },
      ["<Tab>"]     = { "select_next", "fallback" },
      ["<S-Tab>"]   = { "select_prev", "fallback" },
    },

    appearance = {
      nerd_font_variant = "mono",
      use_nvim_cmp_icons = true,
      use_nvim_cmp_as_default = true,
    },

    completion = {
      documentation = {
        auto_show = false,
        window = { border = "rounded" },
      },

      menu = {
        border = "rounded",

        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },

          components = {
            source_name = {
              text = function(ctx)
                return "[" .. ctx.source_name .. "]"
              end,
              highlight = "CmpItemMenu",
            },
          },
        },
      },
    },

    sources = {
      default = { "lsp", "buffer", "path" },
    },

    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
  },

  opts_extend = { "sources.default" },
}
