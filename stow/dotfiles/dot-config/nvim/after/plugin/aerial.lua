local status, aerial = pcall(require, "aerial")
if (not status) then return end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

aerial.setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    keymap("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    keymap("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})


keymap("n", "<Leader>so", "<Cmd>AerialToggle right<CR>", opts)
