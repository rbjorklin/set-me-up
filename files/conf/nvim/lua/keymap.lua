-- https://github.com/nanotee/nvim-lua-guide#vimkeymap
local keymap = vim.keymap.set

keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })

--*********** editing Text **********--
-- insert a new line without leaving normal mode
keymap("n", "<leader>no", "o<Esc>3\"_D")
keymap("n", "<leader>nO", "O<Esc>3\"_D")

--*********** buffer **********--
-- a new buffer
keymap("n", "<leader>new", ":new<cr>")

-- close the current buffer and move to the previous one
keymap("n", "<leader>bq", ":bp <bar> bd #<cr>")

--*********** windows **********--
-- navigate windows
--keymap("n", "<leader>h", "<c-w><c-h>")
keymap("n", "<leader>j", "<c-w><c-j>")
keymap("n", "<leader>k", "<c-w><c-k>")
keymap("n", "<leader>l", "<c-w><c-l>")

-- split windows
keymap("n", ",h", ":split<cr>")
keymap("n", ",v", ":vsplit<cr>")

-- resize windows
keymap("n", "<Left>", ":vertical resize +1<CR>")
keymap("n", "<Right>", ":vertical resize -1<CR>")
keymap("n", "<Down>", ":resize +1<CR>")
keymap("n", "<Up>", ":resize -1<CR>")

-- navigate buffers
keymap("n", "<S-l>", ":bnext<CR>")
keymap("n", "<S-h>", ":bprevious<CR>")

--*********** misc **********--
-- reload config without closing and reopening nvim
keymap("n", "<C-s><C-o>", ":so%<CR>")

-- remove all trailing whitespace by pressing F5
keymap("n", "<C-c><C-c>", [[:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>]])

-- Cancel search highlighting with ESC
keymap("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>")

-- toggle line numbering
keymap("n", "<F1>", ":set invnumber<CR>", { noremap = true })
-- toggle paste mode
keymap("n", "<leader>p", ":set invpaste<CR>", { noremap = true })
-- CtrlP fuzzy line search
keymap("n", "<leader>f", ":CtrlPLine<CR>", { noremap = true })
-- strip all trailing spaces
keymap("n", "<Leader><Leader>", [[ :%s/\s\+$//g<CR> ]], { noremap = true })
-- delete all empty lines or that only contain whitespace
keymap("n", "<Leader>l", [[ :g/^\s*$/d<CR> ]], { noremap = true })

-- Shift Insert does something magic?
keymap("", "<S-Insert>", [[ "*gP ]] )
keymap({"c", "i"}, "<S-Insert>", "<C-R>*")
