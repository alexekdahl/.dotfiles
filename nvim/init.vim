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
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
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
set clipboard=unnamed
set completeopt=menu,menuone,noselect
syntax on
colorscheme onedarkpro
highlight Normal guibg=none

let mapleader = " "
let NERDTreeShowHidden= 1
let g:NERDTreeChDirMode = 2

fun! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun



lua require('lualine').setup { options = { theme = 'onedark'} }
lua require('Comment').setup()
lua require('complete')
lua require('treesitter')
lua require('lsp')

augroup THE_ALEX
    autocmd!
    autocmd BufWritePre * :call TrimWhiteSpace()
    autocmd FileChangedShell * bufdo e!
augroup END

"keybindings"
nnoremap <leader>ff <cmd>lua require('telescope.builtin').grep_string({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }, search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>p <cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references()<CR>

nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>s :wa<CR>

nnoremap <leader>j :FloatermToggle<CR>
nnoremap <leader>j <Esc>:FloatermToggle<CR>
tnoremap <leader>j <C-\><C-n>:FloatermToggle<CR>
tnoremap <Esc> <C-\><C-n>
