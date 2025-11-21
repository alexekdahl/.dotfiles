return {
  "folke/snacks.nvim",
  priority = 10000,
  lazy = false,
  opts = {
    picker = {
      enabled = true,
      layout = { cycle = false },
    },
    explorer = { enabled = true },
    gitbrowse = { enabled = true },
    indent = {
      enabled = true,
      animate = { enabled = false },
      scope = { enabled = false },
    },
  },
  keys = {
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files({
          cmd = "rg",
          exclude = { ".git/", "node_modules/" },
          hidden = true,
          win = {
            list = {
              keys = {
                ["<C-Down>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<Up>"] = { "preview_scroll_up", mode = { "i", "n" } },
                ["<Left>"] = { "preview_scroll_left", mode = { "i", "n" } },
                ["<Right>"] = { "preview_scroll_right", mode = { "i", "n" } },
              },
            },
          },
        })
      end,
      desc = "Find Files",
    },
    {
      "<leader>fl",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = "References",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.git_status()
      end,
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Visual selection or word",
      mode = { "n", "x" },
    },
    {
      "<leader>d",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>fm",
      function()
        Snacks.picker.man()
      end,
      desc = "Man Pages",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks",
    },
    {
      "<leader>fq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>uC",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto [D]efinition",
    },
    {
      "gt",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "Goto T[y]pe Definition",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log_file({
          finder = "git_log",
          layout = "vertical",
          format = "git_log",
          preview = "git_show",
          confirm = "git_checkout",
        })
      end,
      desc = "Git Log (file)",
    },
    {
      "<leader>e",
      function()
        Snacks.explorer.open({
          replace_netrw = true,
          hidden = true,
        })
      end,
    },
    {
      "<leader>gh",
      function()
        Snacks.gitbrowse.open({
          open = function(url)
            -- add to global clipboard instead of open in browser
            vim.fn.setreg("+", url)
          end,
        })
      end,
      mode = { "n", "v" },
    },
    {
      "<leader>fs",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume Last Picker",
    },
  },
}
