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
        "nvim-tree/nvim-tree.lua",
    }

    -- lsp config
    use {
        "neoclide/coc.nvim",
        tag = "v0.0.82"
        --branch = "release"
        -- any newer commit on the 'release' branch breaks CodeLens
        --commit = "7330319e1f68cb9f5ea1ab31a984680be493ea85" -- OK
        --commit = "668e854c49b71fc1a0498e018832f4d237812c3b" -- NOK
    }

    -- colorscheme
    use {
        "rbjorklin/nvim-solarized-lua",
        as = "solarized",
        branch = "use-all-colors"
    }

    -- symbol
    use {
        "geekifan/symbols-outline.nvim",
        branch = "master"
    }

    -- bufferline
    use {
        "akinsho/bufferline.nvim",
        tag = "v3.7.0"
    }

    -- statusbar
    use {
        "nvim-lualine/lualine.nvim",
    }

    -- fuzzy search
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Auto formating
    use {
        "mhartington/formatter.nvim"
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
    use { "nvim-treesitter/nvim-treesitter-context" }

    use {
        -- :TSHighlightCapturesUnderCursor
        "nvim-treesitter/playground",
        opt = true,
        cmd = {'TSHighlightCapturesUnderCursor'},
    }

    -- better matching
    use {
        "andymass/vim-matchup"
    }

    -- more intuitive navigation
    use "ggandor/leap.nvim"

    -- Debug using DAP
    use {
        'mfussenegger/nvim-dap',
        opt = true,
        cmd = { 'DapToggleBreakpoint',
                'DapContinue',
                'DapStepOver',
                'DapStepInto',
                'DapToggleRepl',
        },
    }

    -- Debug neovim
    use 'jbyuki/one-small-step-for-vimkind'

    -- indentation guides
    use "lukas-reineke/indent-blankline.nvim"

    -- Automatically run packer.clean() followed by packer.update() after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
