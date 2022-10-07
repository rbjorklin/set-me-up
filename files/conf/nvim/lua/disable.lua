-- Disable vimscript filetype plugin
vim.g.did_load_ftplugin = 1

-- Use filetype.lua
-- https://neovim.io/doc/user/filetype.html
vim.g.did_load_filetypes = 0
vim.g.do_filetype_lua = 1

vim.g.loaded_man = 1

-- Stop loading built in plugins
-- https://vimhelp.org/#standard-plugin-list
vim.g.loaded_matchit = 1 -- TODO: reenable this?
vim.g.loaded_remote_plugins = 1
vim.g.loaded_netrw = 1 -- Reading and writing files over a network
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_gzip = 1 -- Reading and writing compressed files
vim.g.loaded_zip = 1 -- Zip archive explorer
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1 -- Tar file explorer
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1 -- Downloading latest version of Vim scripts
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1 -- Create a self-installing Vim script
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logipat = 1 -- Logical operators on patterns
vim.g.loaded_rrhelper = 1
--vim.g.loaded_matchparen = 1 -- Highlight matching parens
vim.g.loaded_spec = 1 -- Filetype plugin to work with rpm spec files
