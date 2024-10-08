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

set laststatus=2
set statusline=%f
set statusline+=%=
set statusline+=%l
set statusline+=/
set statusline+=%L

colorscheme desert
filetype on
filetype indent on
filetype plugin on
syntax on

" keybindings
let mapleader = " "

function ToggleNetrw()
    if &ft == "netrw"
        if exists("w:netrw_rexfile")
            if w:netrw_rexfile == "" || w:netrw_rexfile == "NetrwTreeListing"
                quit
            else
                exec 'e ' . w:netrw_rexfile
            endif
        else
            if exists("w:netrw_rexlocal")
                Rexplore
            else
                quit
            endif
        endif
    else
        Explore
    endif
endfun

nnoremap <leader>e :call ToggleNetrw()<CR>
vnoremap <C-p> "_dP
nnoremap <leader>y yiw<esc>
nnoremap <leader>v viw
nnoremap <leader>o o<Esc>
nnoremap <leader>s <cmd>wa!<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
