local status, bufferline = pcall(require, "bufferline")
if (not status) then return end

bufferline.setup({
    options = {
        mode = "tabs",
        separator_style = "thick",
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        show_buffer_icons = true,
        show_close_icon = false,
        show_tap_indicators = true,
        color_icons = true,
        diagnostics = true,
        offsets = {
            {
                filetype = "NvimTree",
                text = function()
                    return vim.fn.getcwd()
                end,
                highlight = "Directory",
                text_align = "left",
                padding = 1
            }
        }
    },
})

local keymap = vim.keymap.set

keymap("n", "<space>bc", "<Cmd>BufferLinePickClose<CR>")
keymap("n", "<space>bp", "<Cmd>BufferLinePick<CR>")
keymap("n", "<space>bcr", "<Cmd>BufferLineCloseRight<CR>")
keymap("n", "<space>bcl", "<Cmd>BufferLineCloseLeft<CR>")
keymap("n", "<C-I>", "<C-I>", { noremap = true })
keymap("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>")
keymap("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>")
