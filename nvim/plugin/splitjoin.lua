vim.api.nvim_create_user_command(
  'SplitJoinToggle',
  function() require('splitjoin').toggle({}) end,
  { desc = 'Toggle split/join for bracketed collections' }
)
