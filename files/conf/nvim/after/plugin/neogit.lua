local status, neogit = pcall(require, "neogit")
if not status then return end

local keymap = vim.keymap.set
local opts = {silent = true, noremap = true}

keymap("n", "<leader>gs", neogit.open, opts)
keymap("n", "<leader>gc", ":Neogit commit<CR>", opts)
keymap("n", "<leader>gp", ":Neogit pull<CR>", opts)
keymap("n", "<leader>gP", ":Neogit push<CR>", opts)
keymap("n", "<Leader>gb", ":Telescope git_branches<CR>", opts)

-- Visual selection can be enabled with shift+v when staging changes.
neogit.setup({})
