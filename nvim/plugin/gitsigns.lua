vim.schedule(function()
  vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

  require("gitsigns").setup({
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signcolumn = false,
    numhl = true,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      follow_files = true,
    },
    attach_to_untracked = false,
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = false,
      delay = 250,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = function(_, blame_info)
      if blame_info.author == "Not Committed Yet" then
        return { { blame_info.author, "GitSignsCurrentLineBlame" } }
      end
      local text = string.format(
        "%s | %s | %s | %s",
        blame_info.author,
        blame_info.summary,
        os.date("%b %d %Y", blame_info.author_time),
        blame_info.abbrev_sha
      )
      return { { text, "GitSignsCurrentLineBlame" } }
    end,
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 6000,
    preview_config = {
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map("n", "L", function()
        if vim.wo.diff then
          return "L"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })

      map("n", "H", function()
        if vim.wo.diff then
          return "H"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })

      map("n", "<leader>hh", gs.preview_hunk)
      map("n", "<leader>hu", gs.reset_hunk)
    end,
  })
end)
