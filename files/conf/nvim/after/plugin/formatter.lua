local status, formatter = pcall(require, "formatter")
if (not status) then return end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
formatter.setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    ocaml = {
      require("formatter.filetypes.ocaml")
    }
  }
}

local format_auto_group = vim.api.nvim_create_augroup("FormatAutoGroup", {})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.ml,*.mli" },
    group = format_auto_group,
    desc = "ocamlformat on save",
    command = "FormatWrite"
})
