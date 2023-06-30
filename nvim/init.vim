call plug#begin('~/.config/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'olimorris/onedarkpro.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'voldikss/vim-floaterm'
Plug 'numToStr/Comment.nvim'

Plug 'windwp/nvim-autopairs'
Plug 'p00f/nvim-ts-rainbow'
Plug 'f-person/git-blame.nvim'

Plug 'ruanyl/vim-gh-line'

" lsp autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

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

let NERDTreeShowHidden= 1
let g:NERDTreeChDirMode = 2
let g:gitblame_date_format = '%r'
let g:gh_open_command = 'fn() { echo "$@" | pbcopy; }; fn '

let g:floaterm_width = 0.8
let g:floaterm_height = 0.9

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

lua require('Comment').setup()
lua require('complete')
lua require('treesitter')
lua require('onedark')
lua require('lsp')
lua require('statusline')
lua require('spellbee')

" keybindings
let mapleader = " "

" 'quote' a word
nnoremap qw :silent! normal mpea'<Esc>bi'<Esc>`pl
nnoremap wq :silent! normal mpeld bhd `ph<CR>

" paste without replaceing buffer
vnoremap <C-p> "_dP

" yank word
nnoremap <leader>y yiw<esc>
" select word
nnoremap <leader>v viw
" insert new line
nnoremap <leader>o o<Esc>
nnoremap <leader>s <cmd>wa!<CR>

" Telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').grep_string({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }, search = vim.fn.input("Search for > ")})<CR>
nnoremap <leader>p <cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references({ on_complete = { function() vim.cmd"stopinsert" end }, })<CR>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').find_files({ find_command = {'git', '--no-pager', 'diff', '--name-only' }})<CR>

" toggle neerdtree
nnoremap <leader>e <cmd>NERDTreeToggle<CR>

" FloatermToggle
nnoremap <leader>j <cmd>FloatermToggle<CR>
nnoremap <leader>j <Esc><cmd>FloatermToggle<CR>
tnoremap <leader>j <C-\><C-n><cmd>FloatermToggle<CR>
tnoremap <Esc> <C-\><C-n>

" move between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
