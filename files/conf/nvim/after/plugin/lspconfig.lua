local status, lspconfig = pcall(require, "lspconfig")
if not status then return end

local status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status then return end

local keymap = vim.keymap.set

-- https://github.com/hrsh7th/cmp-nvim-lsp
local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig.ocamllsp.setup({
	capabilities = capabilities,
	-- Enable CodeLens
	on_attach = function(client, bufnr)
		local codelens = vim.api.nvim_create_augroup("LSPCodeLens", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold" }, {
			group = codelens,
			callback = function()
				vim.lsp.codelens.refresh()
			end,
			buffer = bufnr,
		})
	end,
})

-- Use `[g` and `]g` to navigate diagnostics
keymap("n", "]g", vim.diagnostic.goto_next, { silent = true })
keymap("n", "[g", vim.diagnostic.goto_prev, { silent = true })

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
		keymap("n", "gr", vim.lsp.buf.references, opts)
		keymap("n", "<leader>td", vim.lsp.buf.type_definition, opts)
		keymap("n", "K", vim.lsp.buf.hover, opts)
		keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
		keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		keymap("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
