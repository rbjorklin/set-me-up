local status, lint = pcall(require, "lint")
if (not status) then return end

-- Check filetype with nvim command: := vim.bo.filetype
lint.linters_by_ft = {
    yaml = {'yamllint'},
    json = {'jsonlint'},
    markdown = {'markdownlint-cli2'}

}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
})
