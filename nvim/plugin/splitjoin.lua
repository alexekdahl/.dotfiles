vim.api.nvim_create_user_command(
  'SplitJoinToggle',
  function(_) require('splitjoin').toggle({}) end,
  { nargs = 0, desc = 'Toggle split/join for bracketed collections' }
)
