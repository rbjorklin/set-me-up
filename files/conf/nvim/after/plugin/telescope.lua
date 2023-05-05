local status, builtin = pcall(require, "telescope.builtin")
if (not status) then return end

local keymap = vim.keymap.set
keymap('n', '<LEADER>f', builtin.find_files, {})
keymap('n', '<LEADER>g', builtin.live_grep, {})
keymap('n', '<LEADER>t?', builtin.oldfiles, { desc = '[t?] Find recently opened files'})
keymap('n', '<LEADER>t<SPACE>', builtin.buffers, { desc = '[t ] Find existing buffers'})
keymap('n', '<LEADER>t/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[t/] Fuzzily search in current buffer' })

keymap('n', '<LEADER>tsh', require('telescope.builtin').help_tags, { desc = '[T]elescope [S]earch [H]elp' })
keymap('n', '<LEADER>tk', require('telescope.builtin').keymaps, { desc = '[T]elescope [K]eymaps Help' })
