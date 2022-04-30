" Vim-plug
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'tomasiser/vim-code-dark'
call plug#end()

" Default settings
syntax on
set number
set ignorecase
set nowrap
set mouse=a
set ttymouse=sgr
set wildmode=longest,list,full
set splitbelow splitright
set virtualedit=all

" Tab
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Style
let g:airline_theme = 'codedark'
colorscheme codedark
set cursorline
set cursorcolumn
highlight CursorLine ctermbg=235 cterm=bold
highlight CursorLineNR ctermbg=235 cterm=bold
highlight CursorColumn ctermbg=235 cterm=bold

" Macro
autocmd BufWritePre * %s/\s\+$//e
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
