local status, trim = pcall(require, "trim")
if (not status) then return end

trim.setup({
  ft_blocklist = {"markdown"},
})
