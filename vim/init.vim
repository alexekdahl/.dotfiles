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
set scrolloff=18
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

fun! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup THE_ALEX
    autocmd!
    autocmd FileType qf nmap <buffer> <cr> <cr>:cclose<cr>
    autocmd BufWritePre * :call TrimWhiteSpace()
    autocmd FileChangedShell * bufdo e!
    autocmd InsertEnter * set nocursorline
    autocmd InsertLeave * set cursorline
augroup END

function! ToggleNetrw()
    let i = bufwinnr('^' . expand('%:p:h') . '$')
    if i != -1
        exec i . 'wincmd c'
    else
        exec 'Explore'
    endif
endfunction

" keybindings
let mapleader = " "

nnoremap <leader>e :call ToggleNetrw()<CR>
nnoremap qw :silent! normal mpea"<Esc>bi"<Esc>`pl
nnoremap wq :silent! normal mpeld bhd `ph<CR>

" paste without replaceing buffer
vnoremap <C-p> "_dP
nnoremap <leader>y yiw<esc>
nnoremap <leader>v viw
nnoremap <leader>o o<Esc>
nnoremap <leader>s <cmd>wa!<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
