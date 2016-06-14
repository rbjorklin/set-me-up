" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible " be iMproved
filetype off " required for Vundle!
call plug#begin('~/.config/nvim/plugged')

" Solarized color scheme
Plug 'altercation/vim-colors-solarized'
" File explorer, on-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Async syntax checks
Plug 'neomake/neomake'
" Fuzzy search
Plug 'kien/ctrlp.vim'
" Improved staus bar
Plug 'bling/vim-airline'
" Class outline viewer
Plug 'majutsushi/tagbar'
" Make it easy to format text
Plug 'godlygeek/tabular'
" Go plugin
Plug 'fatih/vim-go', { 'for': 'go' }
" Rust plugin
Plug 'rust-lang/rust.vim', { 'for': 'rs' }

" All of your Plugins must be added before the following line
call plug#end()            " required

filetype plugin indent on     " required!
" End of Vundle part

"NeoVim handles ESC keys as alt+key set this for faster sequences
set timeout
set timeoutlen=750
set ttimeoutlen=100
if has('nvim')
   set ttimeout
   set ttimeoutlen=0
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " go support
  autocmd BufNewFile,BufRead *.go setlocal ft=go
  autocmd FileType go setlocal shiftwidth=8 tabstop=8 softtabstop=4

  " Run Neomake on write file
  autocmd! BufWritePost * Neomake

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

endif " has("autocmd")

set background=dark
silent! colors solarized
if exists('+colorcolumn')
  set colorcolumn=80    " use visual indicator at 80 char mark
endif

set scrolloff=1
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=100         " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set expandtab           " expand tabs to spaces
set shiftwidth=4        " make tab key create two spaces
set softtabstop=4       " match indentation to two spaces
set number              " show line numbers
set showmatch           " show matching brackets and parentheses
set ignorecase          " smartcase below depends on this
set smartcase           " do case insensitive search when using lowercase
set smarttab
set autoindent          " copy indent from current line to new line
set visualbell          " make screen flash instead of audible beep
set noerrorbells        " ignore errorbells
set nobackup
set noswapfile
set laststatus=2        " always show the statusline
set encoding=utf-8      " necessary to show Unicode glyphs
set t_Co=256            " tell Vim that the terminal supports 256 colors
syntax on               " syntax highlighting
set hlsearch            " switch on highlighting the last used search pattern
set mouse=""            " disable that stupid mouse support as it breaks the clipboard

let g:ctrlp_extensions = ['line'] " enable fuzzy search for lines extension
let mapleader = " "

map <Leader>o o<ESC>
map <Leader>O O<ESC>
map <Leader>w :w<CR>
map <Leader>q :q<CR>
" unmap arrow keys
noremap  <Up> <nop>
noremap  <Down> <nop>
noremap  <Left> <nop>
noremap  <Right> <nop>

"function InvNum ()
"  set invnumber
"endfunction
"
"map <F4> :call InvNum()<CR>
" toggle line numbering
map <F1> :set invnumber<CR>
" toggle paste mode
map <Leader>p :set invpaste<CR>
" show or hide the NERDTree
map <Leader>n :NERDTreeToggle<CR>
" show or hide tagbar
map <Leader>t :TagbarToggle<CR>
" CtrlP fuzzy line search
map <Leader>f :CtrlPLine<CR>
