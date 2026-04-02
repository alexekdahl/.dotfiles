-- Keymaps
local map = vim.keymap.set

local function toggle_quickfix()
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      vim.cmd("cclose")
      return
    end
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd("copen")
  end
end

local function color_print()
  local clipboard = vim.fn.getreg("+")
  if clipboard == "" then
    vim.notify("Clipboard is empty", vim.log.levels.WARN)
    return
  end
  local format_strings = {
    lua = 'print("\\27[33m%s:\\27[0m", %s)',
    go = 'fmt.Printf("\\033[33m%s:\\033[0m %%v\\n", %s)',
    javascript = 'console.log("\\x1b[33m%s:\\x1b[0m", %s);',
    typescript = 'console.log("\\x1b[33m%s:\\x1b[0m", %s);',
    python = 'print(f"\\033[33m{%s=}\\033[0m")',
    rust = 'println!("\\x1b[33m{}: {:?}\\x1b[0m", %s);',
    c = 'printf("\\033[33m%s: %%d\\033[0m\\n", %s);',
    nim = 'echo "\\e[33m%s: \\e[0m", $%s',
  }
  local filetype = vim.bo.filetype
  local fmt = format_strings[filetype] or 'print("\\27[33m%s:\\27[0m", %s)'
  local print_statement = string.format(fmt, clipboard, clipboard)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1]
  local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1] or ""
  local indentation = current_line:match("^%s*") or ""
  vim.api.nvim_buf_set_lines(0, line, line, false, { indentation .. print_statement })
  vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
end

----------------------------------------------------------------------
-- Window Navigation
----------------------------------------------------------------------

map("n", "<C-J>", function() require("custom.tmux").navigate("j") end, { desc = "Focus split Down" })
map("n", "<C-H>", function() require("custom.tmux").navigate("h") end, { desc = "Focus split Left" })
map("n", "<C-K>", function() require("custom.tmux").navigate("k") end, { desc = "Focus split Up" })
map("n", "<C-L>", function() require("custom.tmux").navigate("l") end, { desc = "Focus split Right" })

map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split Vertical" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split Horizontal" })

----------------------------------------------------------------------
-- Editing Helpers
----------------------------------------------------------------------

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("v", "<C-p>", '"_dP', { desc = "Paste no registry" })
map("n", "<leader>v", "viw", { desc = "Select inner Word" })
map("n", "<leader>y", "yiw", { desc = "Yank inner Word" })
map("n", "<leader>o", "o<Esc>", { desc = "Add line Below" })
map("n", "<leader>s", "<cmd>silent! wa!<CR>", { desc = "Save All" })
map("n", "<leader>t", "<cmd>GoTestFunc<CR>", { desc = "Go Test" })
map("n", "<C-b>", toggle_quickfix, { desc = "Toggle Quickfix" })
map("n", "<leader>l", color_print, { desc = "Color print" })
map("n", "<C-s>", function() require("custom.replace").smart_replace() end, { desc = "Smart replace" })
map("n", "<leader>m", function() require("custom.splitjoin").toggle({}) end, { desc = "Toggle split/join" })
map("n", "<leader>z", function() require("custom.zen").toggle() end, { desc = "Zen Mode" })

----------------------------------------------------------------------
-- Diagnostics + LSP
----------------------------------------------------------------------

map("n", "]", function() vim.diagnostic.jump({ count = vim.v.count1 }) end, { desc = "Next Diagnostic" })
map("n", "[", function() vim.diagnostic.jump({ count = -vim.v.count1 }) end, { desc = "Prev Diagnostic" })

map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, { desc = "LSP Hover" })

map("n", "<leader>r", vim.lsp.buf.rename, { desc = "LSP Rename" })
map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("n", "<leader>k", function() vim.diagnostic.open_float({ border = "rounded" }) end, { desc = "Diagnostic Float" })

----------------------------------------------------------------------
-- Snacks Picker Integrations
----------------------------------------------------------------------
map("n", "<leader>fm", function() Snacks.picker.man() end, { desc = "Man Pages" })
map("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
map("n", "<leader>fq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
map("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
map("n", "<leader>?", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })

----------------------------------------------------------------------
-- Snacks Picker Integrations
----------------------------------------------------------------------
map("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
map("n", "<leader>fl", function()
  Snacks.picker.grep({
    cmd = "rg", hidden = true, layout = { preset = "ivy" }
  })
end, { desc = "Grep" })
map("n", "<leader>fr", function()
  Snacks.picker.lsp_references({
    cmd = "rg",
    hidden = true,
    layout = {
      preset = "ivy",
    },
  })
end, { desc = "References", nowait = true })
map("n", "<leader>ft", function()
  Snacks.picker.lsp_implementations({
    cmd = "rg",
    hidden = true,
    layout = {
      preset = "ivy",
    },
  })
end, { desc = "Implements" })
map("n", "<leader>fc", function()
  Snacks.picker.git_status({
    cmd = "rg",
    hidden = true,
    layout = {
      preset = "ivy",
    },
  })
end, { desc = "Git Status" })
map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Grep Word / Selection" })
map("n", "<leader>d", function()
  Snacks.picker.diagnostics({
    cmd = "rg",
    hidden = true,
    layout = {
      layout = {
        box = "vertical",
        backdrop = false,
        row = -1,
        width = 0,
        height = 0.4,
        border = "top",
        title = " {title} {live} {flags}",
        title_pos = "left",
        { win = "input", height = 1, border = "bottom" },
        {
          box = "horizontal",
          { win = "list",    border = "none" },
          { win = "preview", title = "{preview}", width = 0.4, border = "left" },
        },
      },
    },
  })
end, { desc = "Diagnostics" })
map("n", "gd", function()
  Snacks.picker.lsp_definitions({
    cmd = "rg",
    hidden = true,
    layout = {
      preset = "ivy",
    },
  })
end, { desc = "Goto [D]efinition" })
map("n", "gt", function()
  Snacks.picker.lsp_type_definitions({
    cmd = "rg",
    hidden = true,
    layout = {
      preset = "ivy",
    },
  })
end, { desc = "Goto T[y]pe Definition" })
map("n", "<leader>fs", function() Snacks.picker.resume() end, { desc = "Resume Last Picker" })
map("n", "<leader>u", function() Snacks.picker.undo() end, { desc = "Undo History" })

map("n", "<leader>ff", function()
  Snacks.picker.files({
    cmd = "rg",
    exclude = { ".git/", "node_modules/" },
    hidden = true,
    layout = {
      preset = "ivy",
    },
  })
end, { desc = "Find Files" })

map("n", "<leader>gl", function()
  Snacks.picker.git_log_file({
    finder = "git_log",
    layout = "vertical",
    format = "git_log",
    preview = "git_show",
    confirm = "git_checkout",
  })
end, { desc = "Git Log (File)" })

map("n", "<leader>e", function()
  Snacks.explorer.open({ replace_netrw = true, hidden = true })
end, { desc = "Explorer" })

map({ "n", "v" }, "<leader>gh", function()
  Snacks.gitbrowse.open({ open = function(url) vim.fn.setreg("+", url) end })
end, { desc = "Git Browse (copy URL)" })
