call plug#begin('~/.config/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'olimorris/onedarkpro.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'preservim/nerdtree'
Plug 'voldikss/vim-floaterm'
Plug 'gpanders/editorconfig.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'windwp/nvim-autopairs'

" lsp autocomplete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
" Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()


set guicursor=
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nu
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set isfname+=@-@
set cmdheight=1
set updatetime=50
set termguicolors
set shortmess+=c
set completeopt=menu,menuone,noselect
syntax on
syntax on
colorscheme onedarkpro
highlight Normal guibg=none

lua require('Comment').setup()
let mapleader = " "
let NERDTreeShowHidden= 1
let g:NERDTreeChDirMode = 2

fun! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

lua << EOF
require('nvim-treesitter.configs').setup{
highlight = { enable = true, additional_vim_regex_highlighting = false },
textobjects = { enable = true },
ensure_installed = {'javascript', 'typescript'},
  indent = { enable = true },
  autopairs = { enable = true },
  rainbow = { enable = true },
}
EOF

lua << EOF
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require'lspconfig'.tsserver.setup{
  filetypes = { "typescript", "javascript" },
  -- disableAutomaticTypingAcquisition = true,
  -- init_options = {
  --   preferences = {
  --     disableSuggestions = true
  --   }
  -- },
  capabilities = capabilites,
  on_attach = function()
    vim.keymap.set("n","gd", vim.lsp.buf.definition, { buffer= 0})
    vim.keymap.set("n","gt", vim.lsp.buf.type_definition, { buffer= 0})
    vim.keymap.set("n","K", vim.lsp.buf.hover, { buffer= 0})
    vim.keymap.set("n","<leader>r", vim.lsp.buf.rename, { buffer= 0})
    vim.keymap.set("n","<leader>a", vim.lsp.buf.code_action, { buffer= 0})
    vim.keymap.set("n","<leader>d", "<cmd>Telescope diagnostics<cr>", { buffer= 0})
  end,
}
EOF

lua << END
require('lualine').setup {
  options = {
    theme = 'onedark'
  }
}
END

lua << EOF
require("nvim-autopairs").setup {}
EOF


lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

EOF

augroup THE_ALEX
    autocmd!
    autocmd BufWritePre * :call TrimWhiteSpace()
    autocmd FileChangedShell * bufdo e!
augroup END

"keybindings"
nnoremap <leader>f :lua require('telescope.builtin').grep_string({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }, search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>p :lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>
nnoremap <leader>o :lua require('telescope.builtin').lsp_references({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>

nnoremap <leader>e :NERDTreeToggle<CR>

nnoremap <leader>j  :FloatermToggle<CR>
nnoremap <leader>j  <Esc>:FloatermToggle<CR>
tnoremap <leader>j  <C-\><C-n>:FloatermToggle<CR>
tnoremap <Esc> <C-\><C-n>
