local colorscheme = "solarized"
vim.o.background = "dark" -- "dark" or "light"; the background color brightness

if colorscheme == "gruvbox" then
    local status, gruvbox = pcall(require, "gruvbox")
    if (not status) then return end

    gruvbox.setup({
        contrast = "hard"
    })
end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    return
end
