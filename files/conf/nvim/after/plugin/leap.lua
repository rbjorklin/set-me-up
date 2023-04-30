local status, leap = pcall(require, "leap")
if (not status) then return end

local keymap = vim.keymap.set
keymap("n", "<leader>s", "<Plug>(leap-forward)", {})
keymap("n", "<leader>S", "<Plug>(leap-backward)", {})
