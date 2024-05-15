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
nnoremap <LEADER>m :Vexplore<CR>
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_browse_split = 4

" apc.vim
let g:apc_enable_ft = get(g:, 'apc_enable_ft', {})    " enable filetypes
let g:apc_enable_tab = get(g:, 'apc_enable_tab', 1)   " remap tab
let g:apc_min_length = get(g:, 'apc_min_length', 2)   " minimal length to open popup
let g:apc_key_ignore = get(g:, 'apc_key_ignore', [])  " ignore keywords
let g:apc_trigger = get(g:, 'apc_trigger', "\<c-n>")  " which key to trigger popmenu

" get word before cursor
function! s:get_context()
    return strpart(getline('.'), 0, col('.') - 1)
endfunc

function! s:meets_keyword(context)
    if g:apc_min_length <= 0
        return 0
    endif
    let matches = matchlist(a:context, '\(\k\{' . g:apc_min_length . ',}\)$')
    if empty(matches)
        return 0
    endif
    for ignore in g:apc_key_ignore
        if stridx(ignore, matches[1]) == 0
            return 0
        endif
    endfor
    return 1
endfunc

function! s:check_back_space() abort
      return col('.') < 2 || getline('.')[col('.') - 2]  =~# '\s'
endfunc

function! s:on_backspace()
    if pumvisible() == 0
        return "\<BS>"
    endif
    let text = matchstr(s:get_context(), '.*\ze.')
    return s:meets_keyword(text)? "\<BS>" : "\<c-e>\<bs>"
endfunc


" autocmd for CursorMovedI
function! s:feed_popup()
    let enable = get(b:, 'apc_enable', 0)
    let lastx = get(b:, 'apc_lastx', -1)
    let lasty = get(b:, 'apc_lasty', -1)
    let tick = get(b:, 'apc_tick', -1)
    if &bt != '' || enable == 0 || &paste
        return -1
    endif
    let x = col('.') - 1
    let y = line('.') - 1
    if pumvisible()
        let context = s:get_context()
        if s:meets_keyword(context) == 0
            call feedkeys("\<c-e>", 'n')
        endif
        let b:apc_lastx = x
        let b:apc_lasty = y
        let b:apc_tick = b:changedtick
        return 0
    elseif lastx == x && lasty == y
        return -2
    elseif b:changedtick == tick
        let lastx = x
        let lasty = y
        return -3
    endif
    let context = s:get_context()
    if s:meets_keyword(context)
        silent! call feedkeys(get(b:, 'apc_trigger', g:apc_trigger), 'n')
        let b:apc_lastx = x
        let b:apc_lasty = y
        let b:apc_tick = b:changedtick
    endif
    return 0
endfunc

" autocmd for CompleteDone
function! s:complete_done()
    let b:apc_lastx = col('.') - 1
    let b:apc_lasty = line('.') - 1
    let b:apc_tick = b:changedtick
endfunc

" enable apc
function! s:apc_enable()
    call s:apc_disable()
    augroup ApcEventGroup
        au!
        au CursorMovedI <buffer> nested call s:feed_popup()
        au CompleteDone <buffer> call s:complete_done()
    augroup END
    let b:apc_init_autocmd = 1
    if g:apc_enable_tab
        inoremap <silent><buffer><expr> <tab>
                    \ pumvisible()? "\<c-n>" :
                    \ <SID>check_back_space() ? "\<tab>" : 
                    \ get(b:, 'apc_trigger', g:apc_trigger)
        inoremap <silent><buffer><expr> <s-tab>
                    \ pumvisible()? "\<c-p>" : "\<s-tab>"
        let b:apc_init_tab = 1
    endif
    if get(g:, 'apc_cr_confirm', 0) == 0
        inoremap <silent><buffer><expr> <cr> 
                    \ pumvisible()? "\<c-y>\<cr>" : "\<cr>"
    else
        inoremap <silent><buffer><expr> <cr> 
                    \ pumvisible()? "\<c-y>" : "\<cr>"
    endif
    inoremap <silent><buffer><expr> <bs> <SID>on_backspace()
    let b:apc_init_bs = 1
    let b:apc_init_cr = 1
    let b:apc_save_infer = &infercase
    setlocal infercase
    let b:apc_enable = 1
endfunc

" disable apc
function! s:apc_disable()
    if get(b:, 'apc_init_autocmd', 0)
        augroup ApcEventGroup
            au! 
        augroup END
    endif
    if get(b:, 'apc_init_tab', 0)
        silent! iunmap <buffer><expr> <tab>
        silent! iunmap <buffer><expr> <s-tab>
    endif
    if get(b:, 'apc_init_bs', 0)
        silent! iunmap <buffer><expr> <bs>
    endif
    if get(b:, 'apc_init_cr', 0)
        silent! iunmap <buffer><expr> <cr>
    endif
    if get(b:, 'apc_save_infer', '') != ''
        let &l:infercase = b:apc_save_infer
    endif
    let b:apc_init_autocmd = 0
    let b:apc_init_tab = 0
    let b:apc_init_bs = 0
    let b:apc_init_cr = 0
    let b:apc_save_infer = ''
    let b:apc_enable = 0
endfunc

" check if need to be enabled
function! s:apc_check_init()
    if &bt != '' || get(b:, 'apc_enable', 1) == 0
        return
    endif
    if get(g:apc_enable_ft, &ft, 0) != 0
        ApcEnable
    elseif get(g:apc_enable_ft, '*', 0) != 0
        ApcEnable
    elseif get(b:, 'apc_enable', 0)
        ApcEnable
    endif
endfunc

" commands & autocmd
command! -nargs=0 ApcEnable call s:apc_enable()
command! -nargs=0 ApcDisable call s:apc_disable()

augroup ApcInitGroup
    au!
    au FileType * call s:apc_check_init()
    au BufEnter * call s:apc_check_init()
    au TabEnter * call s:apc_check_init()
augroup END

" apc config
let g:apc_enable_ft = {'*':1}
set cpt=.,k,w,b
set completeopt=menu,menuone,noselect
