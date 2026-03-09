local status, lint = pcall(require, "lint")
if (not status) then return end

-- Check filetype with nvim command: := vim.bo.filetype
lint.linters_by_ft = {
    yaml = {'yamllint'},
    json = {'jsonlint'},
    markdown = {'markdownlint-cli2'}

  }
