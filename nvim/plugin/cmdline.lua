vim.opt.cmdheight = 0
vim.api.nvim_create_autocmd({ 'CmdlineEnter', "CmdlineLeave" }, {
  group = vim.api.nvim_create_augroup("cmdline-auto-hide", { clear = true }),
  callback = function(args)
    local target_height = args.event == 'CmdlineEnter' and 1 or 0
    if vim.opt_local.cmdheight:get() ~= target_height then
      vim.opt_local.cmdheight = target_height
      vim.cmd.redrawstatus()
    end
  end,
})
