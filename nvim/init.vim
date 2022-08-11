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
Plug 'p00f/nvim-ts-rainbow'
Plug 'f-person/git-blame.nvim'
" lsp autocomplete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'jose-elias-alvarez/null-ls.nvim'

Plug 'mg979/vim-visual-multi', {'branch': 'master'}
call plug#end()

set guicursor=
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set tabstop=1 softtabstop=1
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
set clipboard=unnamed
set completeopt=menu,menuone,noselect
set splitbelow
set splitright
set cursorline
set signcolumn=number
filetype on
filetype indent on
filetype plugin on
syntax on

let NERDTreeShowHidden= 1
let g:NERDTreeChDirMode = 2
let g:gitblame_date_format = '%r'

lua << EOF
vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
vim.g.gitblame_message_template = '<author> • <date> • <sha>'
local git_blame = require('gitblame')

require('lualine').setup{
    sections = {
            lualine_c = {
                { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }
            }
    }
}
EOF

fun! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

lua << EOF
_G.open_telescope = function()
    local first_arg = vim.v.argv[2]
    if first_arg and vim.fn.isdirectory(first_arg) == 1 then
        vim.g.loaded_netrw = true
        require("telescope.builtin").find_files({ on_complete = { function() vim.cmd"stopinsert" end }, find_command = {'rg', '--files', '--hidden', '-g', '!.git', '!node_modules' }, search_dirs = {first_arg}})
   end
end
EOF

augroup THE_ALEX
    autocmd!
    autocmd BufWritePre * :call TrimWhiteSpace()
    autocmd FileChangedShell * bufdo e!
    autocmd VimEnter * lua open_telescope()
    autocmd InsertEnter * set nocursorline
    autocmd InsertLeave * set cursorline
augroup END

lua require('Comment').setup()
lua require('complete')
lua require('treesitter')
lua require('lsp')
lua require('onedark')

" keybindings
let mapleader = " "
nnoremap <leader>ff <cmd>lua require('telescope.builtin').grep_string({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }, search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>p <cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references({ on_complete = { function() vim.cmd"stopinsert" end }, })<CR>
" toggle neerdtree
nnoremap <leader>e <cmd>NERDTreeToggle<CR>
" save all
nnoremap <leader>s <cmd>wa<CR>
" FloatermToggle
nnoremap <leader>j <cmd>FloatermToggle<CR>
nnoremap <leader>j <Esc><cmd>FloatermToggle<CR>
tnoremap <leader>j <C-\><C-n><cmd>FloatermToggle<CR>
tnoremap <Esc> <C-\><C-n>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
