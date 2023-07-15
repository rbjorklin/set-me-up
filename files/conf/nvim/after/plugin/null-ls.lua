local status, null_ls = pcall(require, "null-ls")
if not status then return end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
    sources = {
        null_ls.builtins.formatting.ocamlformat,
        --null_ls.builtins.formatting.stylua,
        --null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.hclfmt,
        --null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.packer,
        null_ls.builtins.formatting.terraform_fmt,
        --null_ls.builtins.formatting.yq,
        --null_ls.builtins.formatting.sqlfluff.with({
        --    extra_args = { "--dialect", "postgres" }, -- change to your dialect
        --}),
        null_ls.builtins.completion.spell,
        null_ls.builtins.completion.luasnip,
        null_ls.builtins.code_actions.gitsigns,
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.diagnostics.jsonlint,
        null_ls.builtins.diagnostics.rstcheck,
        null_ls.builtins.diagnostics.yamllint,
    },
    -- Formatting on save - https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
})
