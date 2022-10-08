
_G.open_telescope = function()
    local first_arg = vim.v.argv[2]
    if first_arg and vim.fn.isdirectory(first_arg) == 1 then
        vim.g.loaded_netrw = true
        require("telescope.builtin").find_files({ on_complete = { function() vim.cmd"stopinsert" end }, find_command = {'rg', '--files', '--hidden', '-g', '!.git', '!node_modules' }, search_dirs = {first_arg}})
   end
end
