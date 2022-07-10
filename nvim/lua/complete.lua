  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local luasnip = require'luasnip'
  require("luasnip/loaders/from_vscode").lazy_load()

  cmp.setup{
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert{
      ['<C-k>'] = cmp.mapping.select_prev_item(),
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ['<C-e>'] = cmp.mapping{
        i = cmp.mapping.abort(),
        c = cmp.mapping.close()
      },
      ['<CR>'] = cmp.mapping.confirm{ select = true },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, {
        'i',
        's'
      }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        'i',
        's'
      }),
    },
    sources = cmp.config.sources{
      { name = 'nvim_lsp' }, -- For luasnip users.
      { name = 'luasnip' }, -- For luasnip users.
      { name = 'buffer' },
      { name = 'nvim_lua' },
      { name = 'path' },
    },
    experimental = {
      ghost_text = true
    }
  }
