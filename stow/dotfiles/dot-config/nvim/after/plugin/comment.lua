local status, comment = pcall(require, "Comment")
if (not status) then return end

-- https://github.com/numToStr/Comment.nvim#-usage
comment.setup({})
