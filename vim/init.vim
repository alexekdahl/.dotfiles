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
set incsearch
set scrolloff=18
set isfname+=@-@
set cmdheight=1
set updatetime=50
set shortmess+=c
set clipboard=unnamed
set completeopt=menu,menuone,noselect
set splitbelow
set splitright
set cursorline
set signcolumn=number

colorscheme desert
filetype on
filetype indent on
filetype plugin on
syntax on

" keybindings
let mapleader = " "

vnoremap <C-p> "_dP
nnoremap <leader>y yiw<esc>
nnoremap <leader>v viw
nnoremap <leader>o o<Esc>
nnoremap <leader>s <cmd>wa!<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
