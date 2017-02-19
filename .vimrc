set tabstop=2
set shiftwidth=2
set cindent
set smartindent
set nowrap
set mouse=a
set incsearch
set hlsearch
set expandtab

set undofile
set undodir=~/.vim-undodir

" shortcuts to make program
set makeprg=g++-4.9\ -DDEBUG\ -O2\ -fopenmp\ --std=c++14\ -Wall\ -Wno-unused-result\ -o\ %:r\ %
"set makeprg=./run.sh
"set makeprg=g++-4.9\ -DDEBUG\ -O2\ --std=c++1y\ -Wall\ -Wno-unused-result\ -I/usr/local/include\ -L/usr/local/lib\ -lboost_unit_test_framework\ -o\ %:r\ %
"set makeprg=make
map <C-B> :w<CR>:make<CR>
imap <C-B> <ESC>:w<CR>:make<CR>

map <F5> :xa<cr>
imap <F5> <ESC>:xa<cr>

:map <F9> "qdt,dwep"qpB

execute pathogen#infect()
filetype plugin indent on

colorscheme blackboard

" disable comments insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Remember last cursor position
function! ResCur()
    if line("'\"") <= line("$")
    normal! g`"
    return 1
    endif
    endfunction

    augroup resCur
    autocmd!
autocmd BufWinEnter * call ResCur()
    augroup END
