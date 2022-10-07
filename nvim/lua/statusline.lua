vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
vim.g.gitblame_message_template = '<author> • <date> • <sha>'
local git_blame = require('gitblame')

require('lualine').setup{
    options = {
             theme = 'onedarkpro'
         },
    sections = {
      lualine_a = {{
              'filename',
              file_status = true,
              path = 1
              }},
            lualine_c = {
                {
                    git_blame.get_current_blame_text,
                    cond = git_blame.is_blame_text_available
                }
            }
    }
}
