" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible " be iMproved
filetype off " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle, required! 
Bundle 'gmarik/vundle'

" My Bundles here:
" original repos on github
Bundle 'altercation/vim-colors-solarized'
Bundle 'derekwyatt/vim-scala'

filetype plugin indent on     " required!
" End of Vundle part

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

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
colors solarized
set expandtab
set shiftwidth=2
set softtabstop=2
set number
set showmatch
set smartcase
set smarttab
set autoindent
set pastetoggle=F2
set visualbell
set noerrorbells
set nobackup
set noswapfile

noremap  <Up> <nop>
noremap  <Down> <nop>
noremap  <Left> <nop>
noremap  <Right> <nop>

function InvNum ()
  set invnumber
endfunction

map <F3> :call InvNum()<CR>
