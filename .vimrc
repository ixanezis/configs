set tabstop=2
set shiftwidth=2
set cindent
set smartindent
set nowrap
set mouse=a
set incsearch
set hlsearch
set expandtab
syntax on

set undofile
set undodir=~/.vim/undodir

set nocompatible              " be iMproved, required
filetype off                  " required

" -------- Vundle -------
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'ratazzi/blackboard.vim.git'
Plugin 'preservim/nerdcommenter'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" -------- Vundle -------

" shortcuts to make program
set makeprg=g++\ -DDEBUG\ -O2\ --std=c++14\ -Wall\ -Wno-unused-result\ -Wno-char-subscripts\ -o\ %:r\ %
"set makeprg=./run.sh
"set makeprg=g++-4.9\ -DDEBUG\ -O2\ --std=c++1y\ -Wall\ -Wno-unused-result\ -I/usr/local/include\ -L/usr/local/lib\ -lboost_unit_test_framework\ -o\ %:r\ %
"set makeprg=make
map <C-B> :w<CR>:make<CR>
imap <C-B> <ESC>:w<CR>:make<CR>

map <F5> :xa<cr>
imap <F5> <ESC>:xa<cr>

:map <F9> "qdt,dwep"qpB

try
    colorscheme blackboard
catch /^Vim\%((\a\+)\)\=:E185/
    " this must be something like the first vim invokation, ignore absent scheme
endtry

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
