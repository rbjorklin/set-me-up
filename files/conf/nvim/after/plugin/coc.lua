-- https://github.com/neoclide/coc.nvim#example-lua-configuration
-- status returns false for some reason?
-- local status, coc = pcall(require, "coc.nvim")
-- if (not status) then return end

local keymap = vim.keymap.set

-- Highlight the symbol and its references when holding the cursor.
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

-- Coc.nvim
-- Use `[g` and `]g` to navigate diagnostics
keymap("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })
keymap("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })

-- Remap keys for gotos
-- See ':h jumplist' C-o & C-i to jump back & forth
keymap("n", "gd", "<Plug>(coc-definition)", { silent = true })
keymap("n", "gD", "<Plug>(coc-declaration)", { silent = true })
keymap("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keymap("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keymap("n", "gr", "<Plug>(coc-references)", { silent = true })
keymap("n", "gu", "<Plug>(coc-references-used)", { silent = true })

-- https://github.com/neoclide/coc.nvim/wiki/F.A.Q#how-to-show-documentation-of-symbol-under-cursor-also-known-as-cursor-hover
keymap("n", "<leader>h", ":call CocActionAsync('doHover')<CR>", { silent = true })

function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- https://github.com/neoclide/coc.nvim/issues/4251#issuecomment-1264594274
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}

-- Check other plugins before putting this into your config
keymap("i", "<TAB>", [[coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<Tab>" : coc#refresh()]], opts)
keymap("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> accept selected completion item or notify coc.nvim to format
keymap("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-space> to trigger completion.
keymap("i", "<c-space>", "coc#refresh()", opts)

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end

keymap("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

-- Symbol renaming.
keymap("n", "<leader>rn", "<Plug>(coc-rename)")

-- Formatting selected code.
--keymap({"n", "x"}, "<leader>f", "<Plug>(coc-format-selected)")

-- Remap for do codeAction of current line
keymap("n", "<leader>ac", "<Plug>(coc-codeaction)")

-- Fix autofix problem of current line
keymap("n", "<leader>qf", "<Plug>(coc-fix-current)")
