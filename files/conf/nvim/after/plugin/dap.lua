local status, dap = pcall(require, "dap")
if (not status) then return end

dap.configurations.lua = { 
  { 
    type = 'nlua', 
    request = 'attach',
    name = "Attach to running Neovim instance",
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end

local keymap = vim.keymap.set
local opts = { noremap = true }

keymap('n', '<F5>', [[:lua require"osv".launch({port = 8086})<CR>]], opts)
keymap('n', '<F8>', ":DapToggleBreakpoint<CR>", opts)
keymap('n', '<F9>', ":DapContinue<CR>", opts)
keymap('n', '<F10>', ":DapStepOver<CR>", opts)
keymap('n', '<S-F10>', ":DapStepInto<CR>", opts)
keymap('n', '<F11>', ":DapToggleRepl<CR><C-w>w", opts)
keymap('n', '<F12>', [[:lua require"dap.ui.widgets".hover()<CR>]], opts)

-- https://github.com/mfussenegger/nvim-dap/issues/415#issuecomment-1017180055
local augroup = vim.api.nvim_create_augroup("dap", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dap-float" },
    group = augroup,
    desc = "",
    command = "nnoremap <buffer><silent> q <cmd>close!<CR>"
})
