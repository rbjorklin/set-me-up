local status, trouble = pcall(require, "trouble")
if (not status) then return end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<Leader>tt", "<Cmd>TroubleToggle<CR>", opts)
