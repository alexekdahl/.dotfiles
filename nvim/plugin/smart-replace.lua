vim.api.nvim_create_user_command(
  "SmartReplace",
  function()
    require("replace").smart_replace()
  end,
  {}
)
