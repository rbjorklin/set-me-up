call plug#begin('~/.local/share/nvim/plugged')

" Solarized color scheme
Plug 'altercation/vim-colors-solarized'
" File explorer, on-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" Async syntax checks
Plug 'vim-syntastic/syntastic'
" Fuzzy search
Plug 'ctrlpvim/ctrlp.vim'
" Improved staus bar
Plug 'bling/vim-airline'
" Class outline viewer
Plug 'majutsushi/tagbar'
" Make it easy to format text
Plug 'godlygeek/tabular'
" Auto completion
"Plug 'Valloric/YouCompleteMe', { 'do': 'python3 ./install.py --gocode-completer' }
" LSP support
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
" Go plugin
Plug 'fatih/vim-go', { 'for': 'go' }
" Rust plugin
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
" Clojure syntax highlighting
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
" Clojure REPL support
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Clojure extended syntax highlighting
Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' }
" Rainbow colored parentheses, prime for Clojure
Plug 'junegunn/rainbow_parentheses.vim', { 'for': 'clojure' }
" OCaml auto indent
Plug 'OCamlPro/ocp-indent', { 'for': 'ocaml' }
" OCaml auto format
Plug 'sbdchd/neoformat', { 'for': 'ocaml' }
" Vim indent guide
Plug 'nathanaelkane/vim-indent-guides'
" Improved rst editing
Plug 'gu-fan/riv.vim'
" Instant feedback on rst editing
Plug 'gu-fan/InstantRst'
" Surrond word with parentheses, quotes etc.
Plug 'tpope/vim-surround'

" All of your Plugins must be added before the following line
call plug#end() " End of vim-plug

"NeoVim handles ESC keys as alt+key set this for faster sequences
set timeout
set timeoutlen=750
set ttimeoutlen=100
if has('nvim')
   set ttimeout
   set ttimeoutlen=0
endif

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" rustfmt on buffer save
let g:rustfmt_autosave = 1

" coc.nvim airline integration
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  autocmd BufNewFile,BufRead *.clj RainbowParentheses!!

  " go support
  autocmd BufNewFile,BufRead *.go setlocal ft=go
  autocmd FileType go setlocal shiftwidth=8 tabstop=8 softtabstop=4 foldmethod=syntax

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
set hidden              " make it possible to keep buffer undo history when changing buffers

let g:riv_disable_folding=1

let g:ctrlp_extensions = ['line'] " enable fuzzy search for lines extension
let mapleader = " "

" https://github.com/nathanaelkane/vim-indent-guides
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

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
noremap <F1> :set invnumber<CR>
" toggle paste mode
noremap <Leader>p :set invpaste<CR>
" show or hide the NERDTree
noremap <Leader>n :NERDTreeToggle<CR>
" show or hide tagbar
noremap <Leader>T :TagbarToggle<CR>
" CtrlP fuzzy line search
noremap <Leader>f :CtrlPLine<CR>
" strip all trailing spaces
noremap <Leader><Leader> :%s/\s\+$//g<CR>

" OCaml auto-completion with merlin
" See Vim section http://dev.realworldocaml.org/install.html
if executable('ocamlmerlin') && executable('ocamlformat') && has('python')
    let s:opamshare = substitute(system('opam config var share'), '\n$', '', '''') . "/merlin"
    let s:ocp_indent = substitute(system('opam config var ocp-indent:share'), '\n$', '', '''') . "/vim"
    execute "set rtp+=".s:opamshare."/vim"
    execute "set rtp+=".s:opamshare."/vimbufsync"
    execute "set rtp+=".s:ocp_indent.""
    "autocmd FileType ocaml source s:opamshare."/typerex/ocp-indent/ocp-indent.vim"
    let g:syntastic_ocaml_checkers = ['merlin']
    autocmd FileType ocaml setlocal shiftwidth=2 tabstop=2 softtabstop=2
    augroup fmt
        autocmd!
        autocmd BufWritePre *.ml,*.mli undojoin | Neoformat
    augroup end

    " List all occurrences of identifier under cursor in current buffer.
    nmap <Leader>*  <Plug>(MerlinSearchOccurrencesForward)
    nmap <Leader>#  <Plug>(MerlinSearchOccurrencesBackward)

    " Rename all occurrences of identifier under cursor to <ident>.
    nmap <Leader>r  <Plug>(MerlinRename)
    nmap <Leader>R  <Plug>(MerlinRenameAppend)
endif

" Shift Insert does something magic?
map <S-Insert> "*gP
cmap <S-Insert> <C-R>*
imap <S-Insert> <C-R>*
