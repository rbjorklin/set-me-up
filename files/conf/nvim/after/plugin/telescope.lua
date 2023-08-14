local status, builtin = pcall(require, "telescope.builtin")
if (not status) then return end

local keymap = vim.keymap.set
keymap('n', '<LEADER>fi', builtin.find_files, {})
keymap('n', '<LEADER>g', builtin.live_grep, {})
keymap('n', '<LEADER>t?', builtin.oldfiles, { desc = '[t?] Find recently opened files'})
keymap('n', '<LEADER>t<SPACE>', builtin.buffers, { desc = '[t ] Find existing buffers'})
keymap('n', '<LEADER>t/', function()
  builtin.current_buffer_fuzzy_find(builtin.get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[t/] Fuzzily search in current buffer' })

keymap('n', '<LEADER>tsh', builtin.help_tags, { desc = '[T]elescope [S]earch [H]elp' })
keymap('n', '<LEADER>tk', builtin.keymaps, { desc = '[T]elescope [K]eymaps Help' })
keymap('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
keymap('n', 'gr', builtin.lsp_references, { desc = '[G]oto [R]eferences' })
