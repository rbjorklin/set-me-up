local status, lspconfig = pcall(require, "lspconfig")
if not status then return end

local status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status then return end

local keymap = vim.keymap.set

-- https://github.com/hrsh7th/cmp-nvim-lsp
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Enable CodeLens
local on_attach = function(client, bufnr)
	local codelens = vim.api.nvim_create_augroup("LSPCodeLens", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold" }, {
		group = codelens,
		callback = function()
			vim.lsp.codelens.refresh()
		end,
		buffer = bufnr,
	})
end

lspconfig.ocamllsp.setup({
	capabilities = capabilities,
	on_attach = on_attach,
    settings = {
        codelens = { enable = true },
    },
})

lspconfig.gopls.setup({
	capabilities = capabilities,
    cmd = {"gopls"},
    filetypes = {"go", "gomod", "gowork", "gotmpl" },
    --root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	  single_file_support = true,
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unusedparams = true,
            }
        }
    }
})

lspconfig.bashls.setup({})

-- Use `[g` and `]g` to navigate diagnostics
keymap("n", "]g", vim.diagnostic.goto_next, { silent = true })
keymap("n", "[g", vim.diagnostic.goto_prev, { silent = true })
keymap("n", "<leader>do", vim.diagnostic.open_float, { noremap = true, silent = true })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		-- See ':h jumplist' C-o & C-i to jump back & forth
		keymap("n", "gd", vim.lsp.buf.definition, opts)
		keymap("n", "gD", vim.lsp.buf.declaration, opts)
		keymap("n", "gi", vim.lsp.buf.implementation, opts)
		--keymap("n", "gr", vim.lsp.buf.references, opts)
		keymap("n", "<leader>td", vim.lsp.buf.type_definition, opts)
		keymap("n", "K", function() vim.lsp.buf.hover({ border = "rounded"}) end, opts)
		keymap("n", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, opts)
		keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
		keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		keymap("n", "<leader>fo", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})
