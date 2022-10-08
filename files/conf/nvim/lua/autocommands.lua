local augroup = vim.api.nvim_create_augroup("user_cmds", { clear = true })

-- Go support
-- This should be automatic but just incase here's the detection:
-- autocmd BufNewFile,BufRead *.go setlocal ft=go
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go" },
    group = augroup,
    desc = "",
    command = "setlocal shiftwidth=8 tabstop=8 softtabstop=4 foldmethod=syntax"
})

-- Ocaml support
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "ocaml" },
    group = augroup,
    desc = "",
    command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2"
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.ml,*.mli" },
    group = augroup,
    desc = "ocamlformat on save",
    command = [[try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry]]
})

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid or when inside an event handler
-- (happens when dropping a file on gvim).
-- Also don't do it when the mark is in the first line, that is the default
-- position when opening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = { "*" },
    group = augroup,
    desc = "",
    command = [[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]]
})
