-- use space as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- https://github.com/nanotee/nvim-lua-guide#the-vim-namespace
-- https://github.com/nanotee/nvim-lua-guide#using-meta-accessors
-- https://github.com/nanotee/nvim-lua-guide#using-meta-accessors-1
local set = vim.opt

set.colorcolumn = "80" -- use visual indicator at 80 char mark
set.history = 100 -- keep 100 lines of command history
set.ruler = true -- always show the cursor position
set.showmatch = true -- show matching brackets and parentheses
set.visualbell = true -- make screen flash instead of audible beep
-- set.noerrorbells = true -- ignore errorbells
set.backup = false -- https://github.com/neoclide/coc.nvim/issues/649#issuecomment-480086894
set.writebackup = false -- https://github.com/neoclide/coc.nvim/issues/649#issuecomment-480086894
set.swapfile = false
set.laststatus = 2 -- always show the statusline
set.encoding = "utf-8" -- necessary to show Unicode glyphs
set.syntax = "on" -- syntax highlighting
set.mouse = "" -- disable that stupid mouse support as it breaks the clipboard
set.hidden = true -- make it possible to keep buffer undo history when changing buffers
set.shortmess = "filnxtToOFc" -- 'c' Don't pass messages to |ins-completion-menu|.

set.incsearch = true -- show match for partly typed search command
set.ignorecase = true -- ignore case when using a search pattern
set.smartcase = true -- override 'ignorecase' when pattern has upper case characters

set.wrap = true -- long lines wrap
set.cmdheight = 1 -- number of lines used for the command line
set.number = true -- show the line number for each line
set.scrolloff = 1 -- number of screen lines to show around the cursor
set.breakindent = true -- preserve indentation in wrapped text
set.sidescroll = 1 -- minimal number of columns to scroll horizontally

set.hlsearch = true -- highlight all matches for the last used search pattern
set.cursorline = false -- highlight the screen line of the cursor
set.termguicolors = true -- use GUI colors for the terminal, required by Bufferline

set.splitright = true -- verticallly-split window is put right of the current one
set.splitbelow = true -- horizontally-split window is put below of the current one

set.title = true -- show info in the window title

set.showcmd = true -- show (partial) command keys in the status line
set.showmode = true -- display the current mode in the status line
set.confirm = true -- start a dialog when a command fails

set.autoindent = true -- automatically set the indent of a new line
set.smarttab = true -- inserts blanks according to 'shiftwidth'
set.smartindent = true -- do clever autoindenting
set.tabstop = 2 -- number of spaces a <Tab> in the text stands for
set.shiftwidth = 2 -- number of spaces used for each step of (auto)indent
set.softtabstop = 2 -- number of spaces that a <Tab> counts for
set.backspace = { "indent", "eol", "start" } -- specifies what <BS>, CTRL-w, etc. can do in Insert mode
set.expandtab = true -- expand <Tab> to spaces in Insert mode

--set.clipboard:prepend { "unnamedplus" } -- to put selected text on the clipboard
set.fillchars.eob = " " -- hiding ~ that indicates filler lines
set.timeout = true
set.timeoutlen = 750 -- time to wait for a mapped sequence to complete (in milliseconds) default is 1000
set.ttimeout = true
set.ttimeoutlen = 50
set.undofile = true -- enable persistent undo
set.updatetime = 300 -- faster completion (4000ms default)
set.signcolumn = "yes:1" -- always show the sign column, otherwise it will shift the text each time diagnostics show

--vim.cmd "set whichwrap+=<,>,[,],h,l" -- wrap text at both left and right
vim.cmd [[set iskeyword+=-]] -- ask vim to treat '-' like a regular word character that should be skipped over by things like w or b

set.completeopt = { "menuone", "menu", "noselect", "preview" } -- mainly for cmp plugin
set.pumblend = 0

vim.g.clipboard = { -- Use gpaste to copy things in/out of clipboard with "*yy & "*p
  name = 'GPaste',
  copy = {
     ['+'] = 'gpaste-client add',
     ['*'] = 'gpaste-client add',
  },
  paste = {
     ['+'] = 'gpaste-client get --use-index 0',
     ['*'] = 'gpaste-client get --use-index 0',
  },
  cache_enabled = 0,
}
