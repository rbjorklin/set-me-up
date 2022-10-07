local fn = vim.fn
-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don"t error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    print("Packer is not installed")
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

-- https://github.com/wbthomason/packer.nvim#specifying-plugins
packer.startup(function(use)
    -- packer can manage itself!
    use "wbthomason/packer.nvim"

    -- nvim-tree file explorer
    use {
        "kyazdani42/nvim-tree.lua",
        --requires = { "kyazdani42/nvim-web-devicons" }
    }

    -- lsp config
    use { "neoclide/coc.nvim", branch = "release" }

    -- colorscheme
    use { "ishan9299/nvim-solarized-lua", as = "solarized" }

    -- symbol
    use "simrat39/symbols-outline.nvim"

    -- statusbar
    use {
        "nvim-lualine/lualine.nvim",
    }

    -- fuzzy search
    use "ctrlpvim/ctrlp.vim"

    -- Go support
    use {
        "fatih/vim-go",
        ft = { "go" }
    }

    -- Ocaml support
    use {
        "ocaml/vim-ocaml",
        ft = { "ocaml", "dune" }
    }

    -- Auto formating
    use {
        "sbdchd/neoformat",
        ft = { "ocaml" }
    }

    -- Surrond word with parentheses, quotes etc.
    use "tpope/vim-surround"

    -- Git plugin for vim
    use "tpope/vim-fugitive"

    -- treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
    }

    -- indentation guides
    use "lukas-reineke/indent-blankline.nvim"

    -- Automatically run packer.clean() followed by packer.update() after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
