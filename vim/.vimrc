set background=dark
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

filetype on
filetype indent on
filetype plugin on

" =====================================================
" Embedded colorscheme: tachyon
" =====================================================
set bg=dark
highlight Normal        guifg=#FEFEFE guibg=#202020
highlight NormalFloat   guifg=#FEFEFE guibg=#202020
highlight Comment       guifg=#6f7b68
highlight TSComment     guifg=#6f7b68
highlight Conceal       guibg=#262626
highlight Constant      guifg=#cccccc
highlight DiffAdd       guifg=#FFFEDB guibg=#2B3328
highlight DiffChange    guifg=#FFFEDB guibg=#262636
highlight DiffDelete    guifg=#C34143 guibg=#42242B
highlight DiffText      guifg=#FFFEDB guibg=#49443C
highlight Directory     guifg=#C1C88D
highlight Error         guifg=#C34143 gui=undercurl
highlight ErrorMsg      guifg=#FFFEDB
highlight Function      guifg=#AA9AAC
highlight Identifier    guifg=#8B9698
highlight LineNrAbove   guifg=#888888 guibg=#222222
highlight LineNrBelow   guifg=#888888 guibg=#222222
highlight LineNr        guifg=#d6d2c8
highlight MatchParen    guifg=#FFFEDB
highlight NonText       guifg=#303030
highlight Operator      guifg=#DEBF7C
highlight Pmenu         guifg=#918988 guibg=#303030
highlight PmenuSbar     guifg=#918988 guibg=#262626
highlight PmenuSel      guifg=#BFBBBA guibg=#303030
highlight PmenuThumb    guifg=#918988 guibg=#262626 gui=reverse
highlight PreProc       guifg=#8B9698
highlight Question      guifg=#9b8d7f
highlight QuickFixLine  guibg=#303030
highlight Search        guibg=#5F5958
highlight Special       guifg=#cccccc
highlight SpecialChar   guifg=#C1C88D
highlight SpecialKey    guifg=#676767
highlight Statement     guifg=#cccccc
highlight StatusLine    guifg=#FFFEDB guibg=#34383C
highlight String        guifg=#A2A970
highlight Structure     guifg=#AA9AAC
highlight Substitute    guifg=#1A1A1A guibg=#C1C88D
highlight TabLine       guifg=#A09998 guibg=#212121
highlight TabLineFill   guifg=#A09998 guibg=#212121
highlight TabLineSel    guifg=#A09998 guibg=#40474F
highlight Title         guifg=#FFFEDB
highlight Todo          guifg=#8B9698
highlight Type          guifg=#E3D896
highlight Underlined    gui=undercurl
highlight VertSplit     guifg=#303030
highlight Visual        guibg=#454545
highlight WarningMsg    guifg=#FFFEDB
highlight Float         guifg=#6f7b68
highlight Number        guifg=#6f7b68
highlight Boolean       guifg=#6f7b68
highlight WinSeparator  guibg=#111111 guifg=#888888

syntax on

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
endfunction

nnoremap <leader>e :call ToggleNetrw()<CR>
vnoremap <C-p> "_dP
nnoremap <leader>y yiw<esc>
nnoremap <leader>v viw
nnoremap <leader>o o<Esc>
nnoremap <leader>s <cmd>wa!<CR>
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>

if !exists("g:loaded_tmux_navigator") && !&cp && v:version >= 700
  let g:loaded_tmux_navigator = 1

  function! s:VimNavigate(dir)
    execute "wincmd " . a:dir
  endfunction

  nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
  nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
  nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
  nnoremap <silent> <C-l> :TmuxNavigateRight<CR>
  nnoremap <silent> <C-\> :TmuxNavigatePrevious<CR>

  if empty($TMUX)
    command! TmuxNavigateLeft     call s:VimNavigate('h')
    command! TmuxNavigateDown     call s:VimNavigate('j')
    command! TmuxNavigateUp       call s:VimNavigate('k')
    command! TmuxNavigateRight    call s:VimNavigate('l')
    command! TmuxNavigatePrevious call s:VimNavigate('p')
  else
    function! s:TmuxCommand(cmd)
      let socket = split($TMUX, ',')[0]
      return system("tmux -S " . socket . " " . a:cmd)
    endfunction

    function! s:TmuxAware(dir)
      let before = winnr()
      call s:VimNavigate(a:dir)
      if before == winnr()
        let tdir = tr(a:dir, 'hjkl', 'LDUR')
        call s:TmuxCommand("select-pane -" . tdir)
      endif
    endfunction

    command! TmuxNavigateLeft     call s:TmuxAware('h')
    command! TmuxNavigateDown     call s:TmuxAware('j')
    command! TmuxNavigateUp       call s:TmuxAware('k')
    command! TmuxNavigateRight    call s:TmuxAware('l')
    command! TmuxNavigatePrevious call s:TmuxAware('p')
  endif
endif
