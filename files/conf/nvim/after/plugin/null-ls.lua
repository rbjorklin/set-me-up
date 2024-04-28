local status, null_ls = pcall(require, "null-ls")
if not status then return end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    sources = {
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports_reviser,
        null_ls.builtins.formatting.golines,
        null_ls.builtins.formatting.ocamlformat, -- skip autoformat on save for a single write with ':noautocmd w' or ':noa w' for short.
        null_ls.builtins.formatting.hclfmt,
        null_ls.builtins.formatting.packer,
        null_ls.builtins.formatting.terraform_fmt,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.diagnostics.rstcheck,
        null_ls.builtins.diagnostics.yamllint,
    },
    -- Formatting on save - https://github.com/nvimtools/none-ls.nvim/wiki/Formatting-on-save
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
										vim.lsp.buf.formatting_sync()
                end,
            })
        end
    end,
})
