local status, builtin = pcall(require, "telescope.builtin")
if (not status) then return end

local keymap = vim.keymap.set
keymap('n', '<LEADER>f', builtin.find_files, {})
keymap('n', '<LEADER>g', builtin.live_grep, {})
