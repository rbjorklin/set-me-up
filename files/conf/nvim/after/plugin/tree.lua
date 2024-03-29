local status, tree = pcall(require, "nvim-tree")
if (not status) then return end

local lib = require "nvim-tree.lib"

-- [credit] https://github.com/alex-courtis/arch/blob/c91322f51c41c2ace04614eff3a37f13e5f22a24/config/nvim/lua/nvt.lua
local function cd_dot_cb(node)
    tree.change_dir(vim.fn.getcwd(-1))
    if node.name ~= ".." then
        lib.set_index_and_redraw(node.absolute_path)
    end
end

tree.setup({
    sort_by = "case_sensitive",
    renderer = {
        icons = {
            glyphs = {
                git = {
                    unstaged = "⊛"
                }
            }
        }
    },
    filters = {
        -- hide .git folder
        custom = { "^\\.git$" }
    },
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            error = " ",
            warning = " ",
            info = " ",
            hint = " "
        },
    },
})

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<Leader>te", "<Cmd>NvimTreeToggle<CR>", opts)
keymap("n", "<Leader>tf", "<Cmd>NvimTreeFocus<CR>", opts)
