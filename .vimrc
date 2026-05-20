syntax on
set number
set noshowmode
set laststatus=2
set shiftwidth=2
set tabstop=2
set expandtab smarttab
set ignorecase smartcase
set wrap
set vb t_vb=
set hlsearch
" set list
" set listchars=tab:»·,trail:·,nbsp:·
set scrolloff=5
set mouse=a
set history=1000
set autoindent
set smartindent
set hidden
set nobackup
set nowritebackup
set updatetime=100
set shortmess+=c
set clipboard+=unnamed
set backspace=indent,eol,start
set nocompatible
set noswapfile
set autochdir
set noundofile
set nofoldenable
set encoding=UTF-8
set fileencodings=utf-8,chinese,latin-1
set omnifunc=syntaxcomplete#Complete
filetype plugin indent on
au GuiEnter * set t_vb=
set guifont=Intel\ One\ Mono:h10
colorscheme habamax

let mapleader=" "
inoremap jk <ESC>
nmap <LEADER>rc :e $MYVIMRC<CR>
nmap <LEADER>n :nohlsearch<CR>

" deal with word wrap
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

call plug#begin('~/vimfiles/plugged')

Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree'
Plug 'Yggdroot/indentLine'

call plug#end()

nnoremap <leader>e :NERDTreeToggle<CR>
let g:lightline = { 'colorscheme': 'wombat' }
