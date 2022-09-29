call plug#begin('~/.local/share/nvim/plugged')

" Treesitter highlighting for multiple languages
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
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
" LSP support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
" OCaml support
Plug 'ocaml/vim-ocaml', { 'for': ['ocaml', 'dune'] }
" OCaml auto format
Plug 'sbdchd/neoformat', { 'for': 'ocaml' }
" Vim indent guide
Plug 'nathanaelkane/vim-indent-guides'
" Improved rst editing
"Plug 'gu-fan/riv.vim'
" Instant feedback on rst editing
Plug 'gu-fan/InstantRst'
" Surrond word with parentheses, quotes etc.
Plug 'tpope/vim-surround'
" Git plugin for vim
Plug 'tpope/vim-fugitive'
" Syntax highlighting for Hashicorp .hcl files
Plug 'jvirtanen/vim-hcl'

" All of your Plugins must be added before the following line
call plug#end() " End of vim-plug

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "go", "ocaml", "ocaml_interface", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

"NeoVim handles ESC keys as alt+key set this for faster sequences
set timeout
set timeoutlen=750
set ttimeoutlen=100
if has('nvim')
   set ttimeout
   set ttimeoutlen=0
endif

let mapleader = " " " the leader key must be defined before usage

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
" See ':h jumplist' C-o & C-i to jump back & forth
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gc <Plug>(coc-declaration)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gu <Plug>(coc-references-used)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
" https://github.com/neoclide/coc.nvim/wiki/F.A.Q#how-to-show-documentation-of-symbol-under-cursor-also-known-as-cursor-hover
" autocmd CursorHold * silent call CocActionAsync('doHover')
nnoremap <silent> <leader>h :call CocActionAsync('doHover')<cr>

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

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
silent! colorscheme solarized
if exists('+colorcolumn')
  set colorcolumn=80    " use visual indicator at 80 char mark
endif

" This has to be configured after the colorscheme is set
highlight CocFloating ctermbg=0
highlight CocSearch ctermfg=4
highlight CocMenuSel ctermbg=10

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
set nobackup            " https://github.com/neoclide/coc.nvim/issues/649#issuecomment-480086894
set nowritebackup       " https://github.com/neoclide/coc.nvim/issues/649#issuecomment-480086894
set noswapfile
set laststatus=2        " always show the statusline
set encoding=utf-8      " necessary to show Unicode glyphs
set t_Co=256            " tell Vim that the terminal supports 256 colors
syntax on               " syntax highlighting
set hlsearch            " switch on highlighting the last used search pattern
set mouse=""            " disable that stupid mouse support as it breaks the clipboard
set hidden              " make it possible to keep buffer undo history when changing buffers

"let g:riv_disable_folding=1

let g:ctrlp_extensions = ['line'] " enable fuzzy search for lines extension

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
" delete all empty lines or that only contain whitespace
noremap <Leader>l :g/^\s*$/d<CR>

" OCaml auto-completion with merlin
" See Vim section http://dev.realworldocaml.org/install.html
let g:opambin = substitute(system('opam var bin'),'\n$','','''')
let g:neoformat_ocaml_ocamlformat = {
            \ 'exe': g:opambin . '/ocamlformat',
            \ 'no_append': 1,
            \ 'stdin': 1,
            \ 'args': ['--enable-outside-detected-project', '--break-infix=fit-or-vertical', '--break-cases=fit-or-vertical', '--break-fun-decl=fit-or-vertical', '--type-decl=sparse', '--name', '"%:p"', '-']
            \ }

let g:neoformat_enabled_ocaml = ['ocamlformat']
autocmd FileType ocaml setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup fmt
    autocmd!
    autocmd BufWritePre *.ml,*.mli try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
    "autocmd BufWritePre *.ml,*.mli undojoin | silent Neoformat
augroup end

" Shift Insert does something magic?
map <S-Insert> "*gP
cmap <S-Insert> <C-R>*
imap <S-Insert> <C-R>*
