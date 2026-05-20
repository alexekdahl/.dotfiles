vim.opt_local.colorcolumn = "80"

-- Keybinding to run mdp watch on current file (non-blocking)
vim.keymap.set('n', '<leader>mw', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  vim.fn.jobstart('mdp watch ' .. vim.fn.shellescape(filepath), { detach = true })
end, { desc = 'Run mdp watch on current file' })
