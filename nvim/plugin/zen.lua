vim.api.nvim_create_user_command(
  'ZenToggle',
  function() require('zen').toggle() end,
  { desc = 'Zen Mode' }
)
