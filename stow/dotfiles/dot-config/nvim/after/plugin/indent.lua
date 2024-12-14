local status, indent = pcall(require, "indent_blankline")
if (not status) then return end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<Leader>it", "<Cmd>IndentBlanklineToggle<CR>", opts)
