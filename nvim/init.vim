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
"set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
" set noshowmode
set isfname+=@-@
" set ls=0
" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50
syntax on
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
call plug#begin('~/.config/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'olimorris/onedarkpro.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
" Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
Plug 'preservim/nerdtree'
Plug 'voldikss/vim-floaterm'
Plug 'gpanders/editorconfig.nvim'
Plug 'numToStr/Comment.nvim'
" Plug 'nvim-lua/completion-nvim'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()


syntax on
colorscheme onedarkpro
set termguicolors
highlight Normal guibg=none

lua require'nvim-treesitter.configs'.setup { highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}
lua require('Comment').setup()
let mapleader = " "
let NERDTreeShowHidden= 1
let g:NERDTreeChDirMode = 2

nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }, search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader>psf :lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>
nnoremap <leader>d :lua require('telescope.builtin').diagnostics({bufnr=0})<CR>

nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>j  :FloatermToggle<CR>

nnoremap <leader>j  <Esc>:FloatermToggle<CR>
tnoremap <leader>j  <C-\><C-n>:FloatermToggle<CR>
tnoremap <Esc> <C-\><C-n>

" reload buffers if change happens
autocmd FileChangedShell * bufdo e!
" Use completion-nvim in every buffer

fun! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup THE_ALEX
    autocmd!
    autocmd BufWritePre * :call TrimWhiteSpace()
    " autocmd BufEnter * lua require'completion'.on_attach()
augroup END

lua << EOF
require'lspconfig'.tsserver.setup{
  filetypes = { "typescript", "javascript" },
  disableAutomaticTypingAcquisition = true,
  init_options = {
    preferences = {
      disableSuggestions = true
    }
  },
  on_attach = function()
  vim.keymap.set("n","gd", vim.lsp.buf.definition, { buffer= 0})
  vim.keymap.set("n","gt", vim.lsp.buf.type_definition, { buffer= 0})
  vim.keymap.set("n","K", vim.lsp.buf.hover, { buffer= 0})
  end,
}
EOF

lua << EOF
require'lspconfig'.gopls.setup{}
EOF

lua << END
require('lualine').setup {
  options = {
    theme = 'onedark'
  }
}
END


