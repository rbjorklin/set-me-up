--local status, playground = pcall(require, "nvim-treesitter.configs")
--if (not status) then return end

local keymap = vim.keymap.set
local opts = { noremap = true }

keymap("n", "<Leader>tuc", ":TSHighlightCapturesUnderCursor<CR>", opts)
