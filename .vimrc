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
filetype plugin indent on
au GuiEnter * set t_vb=
set guifont=Source\ Code\ Pro:h9
colorscheme desert

let s:statusline_options = {
      \   'mode_map': {
      \     'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL', 'V': 'V-LINE', "\<C-v>": 'V-BLOCK',
      \     'c': 'COMMAND', 's': 'SELECT', 'S': 'S-LINE', "\<C-s>": 'S-BLOCK', 't': 'TERMINAL'
      \   }
      \ }
function! Statusline_mode() abort
  return get(s:statusline_options.mode_map, mode(), '')
endfunction
set statusline=%1*\%<\ %-8{Statusline_mode()}
set statusline+=%2*\%<%.30F%m%r%h%w
set statusline+=%=%3*\%y\ %*
set statusline+=%4*\%{&ff}\[%{&fenc!=''?&fenc:&enc}]\ %*
set statusline+=%5*\ %l:%c\ %*
set statusline+=%6*\%3p%%\%*
hi User1 cterm=bold ctermfg=White ctermbg=Black gui=bold guifg=White guibg=Black
hi User2 cterm=none ctermfg=White ctermbg=Black guifg=White guibg=Black
hi User3 cterm=none ctermfg=DarkYellow ctermbg=Black guifg=Orange guibg=Black
hi User4 cterm=none ctermfg=Magenta ctermbg=Black guifg=Magenta guibg=Black
hi User5 cterm=none ctermfg=Brown ctermbg=Black guifg=Brown guibg=Black
hi User6 cterm=none ctermfg=green ctermbg=Black guifg=Green guibg=Black

let mapleader=" "
inoremap jk <ESC>
nmap <LEADER>rc :e $MYVIMRC<CR>
nmap <LEADER>n :nohlsearch<CR>
nnoremap <silent> J 5j
nnoremap <silent> K 5k

" deal with word wrap
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" auto pairs
inoremap ( ()<ESC>i
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { {}<ESC>i
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ []<ESC>i
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap " ""<ESC>i
inoremap ' ''<ESC>i
function! ClosePair(char)
  if getline('.')[col('.') - 1] == a:char
    return "\<Right>"
  else
    return a:char
  endif
endfunction

" netrw
nnoremap <A-m> :Vexplore<CR>
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_browse_split = 4
