local colorscheme = "selenized"

if colorscheme == "gruvbox" then
    local status, gruvbox = pcall(require, "gruvbox")
    if (not status) then return end

    gruvbox.setup({
        contrast = "hard"
    })
end

if colorscheme == "selenized" then
    vim.g.selenized_variant = "bw" -- "normal" or "bw" for high contrast variant
    vim.o.background = "dark" -- "dark" or "light"; the background color brightness
end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    return
end
